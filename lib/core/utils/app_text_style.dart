import 'package:flutter/material.dart';

class AppTextStyle {
   

    static TextStyle customGilroyFontBold({
      double fontSize = 16,
      FontWeight fontWeight = FontWeight.w700,
      Color color = Colors.black,
      String fontFamily = 'Gilroy-Bold',
    }) {
      return TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        fontFamily: fontFamily,
      );
    }

    static TextStyle customGilroyFontRegular({
      double fontSize = 16,
      FontWeight fontWeight = FontWeight.normal,
      Color color = Colors.black,
      String fontFamily = 'Gilroy-Regular',
    }) {
      return TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        fontFamily: fontFamily,
      );
    }

    static TextStyle customGilroyFontMedium({
      double fontSize = 16,
      FontWeight fontWeight = FontWeight.w500,
      Color color = Colors.black,
      String fontFamily = 'Gilroy-Medium',
       TextDecoration textDecoration = TextDecoration.none,
    }) {
      return TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        fontFamily: fontFamily,
        decoration: textDecoration
      );
    }

    static TextStyle customGilroyFontLight({
      double fontSize = 16,
      FontWeight fontWeight = FontWeight.w300,
      Color color = Colors.black,
      String fontFamily = 'Gilroy-Light',
    }) {
      return TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        fontFamily: fontFamily,
      );
    }

}