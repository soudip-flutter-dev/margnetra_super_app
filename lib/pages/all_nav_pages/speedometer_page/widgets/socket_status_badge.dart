import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:margnetra_super_app/core/app_services/api_services/api_urls.dart';
import 'package:margnetra_super_app/core/utils/app_colors.dart';
import 'package:margnetra_super_app/core/utils/custom_snack_bar.dart';
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

        if (state.isSimulated) {
          dotColor = const Color(0xFF00E5FF);
          statusLabel = 'WS DEMO';
        } else {
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
              break;
          }
        }

        return InkWell(
          onTap: () => _showTelemetrySheet(context),
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

  void _showTelemetrySheet(BuildContext parentContext) {
    final bloc = parentContext.read<SpeedometerSocketBloc>();
    final urlController = TextEditingController(
      text: ApiUrls.getTelemetrySocketUrl(),
    );

    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0B141E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomSheetContext) {
        return BlocBuilder<SpeedometerSocketBloc, SpeedometerSocketState>(
          bloc: bloc,
          builder: (ctx, state) {
            final telemetry = state.telemetry;
            final isConnected = state.isConnected;

            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom + 20,
              ),
              child: SingleChildScrollView(
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
                            color: (isConnected
                                    ? (state.isSimulated
                                        ? const Color(0xFF00E5FF)
                                        : const Color(0xFF00E676))
                                    : Colors.redAccent)
                                .withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            state.isSimulated
                                ? 'SIMULATION'
                                : isConnected
                                    ? 'CONNECTED'
                                    : state.isConnecting
                                        ? 'CONNECTING'
                                        : 'OFFLINE',
                            style: TextStyle(
                              color: isConnected
                                  ? (state.isSimulated
                                      ? const Color(0xFF00E5FF)
                                      : const Color(0xFF00E676))
                                  : Colors.redAccent,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Status / Error message
                    if (state.errorMessage != null && !isConnected) ...[
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.redAccent.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: Colors.redAccent.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.info_outline,
                                color: Colors.redAccent, size: 16),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                state.errorMessage!,
                                style: const TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],

                    // Telemetry details
                    _buildDetailRow(
                        'Vehicle ID',
                        telemetry?.vehicleId ??
                            state.activeVehicleId ??
                            ApiUrls.defaultTelemetryVehicleId),
                    _buildDetailRow(
                        'Speed (km/h)',
                        '${telemetry?.gps.speedKmh.toStringAsFixed(1) ?? '0.0'} km/h'),
                    _buildDetailRow(
                        'Engine RPM', '${telemetry?.vehicle.rpm ?? 0} RPM'),
                    _buildDetailRow(
                        'Coordinates',
                        '${telemetry?.gps.latitude.toStringAsFixed(4) ?? '22.5740'}, ${telemetry?.gps.longitude.toStringAsFixed(4) ?? '88.3650'}'),
                    _buildDetailRow(
                        'Packets',
                        'Sent: ${state.packetsSent} | Recv: ${state.packetsReceived}'),

                    const Divider(color: Colors.white12, height: 24),

                    // Quick Presets
                    const Text(
                      'QUICK PRESETS',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        _buildPresetChip(
                          label: 'Render Cloud',
                          onTap: () {
                            urlController.text = ApiUrls.getTelemetrySocketUrl(
                                baseUrl: ApiUrls.telemetrySocketBase);
                            bloc.add(SpeedometerSocketConnect(
                              url: urlController.text,
                            ));
                          },
                        ),
                        _buildPresetChip(
                          label: 'Localhost:8080',
                          onTap: () {
                            urlController.text = ApiUrls.getTelemetrySocketUrl(
                                baseUrl: ApiUrls.telemetrySocketLocal);
                            bloc.add(SpeedometerSocketConnect(
                              url: urlController.text,
                            ));
                          },
                        ),
                        _buildPresetChip(
                          label: 'Emulator 10.0.2.2',
                          onTap: () {
                            urlController.text = ApiUrls.getTelemetrySocketUrl(
                                baseUrl: ApiUrls.telemetrySocketEmulator);
                            bloc.add(SpeedometerSocketConnect(
                              url: urlController.text,
                            ));
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // Editable URL
                    const Text(
                      'SOCKET ENDPOINT URL',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: urlController,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFF131D2A),
                        hintText: 'ws://localhost:8080/ws/telemetry?token=...',
                        hintStyle: const TextStyle(
                            color: Colors.white30, fontSize: 12),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                              color: AppColors.primaryHudCyan
                                  .withValues(alpha: 0.3)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                              color: Colors.white.withValues(alpha: 0.1)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: AppColors.primaryHudCyan),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Simulation Mode Toggle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Simulation / Demo Mode',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Test speedometer without an active server',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                        Switch(
                          value: state.isSimulated,
                          activeThumbColor: AppColors.primaryHudCyan,
                          activeTrackColor: AppColors.primaryHudCyan
                              .withValues(alpha: 0.4),
                          onChanged: (val) {
                            bloc.add(SpeedometerSocketToggleSimulation(
                                enable: val));
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Action buttons
                    Row(
                      children: [
                        if (isConnected) ...[
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                bloc.add(const SpeedometerSocketDisconnect());
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
                          const SizedBox(width: 10),
                        ] else ...[
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                bloc.add(SpeedometerSocketConnect(
                                  url: urlController.text.trim(),
                                ));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryHudCyan,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                state.isConnecting ? 'Connecting...' : 'Connect',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (!state.isConnected) {
                                CustomSnackBar.showError(
                                  parentContext,
                                  'WebSocket is offline. Connect or enable Simulation Mode.',
                                );
                                return;
                              }

                              // Dispatch test payload matching user specification
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

                              bloc.add(SpeedometerSocketSendTelemetry(
                                telemetry: testPayload,
                              ));

                              CustomSnackBar.showSuccess(
                                parentContext,
                                'Telemetry packet sent: 72.5 km/h, 2600 RPM',
                              );
                              Navigator.pop(bottomSheetContext);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF131D2A),
                              side: const BorderSide(
                                  color: AppColors.primaryHudCyan),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Send Test Packet',
                              style: TextStyle(
                                color: AppColors.primaryHudCyan,
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
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPresetChip({
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: const Color(0xFF131D2A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white24),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
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
