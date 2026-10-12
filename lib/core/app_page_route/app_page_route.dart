import 'package:flutter/material.dart';
import 'package:margnetra_super_app/pages/all_nav_pages/bluetooth_connect_cab_page/bluetooth_scan_page.dart';
import 'package:margnetra_super_app/pages/all_nav_pages/speedometer_page/speedometer_page.dart';
import 'package:margnetra_super_app/pages/auth_page/login_page/login_page.dart';
import 'package:margnetra_super_app/pages/auth_page/registration_page/registration_page.dart';
import 'package:margnetra_super_app/pages/bounty_capture_page/bounty_capture_page.dart';
import 'package:margnetra_super_app/pages/emergency_sos_page/emergency_sos_page.dart';
import 'package:margnetra_super_app/pages/intro_slider_page/intro_slider_page.dart';
import 'package:margnetra_super_app/pages/navigation_home_page/navigation_home_page.dart';
import 'package:margnetra_super_app/pages/profile_page/profile_page.dart';
import 'package:margnetra_super_app/pages/settings_page/settings_page.dart';
import 'package:margnetra_super_app/pages/splash_screen/splash_screen.dart';

class AppPageRoute {
  static const String splashPage = '/splash';
  static const String introSliderPage = '/introSlider';
  static const String loginPage = '/login';
  static const String registrationPage = '/registration';
  static const String navigationHomePage = '/navigationHome';
  static const String emergencySosPage = '/emergencySos';
  static const String bountyCapturePage = '/bountyCapture';
  static const String profilePage = '/profile';
  static const String settingsPage = '/settings';
  static const String bluetoothScanPage = '/bluetoothScan';
  static const String speedometerPage = '/speedometer';

  
  
  static Map<String, WidgetBuilder> get mRoutes => {
        splashPage: (context) => const MargNetraSplash(),
        introSliderPage: (context) => const IntroSliderPage(),
        loginPage: (context) => LoginPage(),
        registrationPage: (context) => RegistrationPage(),
        navigationHomePage: (context) => NavigationHomePage(),
        emergencySosPage: (context) =>  EmergencySosWidget(),
        bountyCapturePage: (context) => const BountyCaptureWidget(),
        profilePage: (context) => const ProfileWidget(),
        settingsPage: (context) => const SettingsWidget(),
        bluetoothScanPage: (context) => const BluetoothScanPage(),
        speedometerPage: (context) => const SpeedometerScreen(),
         };
}