import 'dart:math';
import 'package:flutter/material.dart';

class Responsive {
  static double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
  static double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;

  static double wp(BuildContext context, double percent) {
    return screenWidth(context) * percent / 100;
  }

  static double hp(BuildContext context, double percent) {
    return screenHeight(context) * percent / 100;
  }

  static double sp(BuildContext context, double fontSize) {
    final baseWidth = 375.0;
    final scale = screenWidth(context) / baseWidth;
    return max(12.0, fontSize * scale);
  }

  static double minWidth(BuildContext context, double percent, double maxWidth) {
    return min(screenWidth(context) * percent / 100, maxWidth);
  }

  static double minHeight(BuildContext context, double percent, double maxHeight) {
    return min(screenHeight(context) * percent / 100, maxHeight);
  }
}
