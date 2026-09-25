import 'package:flutter/material.dart';
import 'package:margnetra_super_app/core/app_services/bluetooth_service/bluetooth_service.dart';
import 'package:margnetra_super_app/core/utils/app_colors.dart';
import 'package:margnetra_super_app/core/utils/app_text_style.dart';

/// Compact banner displayed at the top of the HUD dashboard.
/// Shows live BT adapter state, connected device name, and a CTA to open
/// the BLE scan page.
class BtConnectBanner extends StatelessWidget {
  final BluetoothService btService;
  final VoidCallback onTapScan;

  const BtConnectBanner({
    super.key,
    required this.btService,
    required this.onTapScan,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: btService,
      builder: (context, _) {
        final isOn = btService.isAdapterOn;
        final isConnected = btService.isDeviceConnected;
        final deviceName = btService.connectedDevice?.platformName.isNotEmpty == true
            ? btService.connectedDevice!.platformName
            : btService.connectedDevice?.remoteId.str ?? '';

        final bannerColor = isConnected
            ? AppColors.green
            : isOn
                ? AppColors.primaryHudCyan
                : AppColors.errorDangerRed;

        final label = isConnected
            ? 'Connected — $deviceName'
            : isOn
                ? 'Bluetooth ON — Tap to scan'
                : 'Bluetooth OFF — Tap to enable';

        return GestureDetector(
          onTap: onTapScan,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: bannerColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: bannerColor.withOpacity(0.4),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: bannerColor.withOpacity(0.12),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Row(
              children: [
                // ── Animated BT icon ──
                _PulsingIcon(
                  icon: isConnected
                      ? Icons.bluetooth_connected
                      : Icons.bluetooth,
                  color: bannerColor,
                  pulse: isConnected || btService.isScanning,
                ),

                const SizedBox(width: 10),

                // ── Status label ──
                Expanded(
                  child: Text(
                    label,
                    style: AppTextStyle.customGilroyFontMedium(
                      fontSize: 12,
                      color: bannerColor,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // ── Chevron ──
                Icon(
                  Icons.chevron_right,
                  color: bannerColor.withOpacity(0.6),
                  size: 16,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Pulsing icon widget
// ─────────────────────────────────────────────────────────────────────────────
class _PulsingIcon extends StatefulWidget {
  final IconData icon;
  final Color color;
  final bool pulse;

  const _PulsingIcon({
    required this.icon,
    required this.color,
    required this.pulse,
  });

  @override
  State<_PulsingIcon> createState() => _PulsingIconState();
}

class _PulsingIconState extends State<_PulsingIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _scale = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.pulse) {
      return Icon(widget.icon, color: widget.color, size: 18);
    }
    return AnimatedBuilder(
      animation: _scale,
      builder: (_, __) => Transform.scale(
        scale: _scale.value,
        child: Icon(widget.icon, color: widget.color, size: 18),
      ),
    );
  }
}
