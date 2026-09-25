import 'package:flutter/material.dart';
import 'package:margnetra_super_app/core/app_services/bluetooth_service/bluetooth_service.dart';
import 'package:margnetra_super_app/core/utils/app_colors.dart';
import 'package:margnetra_super_app/pages/all_nav_pages/bluetooth_connect_cab_page/helping_widgets/connection_dot.dart';

class LiveDriveStatusSosWidget extends StatelessWidget {
  const LiveDriveStatusSosWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildStatusRow(context);
  }

  Widget _buildStatusRow(BuildContext context) {
    final btService = BluetoothService();

    return SizedBox(
      height: 39,
      child: Row(
        children: [
          // Live driving icon
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primaryHudCyan,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryHudCyan.withOpacity(.35),
                  blurRadius: 7,
                ),
              ],
            ),
            child: const Icon(
              Icons.power_settings_new_rounded,
              color: AppColors.primaryHudCyan,
              size: 13,
            ),
          ),

          const SizedBox(width: 8),

          // Live Driving text + live BT status
          Expanded(
            child: AnimatedBuilder(
              animation: btService,
              builder: (context, _) {
                final connected = btService.isDeviceConnected;
                final deviceName = connected &&
                        btService.connectedDevice!.platformName.isNotEmpty
                    ? btService.connectedDevice!.platformName
                    : connected
                        ? 'Device'
                        : 'Disconnected';
                final statusColor =
                    connected ? AppColors.green : AppColors.errorDangerRed;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Live Driving',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: .2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        ConnectionDot(btService: btService),
                        const SizedBox(width: 4),
                        Text(
                          connected ? deviceName : 'Not Connected',
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 7.5,
                            fontWeight: FontWeight.w500,
                            letterSpacing: .4,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),

          // SOS button
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/emergencySos');
            },
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.errorDangerRed,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.errorDangerRed.withOpacity(.45),
                    blurRadius: 9,
                    spreadRadius: 1,
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: const Text(
                'SOS',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}