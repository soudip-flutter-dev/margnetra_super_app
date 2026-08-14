import 'package:flutter/material.dart';
import 'package:margnetra_super_app/pages/splash_screen/splash_screen.dart';

class AppPageRoute {
  static const String splashPage = '/splash';
  static const String loginPage = '/login';
  static const String registrationPage = '/registration';
  static const String bottomNavBar = '/bottomNavBar';

  
  
  static Map<String, WidgetBuilder> get mRoutes => {
        splashPage: (context) => const MargNetraSplash(),
         };
}