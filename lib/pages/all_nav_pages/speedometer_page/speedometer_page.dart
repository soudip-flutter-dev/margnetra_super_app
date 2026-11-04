import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:margnetra_super_app/core/app_services/local_storage/shared_pref_service.dart';
import 'package:margnetra_super_app/core/app_services/speed_service/speed_service.dart';
import 'package:margnetra_super_app/pages/all_nav_pages/speedometer_page/logic/blocs/speedometer_socket_bloc/speedometer_socket_bloc.dart';
import 'package:margnetra_super_app/pages/all_nav_pages/speedometer_page/widgets/socket_status_badge.dart';
import 'package:margnetra_super_app/pages/profile_page/data/repositories/user_repository.dart';
import 'package:margnetra_super_app/pages/profile_page/logic/blocs/vehicle_bloc/vehicle_bloc.dart';
import 'package:margnetra_super_app/pages/profile_page/widgets/add_vehicle_bottom_sheet.dart';
import 'widgets/permission_error_card.dart';
import 'widgets/speed_gauge_view.dart';

/// SpeedometerScreen shows real-time GPS vehicle speed with unit toggles,
/// a radial gauge, live telemetry WebSocket connection, trip stats,
/// and responsive permission/service handling.
class SpeedometerScreen extends StatefulWidget {
  const SpeedometerScreen({super.key});

  @override
  State<SpeedometerScreen> createState() => _SpeedometerScreenState();
}

class _SpeedometerScreenState extends State<SpeedometerScreen> with WidgetsBindingObserver {
  final SpeedService _speedService = SpeedService();

  StreamSubscription<double>? _speedSubscription;
  StreamSubscription<SpeedServiceStatus>? _statusSubscription;

  double _currentSpeedMps = 0.0;
  double _maxSpeedMps = 0.0;
  SpeedUnit _selectedUnit = SpeedUnit.kmh;
  SpeedServiceStatus _status = SpeedServiceStatus.checking;
  String? _errorMessage;

  bool _isVehicleRegistered = false;
  bool _isBottomSheetOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    _isVehicleRegistered = SharedPrefService.instance.isVehicleRegistered;
    _initializeLocationTracking();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<VehicleBloc>().add(const LoadVehiclesEvent());
        context.read<SpeedometerSocketBloc>().add(const SpeedometerSocketConnect());
        _checkVehicleStatusAndPromptIfNeeded();
      }
    });
  }

  Future<void> _checkVehicleStatusAndPromptIfNeeded() async {
    // 1. If already registered according to local DB, no need to show bottomsheet
    if (SharedPrefService.instance.isVehicleRegistered) {
      if (!_isVehicleRegistered) {
        setState(() {
          _isVehicleRegistered = true;
        });
      }
      return;
    }

    // 2. Check if registered on backend before prompting bottomsheet
    try {
      final userRepo = UserRepository();
      final profile = await userRepo.getUserProfile();
      if (profile.vehiclesCount > 0) {
        await SharedPrefService.instance.setVehicleRegistered(true);
        if (mounted) {
          setState(() {
            _isVehicleRegistered = true;
          });
        }
        return;
      }
      final vehicles = await userRepo.getVehicles();
      if (vehicles.isNotEmpty) {
        await SharedPrefService.instance.setVehicleRegistered(true);
        if (mounted) {
          setState(() {
            _isVehicleRegistered = true;
          });
        }
        return; // Registered on server! DO NOT show bottomsheet!
      }
    } catch (_) {}

    // 3. Not registered anywhere -> prompt registration bottomsheet
    if (mounted && !SharedPrefService.instance.isVehicleRegistered) {
      _checkAndPromptVehicleRegistration();
    }
  }

  Future<void> _checkAndPromptVehicleRegistration() async {
    if (!mounted || _isBottomSheetOpen) return;

    if (SharedPrefService.instance.isVehicleRegistered) {
      if (!_isVehicleRegistered) {
        setState(() {
          _isVehicleRegistered = true;
        });
      }
      return;
    }

    _isBottomSheetOpen = true;
    final result = await AddVehicleBottomSheet.show(context, isLocked: true);
    _isBottomSheetOpen = false;

    if (!mounted) return;

    final registered = result == true || SharedPrefService.instance.isVehicleRegistered;
    setState(() {
      _isVehicleRegistered = registered;
    });

    // If bottom sheet was closed without registration and still not in local DB, re-prompt
    if (!registered && !SharedPrefService.instance.isVehicleRegistered) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !SharedPrefService.instance.isVehicleRegistered) {
          _checkAndPromptVehicleRegistration();
        }
      });
    }
  }

  void _initializeLocationTracking() {
    // 1. Listen to speed updates (UI only listens to the speed stream)
    _speedSubscription = _speedService.speedStream.listen((double speedMps) {
      if (!mounted) return;
      setState(() {
        _currentSpeedMps = speedMps;
        if (speedMps > _maxSpeedMps) {
          _maxSpeedMps = speedMps;
        }
      });

      // Stream real-time telemetry to the WebSocket if vehicle is registered and socket is active
      if (_isVehicleRegistered) {
        final socketBloc = context.read<SpeedometerSocketBloc>();
        if (socketBloc.state.isConnected) {
          final double speedKmh = speedMps * 3.6;
          final position = _speedService.lastPosition;

          socketBloc.add(
            SpeedometerSocketSendCurrentData(
              speedKmh: double.parse(speedKmh.toStringAsFixed(1)),
              latitude: position?.latitude,
              longitude: position?.longitude,
            ),
          );
        }
      }
    });

    // 2. Listen to service & permission status updates
    _statusSubscription = _speedService.statusStream.listen((SpeedServiceStatus status) {
      if (!mounted) return;
      setState(() {
        _status = status;
        _errorMessage = _speedService.errorMessage;
      });
    });

    // 3. Initiate tracking check
    _speedService.startTracking();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Re-check permissions when user returns from system settings
    if (state == AppLifecycleState.resumed &&
        (_status == SpeedServiceStatus.serviceDisabled ||
            _status == SpeedServiceStatus.permissionDeniedForever ||
            _status == SpeedServiceStatus.permissionDenied)) {
      _speedService.startTracking();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _speedSubscription?.cancel();
    _statusSubscription?.cancel();
    _speedService.dispose();
    super.dispose();
  }

  void _resetMaxSpeed() {
    setState(() {
      _maxSpeedMps = _isVehicleRegistered ? _currentSpeedMps : 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double effectiveCurrentSpeedMps = _isVehicleRegistered ? _currentSpeedMps : 0.0;
    final double effectiveMaxSpeedMps = _isVehicleRegistered ? _maxSpeedMps : 0.0;
    final double convertedCurrentSpeed = _selectedUnit.convertFromMps(effectiveCurrentSpeedMps);
    final double convertedMaxSpeed = _selectedUnit.convertFromMps(effectiveMaxSpeedMps);
    final bool hasError = _status != SpeedServiceStatus.active &&
        _status != SpeedServiceStatus.checking &&
        _status != SpeedServiceStatus.initial;

    return MultiBlocListener(
      listeners: [
        BlocListener<VehicleBloc, VehicleState>(
          listener: (context, state) {
            if (state is VehicleAddSuccess || state is VehicleRegistrationSuccess) {
              SharedPrefService.instance.setVehicleRegistered(true);
              setState(() {
                _isVehicleRegistered = true;
              });
              if (_isBottomSheetOpen && Navigator.of(context).canPop()) {
                Navigator.of(context, rootNavigator: true).maybePop(true);
              }
            } else if (state is VehicleLoaded) {
              final isReg = state.vehicles.isNotEmpty || SharedPrefService.instance.isVehicleRegistered;
              if (isReg) {
                SharedPrefService.instance.setVehicleRegistered(true);
                if (_isBottomSheetOpen && Navigator.of(context).canPop()) {
                  Navigator.of(context, rootNavigator: true).maybePop(true);
                }
                if (!_isVehicleRegistered) {
                  setState(() {
                    _isVehicleRegistered = true;
                  });
                }
              }
            }
          },
        ),
        BlocListener<SpeedometerSocketBloc, SpeedometerSocketState>(
          listener: (context, socketState) {
            if (_isVehicleRegistered && socketState.telemetry != null) {
              final telemetrySpeedMps = socketState.telemetry!.gps.speedKmh / 3.6;
              if (socketState.isSimulated || (_currentSpeedMps <= 0.0 && telemetrySpeedMps > 0.0)) {
                setState(() {
                  _currentSpeedMps = telemetrySpeedMps;
                  if (telemetrySpeedMps > _maxSpeedMps) {
                    _maxSpeedMps = telemetrySpeedMps;
                  }
                });
              }
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFF010A12),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          title: const Text(
            'GPS SPEEDOMETER',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: 2.0,
              color: Colors.white,
            ),
          ),
          actions: [
            const SocketStatusBadge(),
            const SizedBox(width: 8),
            _buildGpsStatusBadge(),
            const SizedBox(width: 12),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Vehicle registration lock alert if not registered
              if (!_isVehicleRegistered)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: InkWell(
                    onTap: _checkAndPromptVehicleRegistration,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A1C08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFFFB300).withValues(alpha: 0.5)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.lock, color: Color(0xFFFFB300), size: 20),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text(
                              'Speedometer locked. Register your vehicle to view live GPS speed.',
                              style: TextStyle(
                                color: Color(0xFFFFD54F),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFB300),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'Register',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // Permission or Location service alert
              if (hasError)
                PermissionErrorCard(
                  status: _status,
                  errorMessage: _errorMessage,
                  onRetry: () => _speedService.startTracking(),
                  onOpenAppSettings: () => _speedService.openAppSettings(),
                  onOpenLocationSettings: () => _speedService.openLocationSettings(),
                ),

              // Top Control Bar: Unit toggle (km/h vs mph)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'UNITS',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                      ),
                    ),
                    _buildUnitToggle(),
                  ],
                ),
              ),

              // Main Speedometer Gauge
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: SpeedGaugeView(
                            currentSpeed: convertedCurrentSpeed,
                            unit: _selectedUnit,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom Trip & Stats Bar with Live RPM
              _buildStatsFooter(convertedMaxSpeed),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGpsStatusBadge() {
    Color dotColor;
    String statusLabel;

    switch (_status) {
      case SpeedServiceStatus.active:
        dotColor = const Color(0xFF00E676);
        statusLabel = 'GPS ACTIVE';
        break;
      case SpeedServiceStatus.checking:
        dotColor = Colors.amberAccent;
        statusLabel = 'SEARCHING';
        break;
      default:
        dotColor = Colors.redAccent;
        statusLabel = 'NO GPS';
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF131D2A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: dotColor.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: dotColor.withValues(alpha: 0.6),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Text(
            statusLabel,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: dotColor,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnitToggle() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF131D2A),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white12),
      ),
      padding: const EdgeInsets.all(3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildUnitOption(SpeedUnit.kmh, 'KM/H'),
          _buildUnitOption(SpeedUnit.mph, 'MPH'),
        ],
      ),
    );
  }

  Widget _buildUnitOption(SpeedUnit unit, String text) {
    final bool isSelected = _selectedUnit == unit;
    return GestureDetector(
      onTap: () {
        if (_selectedUnit != unit) {
          setState(() {
            _selectedUnit = unit;
          });
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF00E5FF) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF00E5FF).withValues(alpha: 0.35),
                    blurRadius: 8,
                    spreadRadius: 1,
                  )
                ]
              : null,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? const Color(0xFF010A12) : Colors.white60,
            fontWeight: FontWeight.bold,
            fontSize: 13,
            letterSpacing: 1.0,
          ),
        ),
      ),
    );
  }

  Widget _buildStatsFooter(double convertedMaxSpeed) {
    final String formattedMax = convertedMaxSpeed <= 0.0
        ? '0'
        : convertedMaxSpeed < 10
            ? convertedMaxSpeed.toStringAsFixed(1)
            : convertedMaxSpeed.toStringAsFixed(0);

    return BlocBuilder<SpeedometerSocketBloc, SpeedometerSocketState>(
      builder: (context, socketState) {
        final int currentRpm = _isVehicleRegistered ? socketState.currentRpm : 0;

        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFF0F1E2E),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Max Speed stat
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'MAX SPEED',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        formattedMax,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _selectedUnit.label,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.cyanAccent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Live RPM stat from telemetry
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'ENGINE RPM',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        currentRpm.toString(),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00E5FF),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'RPM',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.cyanAccent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Reset Max button
              TextButton.icon(
                onPressed: _resetMaxSpeed,
                icon: const Icon(Icons.refresh, size: 16, color: Colors.white60),
                label: const Text(
                  'RESET',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF131D2A),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
