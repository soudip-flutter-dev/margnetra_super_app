import 'package:flutter/material.dart';
import 'package:margnetra_super_app/core/app_services/speed_service/speed_service.dart';

/// Card displayed when location permissions or hardware GPS services require user action.
class PermissionErrorCard extends StatelessWidget {
  final SpeedServiceStatus status;
  final String? errorMessage;
  final VoidCallback onRetry;
  final VoidCallback onOpenAppSettings;
  final VoidCallback onOpenLocationSettings;

  const PermissionErrorCard({
    super.key,
    required this.status,
    this.errorMessage,
    required this.onRetry,
    required this.onOpenAppSettings,
    required this.onOpenLocationSettings,
  });

  @override
  Widget build(BuildContext context) {
    final (IconData icon, String title, String subtitle, String actionLabel, VoidCallback action) =
        _getCardDetails();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF131D2A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.amberAccent.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.amberAccent.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.amberAccent, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white70,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: action,
              icon: const Icon(Icons.settings, size: 18),
              label: Text(
                actionLabel,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00E5FF),
                foregroundColor: const Color(0xFF010A12),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  (IconData, String, String, String, VoidCallback) _getCardDetails() {
    switch (status) {
      case SpeedServiceStatus.serviceDisabled:
        return (
          Icons.location_off_rounded,
          'Location Services Disabled',
          'Device GPS is turned off. Turn on location services to measure speed.',
          'Open Location Settings',
          onOpenLocationSettings,
        );
      case SpeedServiceStatus.permissionDenied:
        return (
          Icons.security_rounded,
          'Location Permission Required',
          'Speedometer requires location permission to compute your real-time vehicle speed.',
          'Grant Permission',
          onRetry,
        );
      case SpeedServiceStatus.permissionDeniedForever:
        return (
          Icons.block_rounded,
          'Permission Denied Permanently',
          'Location permission was permanently denied. Please enable it in App Settings.',
          'Open App Settings',
          onOpenAppSettings,
        );
      case SpeedServiceStatus.error:
        return (
          Icons.error_outline_rounded,
          'GPS Sensor Error',
          errorMessage ?? 'An error occurred while listening to GPS updates.',
          'Retry Connection',
          onRetry,
        );
      default:
        return (
          Icons.info_outline_rounded,
          'Location Status',
          'Connecting to GPS satellites...',
          'Retry',
          onRetry,
        );
    }
  }
}
