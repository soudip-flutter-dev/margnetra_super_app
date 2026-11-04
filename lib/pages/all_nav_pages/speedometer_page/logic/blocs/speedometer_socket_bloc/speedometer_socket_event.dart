import 'package:equatable/equatable.dart';
import 'package:margnetra_super_app/pages/all_nav_pages/speedometer_page/data/models/telemetry_socket_model.dart';
import 'package:margnetra_super_app/pages/all_nav_pages/speedometer_page/data/services/telemetry_socket_service.dart';

abstract class SpeedometerSocketEvent extends Equatable {
  const SpeedometerSocketEvent();

  @override
  List<Object?> get props => [];
}

/// Connects to the telemetry socket.
class SpeedometerSocketConnect extends SpeedometerSocketEvent {
  final String? url;
  final String? token;
  final String? vehicleId;

  const SpeedometerSocketConnect({
    this.url,
    this.token,
    this.vehicleId,
  });

  @override
  List<Object?> get props => [url, token, vehicleId];
}

/// Disconnects from the telemetry socket.
class SpeedometerSocketDisconnect extends SpeedometerSocketEvent {
  const SpeedometerSocketDisconnect();
}

/// Toggles offline simulated telemetry mode for testing without a live backend.
class SpeedometerSocketToggleSimulation extends SpeedometerSocketEvent {
  final bool enable;

  const SpeedometerSocketToggleSimulation({required this.enable});

  @override
  List<Object?> get props => [enable];
}

/// Dispatches an explicit [TelemetrySocketModel] packet over the socket.
class SpeedometerSocketSendTelemetry extends SpeedometerSocketEvent {
  final TelemetrySocketModel telemetry;

  const SpeedometerSocketSendTelemetry({
    required this.telemetry,
  });

  @override
  List<Object?> get props => [telemetry];
}

/// Helper event to stream current GPS coordinates, speed, and RPM.
class SpeedometerSocketSendCurrentData extends SpeedometerSocketEvent {
  final double speedKmh;
  final double? latitude;
  final double? longitude;
  final int? rpm;
  final String? vehicleId;

  const SpeedometerSocketSendCurrentData({
    required this.speedKmh,
    this.latitude,
    this.longitude,
    this.rpm,
    this.vehicleId,
  });

  @override
  List<Object?> get props => [speedKmh, latitude, longitude, rpm, vehicleId];
}

/// Internal/Service event fired when socket connection state changes.
class SpeedometerSocketStatusUpdated extends SpeedometerSocketEvent {
  final SocketConnectionStatus status;
  final String? errorMessage;

  const SpeedometerSocketStatusUpdated({
    required this.status,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [status, errorMessage];
}

/// Internal/Service event fired when a new telemetry packet is received from the socket.
class SpeedometerSocketDataReceived extends SpeedometerSocketEvent {
  final TelemetrySocketModel telemetry;

  const SpeedometerSocketDataReceived({
    required this.telemetry,
  });

  @override
  List<Object?> get props => [telemetry];
}
