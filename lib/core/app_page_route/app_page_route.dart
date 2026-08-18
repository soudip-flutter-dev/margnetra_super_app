import 'package:flutter/material.dart';
import 'package:margnetra_super_app/pages/auth_page/login_page/login_page.dart';
import 'package:margnetra_super_app/pages/auth_page/registration_page/registration_page.dart';
import 'package:margnetra_super_app/pages/intro_slider_page/intro_slider_page.dart';
import 'package:margnetra_super_app/pages/splash_screen/splash_screen.dart';

class AppPageRoute {
  static const String splashPage = '/splash';
  static const String introSliderPage = '/introSlider';
  static const String loginPage = '/login';
  static const String registrationPage = '/registration';
  // static const String bottomNavBar = '/bottomNavBar';

  
  
  static Map<String, WidgetBuilder> get mRoutes => {
        splashPage: (context) => const MargNetraSplash(),
        introSliderPage: (context) => const IntroSliderPage(),
        loginPage: (context) => LoginPage(),
        registrationPage: (context) => RegistrationPage(),
         };
}