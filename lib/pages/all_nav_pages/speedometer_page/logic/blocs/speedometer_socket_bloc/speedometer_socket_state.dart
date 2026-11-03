import 'package:equatable/equatable.dart';
import 'package:margnetra_super_app/pages/all_nav_pages/speedometer_page/data/models/telemetry_socket_model.dart';
import 'package:margnetra_super_app/pages/all_nav_pages/speedometer_page/data/services/telemetry_socket_service.dart';

abstract class SpeedometerSocketState extends Equatable {
  final SocketConnectionStatus status;
  final TelemetrySocketModel? telemetry;
  final String? errorMessage;
  final int packetsSent;
  final int packetsReceived;
  final String? activeVehicleId;

  const SpeedometerSocketState({
    this.status = SocketConnectionStatus.disconnected,
    this.telemetry,
    this.errorMessage,
    this.packetsSent = 0,
    this.packetsReceived = 0,
    this.activeVehicleId,
  });

  bool get isConnected => status == SocketConnectionStatus.connected;
  bool get isConnecting => status == SocketConnectionStatus.connecting;

  double get currentSpeedKmh => telemetry?.gps.speedKmh ?? 0.0;
  int get currentRpm => telemetry?.vehicle.rpm ?? 0;
  double get latitude => telemetry?.gps.latitude ?? 0.0;
  double get longitude => telemetry?.gps.longitude ?? 0.0;

  @override
  List<Object?> get props => [
        status,
        telemetry,
        errorMessage,
        packetsSent,
        packetsReceived,
        activeVehicleId,
      ];
}

/// Initial disconnected state.
class SpeedometerSocketInitial extends SpeedometerSocketState {
  const SpeedometerSocketInitial()
      : super(status: SocketConnectionStatus.disconnected);
}

/// Socket is actively attempting to establish a connection.
class SpeedometerSocketConnecting extends SpeedometerSocketState {
  const SpeedometerSocketConnecting({
    super.telemetry,
    super.packetsSent,
    super.packetsReceived,
    super.activeVehicleId,
  }) : super(status: SocketConnectionStatus.connecting);
}

/// Socket connection has been established.
class SpeedometerSocketConnected extends SpeedometerSocketState {
  const SpeedometerSocketConnected({
    super.telemetry,
    super.packetsSent,
    super.packetsReceived,
    super.activeVehicleId,
  }) : super(status: SocketConnectionStatus.connected);
}

/// New telemetry data packet sent or received.
class SpeedometerSocketDataUpdated extends SpeedometerSocketState {
  const SpeedometerSocketDataUpdated({
    required super.telemetry,
    super.packetsSent,
    super.packetsReceived,
    super.activeVehicleId,
  }) : super(status: SocketConnectionStatus.connected);
}

/// Socket has been disconnected.
class SpeedometerSocketDisconnected extends SpeedometerSocketState {
  const SpeedometerSocketDisconnected({
    super.telemetry,
    super.packetsSent,
    super.packetsReceived,
    super.activeVehicleId,
  }) : super(status: SocketConnectionStatus.disconnected);
}

/// Socket encountered an error.
class SpeedometerSocketError extends SpeedometerSocketState {
  const SpeedometerSocketError({
    required String errorMessage,
    super.telemetry,
    super.packetsSent,
    super.packetsReceived,
    super.activeVehicleId,
  }) : super(
          status: SocketConnectionStatus.error,
          errorMessage: errorMessage,
        );
}

