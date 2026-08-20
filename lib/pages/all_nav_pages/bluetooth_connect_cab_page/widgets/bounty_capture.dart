import 'package:flutter/material.dart';
import 'package:margnetra_super_app/core/utils/app_colors.dart';

class BountyCapture extends StatelessWidget {
  const BountyCapture({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildBountyButton();
  }

  
  Widget _buildBountyButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: AppColors.errorDangerRed.withOpacity(.28),
              blurRadius: 9,
              spreadRadius: 1,
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {
            
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.errorDangerRed,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: const Text(
            'BOUNTY CAPTURE',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: .2,
            ),
          ),
        ),
      ),
    );
  }
}

