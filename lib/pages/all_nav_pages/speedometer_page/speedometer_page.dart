import 'dart:async';
import 'package:flutter/material.dart';
import 'package:margnetra_super_app/core/app_services/speed_service/speed_service.dart';
import 'widgets/permission_error_card.dart';
import 'widgets/speed_gauge_view.dart';

/// SpeedometerScreen shows real-time GPS vehicle speed with unit toggles,
/// a radial gauge, trip stats, and responsive permission/service handling.
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    _initializeLocationTracking();
  }

  void _initializeLocationTracking() {
    // 1. Listen to speed updates (UI only listens to the speed stream)
    _speedSubscription = _speedService.speedStream.listen((double speedMps) {
      if (!mounted) return;
      setState(() {
        _currentSpeedMps = speedMps;
        print("_currentSpeedMps: $_currentSpeedMps");
        if (speedMps > _maxSpeedMps) {
          _maxSpeedMps = speedMps;
        }
      });
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
    // Explicitly cancel subscriptions and clean up service
    _speedSubscription?.cancel();
    _statusSubscription?.cancel();
    _speedService.dispose();
    super.dispose();
  }

  void _resetMaxSpeed() {
    setState(() {
      _maxSpeedMps = _currentSpeedMps;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double convertedCurrentSpeed = _selectedUnit.convertFromMps(_currentSpeedMps);
    final double convertedMaxSpeed = _selectedUnit.convertFromMps(_maxSpeedMps);
    final bool hasError = _status != SpeedServiceStatus.active &&
        _status != SpeedServiceStatus.checking &&
        _status != SpeedServiceStatus.initial;

    return Scaffold(
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
          _buildGpsStatusBadge(),
          const SizedBox(width: 12),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
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

            // Bottom Trip & Stats Bar
            _buildStatsFooter(convertedMaxSpeed),
          ],
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
          TextButton.icon(
            onPressed: _resetMaxSpeed,
            icon: const Icon(Icons.refresh, size: 16, color: Colors.white60),
            label: const Text(
              'RESET MAX',
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
  }
}
