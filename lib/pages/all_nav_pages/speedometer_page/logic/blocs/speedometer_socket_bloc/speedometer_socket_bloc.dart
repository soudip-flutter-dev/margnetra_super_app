import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:margnetra_super_app/core/app_services/api_services/api_urls.dart';
import 'package:margnetra_super_app/core/app_services/local_storage/shared_pref_service.dart';
import 'package:margnetra_super_app/pages/all_nav_pages/speedometer_page/data/models/telemetry_socket_model.dart';
import 'package:margnetra_super_app/pages/all_nav_pages/speedometer_page/data/services/telemetry_socket_service.dart';
import 'package:margnetra_super_app/pages/all_nav_pages/speedometer_page/logic/blocs/speedometer_socket_bloc/speedometer_socket_event.dart';
import 'package:margnetra_super_app/pages/all_nav_pages/speedometer_page/logic/blocs/speedometer_socket_bloc/speedometer_socket_state.dart';

export 'speedometer_socket_event.dart';
export 'speedometer_socket_state.dart';

class SpeedometerSocketBloc
    extends Bloc<SpeedometerSocketEvent, SpeedometerSocketState> {
  final TelemetrySocketService _socketService;
  StreamSubscription<SocketConnectionStatus>? _statusSubscription;
  StreamSubscription<TelemetrySocketModel>? _telemetrySubscription;

  int _packetsSent = 0;
  int _packetsReceived = 0;
  TelemetrySocketModel? _latestTelemetry;
  String _activeVehicleId = ApiUrls.defaultTelemetryVehicleId;

  SpeedometerSocketBloc({TelemetrySocketService? socketService})
      : _socketService = socketService ?? TelemetrySocketService(),
        super(const SpeedometerSocketInitial()) {
    on<SpeedometerSocketConnect>(_onConnect);
    on<SpeedometerSocketDisconnect>(_onDisconnect);
    on<SpeedometerSocketSendTelemetry>(_onSendTelemetry);
    on<SpeedometerSocketSendCurrentData>(_onSendCurrentData);
    on<SpeedometerSocketStatusUpdated>(_onStatusUpdated);
    on<SpeedometerSocketDataReceived>(_onDataReceived);

    _bindSocketStreams();
  }

  void _bindSocketStreams() {
    _statusSubscription = _socketService.statusStream.listen((status) {
      add(SpeedometerSocketStatusUpdated(
        status: status,
        errorMessage: _socketService.lastError,
      ));
    });

    _telemetrySubscription = _socketService.telemetryStream.listen((telemetry) {
      add(SpeedometerSocketDataReceived(telemetry: telemetry));
    });
  }

  Future<void> _onConnect(
    SpeedometerSocketConnect event,
    Emitter<SpeedometerSocketState> emit,
  ) async {
    // 1. Resolve vehicle ID from event, saved registered vehicle, or default fallback
    final registeredVehicle = SharedPrefService.instance.getRegisteredVehicle();
    final savedVehicleId = registeredVehicle?['id']?.toString();
    _activeVehicleId = event.vehicleId ?? savedVehicleId ?? ApiUrls.defaultTelemetryVehicleId;

    // 2. Resolve token
    final authToken = SharedPrefService.instance.getAuthToken();
    final token = event.token ??
        (authToken?.isNotEmpty == true
            ? authToken!
            : ApiUrls.defaultTelemetryToken);

    // 3. Resolve target URL
    final url = event.url ?? ApiUrls.getTelemetrySocketUrl(token: token);

    emit(SpeedometerSocketConnecting(
      telemetry: _latestTelemetry,
      packetsSent: _packetsSent,
      packetsReceived: _packetsReceived,
      activeVehicleId: _activeVehicleId,
    ));

    await _socketService.connect(url: url);
  }

  Future<void> _onDisconnect(
    SpeedometerSocketDisconnect event,
    Emitter<SpeedometerSocketState> emit,
  ) async {
    await _socketService.disconnect();
    emit(SpeedometerSocketDisconnected(
      telemetry: _latestTelemetry,
      packetsSent: _packetsSent,
      packetsReceived: _packetsReceived,
      activeVehicleId: _activeVehicleId,
    ));
  }

  void _onSendTelemetry(
    SpeedometerSocketSendTelemetry event,
    Emitter<SpeedometerSocketState> emit,
  ) {
    _latestTelemetry = event.telemetry;
    final success = _socketService.sendTelemetry(event.telemetry);
    if (success) {
      _packetsSent++;
    }

    emit(SpeedometerSocketDataUpdated(
      telemetry: _latestTelemetry,
      packetsSent: _packetsSent,
      packetsReceived: _packetsReceived,
      activeVehicleId: _activeVehicleId,
    ));
  }

  void _onSendCurrentData(
    SpeedometerSocketSendCurrentData event,
    Emitter<SpeedometerSocketState> emit,
  ) {
    final vehicleId = event.vehicleId ?? _activeVehicleId;
    final telemetry = TelemetrySocketModel(
      vehicleId: vehicleId,
      gps: GpsTelemetry(
        latitude: event.latitude ?? 22.5740,
        longitude: event.longitude ?? 88.3650,
        speedKmh: double.parse(event.speedKmh.toStringAsFixed(1)),
      ),
      vehicle: VehicleTelemetry(
        rpm: event.rpm ?? _calculateRpm(event.speedKmh),
      ),
    );

    add(SpeedometerSocketSendTelemetry(telemetry: telemetry));
  }

  void _onStatusUpdated(
    SpeedometerSocketStatusUpdated event,
    Emitter<SpeedometerSocketState> emit,
  ) {
    switch (event.status) {
      case SocketConnectionStatus.connected:
        emit(SpeedometerSocketConnected(
          telemetry: _latestTelemetry,
          packetsSent: _packetsSent,
          packetsReceived: _packetsReceived,
          activeVehicleId: _activeVehicleId,
        ));
        break;
      case SocketConnectionStatus.connecting:
        emit(SpeedometerSocketConnecting(
          telemetry: _latestTelemetry,
          packetsSent: _packetsSent,
          packetsReceived: _packetsReceived,
          activeVehicleId: _activeVehicleId,
        ));
        break;
      case SocketConnectionStatus.disconnected:
        emit(SpeedometerSocketDisconnected(
          telemetry: _latestTelemetry,
          packetsSent: _packetsSent,
          packetsReceived: _packetsReceived,
          activeVehicleId: _activeVehicleId,
        ));
        break;
      case SocketConnectionStatus.error:
        emit(SpeedometerSocketError(
          errorMessage: event.errorMessage ?? 'WebSocket connection failed',
          telemetry: _latestTelemetry,
          packetsSent: _packetsSent,
          packetsReceived: _packetsReceived,
          activeVehicleId: _activeVehicleId,
        ));
        break;
    }
  }

  void _onDataReceived(
    SpeedometerSocketDataReceived event,
    Emitter<SpeedometerSocketState> emit,
  ) {
    _packetsReceived++;
    _latestTelemetry = event.telemetry;
    emit(SpeedometerSocketDataUpdated(
      telemetry: _latestTelemetry,
      packetsSent: _packetsSent,
      packetsReceived: _packetsReceived,
      activeVehicleId: _activeVehicleId,
    ));
  }

  /// Calculates estimated engine RPM based on current speed in km/h if direct OBD-II RPM is not supplied.
  int _calculateRpm(double speedKmh) {
    if (speedKmh <= 0.0) return 0;
    final rpm = 800 + (speedKmh * 25).round();
    return rpm.clamp(0, 7000);
  }

  @override
  Future<void> close() {
    _statusSubscription?.cancel();
    _telemetrySubscription?.cancel();
    _socketService.dispose();
    return super.close();
  }
}
