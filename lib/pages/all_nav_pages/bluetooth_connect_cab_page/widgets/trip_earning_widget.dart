import 'package:flutter/material.dart';
import 'package:margnetra_super_app/core/utils/app_colors.dart';

class TripEarningWidget extends StatelessWidget {
  const TripEarningWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildTripEarnings();
  }

  
  Widget _buildTripEarnings() {
    return Container(
      width: double.infinity,
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 13),
      decoration: BoxDecoration(
        color: const Color(0xFF03120D),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: const Color(0xFF00B85A),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.green.withOpacity(.08),
            blurRadius: 10,
          ),
        ],
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Trip Earnings',
            style: TextStyle(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 8),
          Text(
            '+ 12 MGC',
            style: TextStyle(
              color: AppColors.green,
              fontSize: 13,
              fontWeight: FontWeight.w800,
              letterSpacing: .3,
            ),
          ),
        ],
      ),
    );
  }


}