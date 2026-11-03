import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:margnetra_super_app/core/utils/app_colors.dart';
import 'package:margnetra_super_app/pages/all_nav_pages/speedometer_page/data/models/telemetry_socket_model.dart';
import 'package:margnetra_super_app/pages/all_nav_pages/speedometer_page/data/services/telemetry_socket_service.dart';
import 'package:margnetra_super_app/pages/all_nav_pages/speedometer_page/logic/blocs/speedometer_socket_bloc/speedometer_socket_bloc.dart';

class SocketStatusBadge extends StatelessWidget {
  const SocketStatusBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpeedometerSocketBloc, SpeedometerSocketState>(
      builder: (context, state) {
        Color dotColor;
        String statusLabel;

        switch (state.status) {
          case SocketConnectionStatus.connected:
            dotColor = const Color(0xFF00E676);
            statusLabel = 'WS LIVE';
            break;
          case SocketConnectionStatus.connecting:
            dotColor = Colors.amberAccent;
            statusLabel = 'WS CONNECTING';
            break;
          case SocketConnectionStatus.error:
            dotColor = Colors.redAccent;
            statusLabel = 'WS ERROR';
            break;
          case SocketConnectionStatus.disconnected:
            dotColor = Colors.blueGrey;
            statusLabel = 'WS OFFLINE';
        }

        return InkWell(
          onTap: () => _onBadgeTapped(context, state),
          borderRadius: BorderRadius.circular(20),
          child: Container(
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
                    letterSpacing: 1.2,
                    color: dotColor,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onBadgeTapped(BuildContext context, SpeedometerSocketState state) {
    if (!state.isConnected) {
      context.read<SpeedometerSocketBloc>().add(const SpeedometerSocketConnect());
      return;
    }

    // If connected, show telemetry details dialog with test packet trigger
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0B141E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomSheetContext) {
        return BlocBuilder<SpeedometerSocketBloc, SpeedometerSocketState>(
          bloc: context.read<SpeedometerSocketBloc>(),
          builder: (ctx, liveState) {
            final telemetry = liveState.telemetry;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'TELEMETRY WEBSOCKET',
                        style: TextStyle(
                          color: AppColors.primaryHudCyan,
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                          letterSpacing: 1.5,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00E676).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'CONNECTED',
                          style: TextStyle(
                            color: Color(0xFF00E676),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _buildDetailRow(
                      'Vehicle ID',
                      telemetry?.vehicleId ??
                          liveState.activeVehicleId ??
                          'ee344c8c-b968-421e-a3ed-65a0e6c9aa81'),
                  _buildDetailRow(
                      'Speed (km/h)',
                      '${telemetry?.gps.speedKmh.toStringAsFixed(1) ?? '0.0'} km/h'),
                  _buildDetailRow(
                      'RPM', '${telemetry?.vehicle.rpm ?? 0} RPM'),
                  _buildDetailRow(
                      'GPS Coordinates',
                      '${telemetry?.gps.latitude.toStringAsFixed(4) ?? '22.5740'}, ${telemetry?.gps.longitude.toStringAsFixed(4) ?? '88.3650'}'),
                  _buildDetailRow(
                      'Packets',
                      'Sent: ${liveState.packetsSent} | Received: ${liveState.packetsReceived}'),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            context
                                .read<SpeedometerSocketBloc>()
                                .add(const SpeedometerSocketDisconnect());
                            Navigator.pop(bottomSheetContext);
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.redAccent),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Disconnect',
                            style: TextStyle(color: Colors.redAccent),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Send sample test payload matching user specification
                            final testPayload = TelemetrySocketModel(
                              vehicleId: "ee344c8c-b968-421e-a3ed-65a0e6c9aa81",
                              gps: const GpsTelemetry(
                                latitude: 22.5740,
                                longitude: 88.3650,
                                speedKmh: 72.5,
                              ),
                              vehicle: const VehicleTelemetry(
                                rpm: 2600,
                              ),
                            );

                            context.read<SpeedometerSocketBloc>().add(
                                  SpeedometerSocketSendTelemetry(
                                    telemetry: testPayload,
                                  ),
                                );
                            Navigator.pop(bottomSheetContext);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryHudCyan,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Send Test Packet',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 12,
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
