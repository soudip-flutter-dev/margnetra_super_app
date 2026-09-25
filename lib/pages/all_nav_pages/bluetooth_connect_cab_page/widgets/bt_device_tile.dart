import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:margnetra_super_app/core/app_services/bluetooth_service/bluetooth_service.dart'
    as app_bt;
import 'package:margnetra_super_app/core/utils/app_colors.dart';
import 'package:margnetra_super_app/core/utils/app_text_style.dart';

/// A card representing a single discovered BLE device during a scan.
/// Shows device name, ID, RSSI signal strength and a connect/disconnect button.
class BtDeviceTile extends StatelessWidget {
  final ScanResult scanResult;
  final app_bt.BluetoothService btService;

  const BtDeviceTile({
    super.key,
    required this.scanResult,
    required this.btService,
  });

  @override
  Widget build(BuildContext context) {
    final device = scanResult.device;
    final name = device.platformName.isNotEmpty
        ? device.platformName
        : 'Unknown Device';
    final id = device.remoteId.str;
    final rssi = scanResult.rssi;
    final isConnected = btService.connectedDevice?.remoteId == device.remoteId;
    final isConnecting = btService.isConnecting;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isConnected
            ? AppColors.primaryHudCyan.withOpacity(0.08)
            : AppColors.surface.withOpacity(0.6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isConnected
              ? AppColors.primaryHudCyan.withOpacity(0.55)
              : AppColors.primaryHudCyan.withOpacity(0.12),
          width: isConnected ? 1.5 : 1,
        ),
        boxShadow: isConnected
            ? [
                BoxShadow(
                  color: AppColors.primaryHudCyan.withOpacity(0.15),
                  blurRadius: 12,
                  spreadRadius: 1,
                )
              ]
            : [],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            // ── BT icon ──
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isConnected
                    ? AppColors.primaryHudCyan.withOpacity(0.15)
                    : Colors.white.withOpacity(0.05),
                border: Border.all(
                  color: isConnected
                      ? AppColors.primaryHudCyan
                      : Colors.white24,
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.bluetooth,
                color: isConnected
                    ? AppColors.primaryHudCyan
                    : Colors.white54,
                size: 20,
              ),
            ),

            const SizedBox(width: 12),

            // ── Device info ──
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTextStyle.customGilroyFontMedium(
                      fontSize: 14,
                      color: isConnected
                          ? AppColors.primaryHudCyan
                          : AppColors.primaryText,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    id,
                    style: AppTextStyle.customGilroyFontLight(
                      fontSize: 11,
                      color: Colors.white38,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // ── RSSI badge ──
            _RssiBadge(rssi: rssi),

            const SizedBox(width: 10),

            // ── Connect / Disconnect button ──
            _ConnectButton(
              isConnected: isConnected,
              isConnecting: isConnecting,
              onConnect: () async {
                await btService.connectToDevice(device);
              },
              onDisconnect: () async {
                await btService.disconnectDevice();
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// RSSI Signal Badge
// ─────────────────────────────────────────────────────────────────────────────
class _RssiBadge extends StatelessWidget {
  final int rssi;
  const _RssiBadge({required this.rssi});

  Color get _color {
    if (rssi >= -60) return AppColors.green;
    if (rssi >= -80) return AppColors.accentSaffron;
    return AppColors.errorDangerRed;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(Icons.signal_cellular_alt, color: _color, size: 16),
        const SizedBox(height: 2),
        Text(
          '${rssi}dBm',
          style: TextStyle(
            fontSize: 9,
            color: _color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Connect / Disconnect Button
// ─────────────────────────────────────────────────────────────────────────────
class _ConnectButton extends StatelessWidget {
  final bool isConnected;
  final bool isConnecting;
  final VoidCallback onConnect;
  final VoidCallback onDisconnect;

  const _ConnectButton({
    required this.isConnected,
    required this.isConnecting,
    required this.onConnect,
    required this.onDisconnect,
  });

  @override
  Widget build(BuildContext context) {
    if (isConnecting) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryHudCyan),
        ),
      );
    }
    return GestureDetector(
      onTap: isConnected ? onDisconnect : onConnect,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isConnected
              ? AppColors.errorDangerRed.withOpacity(0.15)
              : AppColors.primaryHudCyan.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isConnected
                ? AppColors.errorDangerRed
                : AppColors.primaryHudCyan,
            width: 1,
          ),
        ),
        child: Text(
          isConnected ? 'Disconnect' : 'Connect',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: isConnected
                ? AppColors.errorDangerRed
                : AppColors.primaryHudCyan,
          ),
        ),
      ),
    );
  }
}
