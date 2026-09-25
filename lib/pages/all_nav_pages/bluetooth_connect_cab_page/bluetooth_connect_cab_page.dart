import 'package:flutter/material.dart';
import 'package:margnetra_super_app/core/app_services/bluetooth_service/bluetooth_service.dart';
import 'package:margnetra_super_app/core/app_page_route/app_page_route.dart';
import 'package:margnetra_super_app/pages/all_nav_pages/bluetooth_connect_cab_page/helping_widgets/road_and_car_painter.dart';
import 'package:margnetra_super_app/pages/all_nav_pages/bluetooth_connect_cab_page/widgets/bounty_capture.dart';
import 'package:margnetra_super_app/pages/all_nav_pages/bluetooth_connect_cab_page/widgets/bt_connect_banner.dart';
import 'package:margnetra_super_app/pages/all_nav_pages/bluetooth_connect_cab_page/widgets/live_drive_status_sos_widget.dart';
import 'package:margnetra_super_app/pages/all_nav_pages/bluetooth_connect_cab_page/widgets/rpm_g_force_value_widget.dart';
import 'package:margnetra_super_app/pages/all_nav_pages/bluetooth_connect_cab_page/widgets/speedometer_widget.dart';
import 'package:margnetra_super_app/pages/all_nav_pages/bluetooth_connect_cab_page/widgets/trip_earning_widget.dart';

class HudDashboardWidget extends StatefulWidget {
  const HudDashboardWidget({super.key});

  @override
  State<HudDashboardWidget> createState() => _HudDashboardWidgetState();
}

class _HudDashboardWidgetState extends State<HudDashboardWidget> {
  final BluetoothService _btService = BluetoothService();

  @override
  void initState() {
    super.initState();
    // Initialise BT adapter listener once when HUD is created
    _btService.init();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                width * 0.055,
                12,
                width * 0.055,
                20,
              ),
              child: Column(
                children: [
                  // =========================================================
                  // 0. BLUETOOTH CONNECT BANNER  ← NEW
                  //    Tap → navigates to BluetoothScanPage
                  // =========================================================
                  BtConnectBanner(
                    btService: _btService,
                    onTapScan: () {
                      Navigator.pushNamed(
                        context,
                        AppPageRoute.bluetoothScanPage,
                      );
                    },
                  ),

                  // =========================================================
                  // 1. LIVE DRIVING / SOS
                  // =========================================================
                  LiveDriveStatusSosWidget(),

                  const SizedBox(height: 2),

                  // =========================================================
                  // 2. SPEEDOMETER
                  // =========================================================
                  SpeedometerWidget(width: width),

                  // =========================================================
                  // 3. RPM / G-FORCE
                  // =========================================================
                  RpmGForceValueWidget(),

                  const SizedBox(height: 2),

                  // =========================================================
                  // 4. ROAD + CAR
                  // =========================================================
                  SizedBox(
                    height: width * 0.31,
                    width: double.infinity,
                    child: CustomPaint(painter: RoadAndCarPainter()),
                  ),

                  const SizedBox(height: 4),

                  // =========================================================
                  // 5. TRIP EARNINGS
                  // =========================================================
                  TripEarningWidget(),

                  const SizedBox(height: 9),

                  // =========================================================
                  // 6. BOUNTY CAPTURE
                  // =========================================================
                  BountyCapture(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
