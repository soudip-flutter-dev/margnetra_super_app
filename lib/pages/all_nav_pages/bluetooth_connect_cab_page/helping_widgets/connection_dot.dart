import 'package:flutter/material.dart';
import 'package:margnetra_super_app/core/app_services/bluetooth_service/bluetooth_service.dart';
import 'package:margnetra_super_app/core/utils/app_colors.dart';

/// Animated connection status dot.
///
/// When a BLE device is connected → green pulsing dot.
/// When disconnected           → red static dot.
/// Accepts an optional [btService]; falls back to the singleton.
class ConnectionDot extends StatefulWidget {
  final BluetoothService? btService;

  const ConnectionDot({super.key, this.btService});

  @override
  State<ConnectionDot> createState() => _ConnectionDotState();
}

class _ConnectionDotState extends State<ConnectionDot>
    with SingleTickerProviderStateMixin {
  late BluetoothService _service;
  late AnimationController _controller;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _service = widget.btService ?? BluetoothService();
    _service.addListener(_onServiceChange);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _opacity = Tween<double>(begin: 0.35, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _updateAnimation();
  }

  void _onServiceChange() {
    if (mounted) _updateAnimation();
  }

  void _updateAnimation() {
    if (_service.isDeviceConnected) {
      if (!_controller.isAnimating) _controller.repeat(reverse: true);
    } else {
      _controller.stop();
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _service.removeListener(_onServiceChange);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _service,
      builder: (_, __) {
        final connected = _service.isDeviceConnected;
        final dotColor = connected ? AppColors.green : AppColors.errorDangerRed;

        return AnimatedBuilder(
          animation: _opacity,
          builder: (_, __) => Opacity(
            opacity: connected ? _opacity.value : 1.0,
            child: Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
                boxShadow: connected
                    ? [
                        BoxShadow(
                          color: AppColors.green.withOpacity(0.7),
                          blurRadius: 5,
                          spreadRadius: 1,
                        ),
                      ]
                    : [],
              ),
            ),
          ),
        );
      },
    );
  }
}
