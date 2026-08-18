import 'package:flutter/material.dart';

class AppSpace {
  static SizedBox h10 = const SizedBox(height: 10);
  static SizedBox h20 = const SizedBox(height: 20);
  static SizedBox h30 = const SizedBox(height: 30);
  static SizedBox w10 = const SizedBox(width: 10);
  static SizedBox w20 = const SizedBox(width: 20);  
  static SizedBox w30 = const SizedBox(width: 30);

  static Widget customHeight([  double height = 15]) {
    return SizedBox(height: height);
  }

  static Widget customWidth([ double width = 15]) {
    return SizedBox(width: width);
  }
}