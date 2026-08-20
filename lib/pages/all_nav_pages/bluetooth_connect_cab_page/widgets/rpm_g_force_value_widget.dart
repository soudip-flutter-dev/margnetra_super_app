import 'package:flutter/material.dart';
import 'package:margnetra_super_app/pages/all_nav_pages/bluetooth_connect_cab_page/helping_widgets/hud_stat.dart';

class RpmGForceValueWidget extends StatelessWidget {
  const RpmGForceValueWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildStatsRow();
  }

  
  Widget _buildStatsRow() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        HudStat(
          title: 'RPM',
          value: '2450',
          alignment: CrossAxisAlignment.start,
        ),
        HudStat(
          title: 'G-FORCE',
          value: '0.12G',
          alignment: CrossAxisAlignment.end,
        ),
      ],
    );
  }


}