import 'package:flutter/material.dart';
import 'package:margnetra_super_app/core/utils/app_colors.dart';
import 'package:margnetra_super_app/pages/all_nav_pages/bluetooth_connect_cab_page/helping_widgets/connection_dot.dart';

class LiveDriveStatusSosWidget extends StatelessWidget {
  const LiveDriveStatusSosWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildStatusRow(context);
  }
  
  Widget _buildStatusRow(BuildContext context) {
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

          // Live Driving text
          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Live Driving',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: .2,
                  ),
                ),
                SizedBox(height: 2),
                Row(
                  children: [
                    ConnectionDot(),
                    SizedBox(width: 4),
                    Text(
                      'Connected',
                      style: TextStyle(
                        color: AppColors.green,
                        fontSize: 7.5,
                        fontWeight: FontWeight.w500,
                        letterSpacing: .4,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // SOS button
          InkWell(
            onTap: () {
              // Navigate to the Emergency SOS page
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