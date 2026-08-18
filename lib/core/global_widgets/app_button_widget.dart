
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:margnetra_super_app/core/utils/app_colors.dart';
import 'package:margnetra_super_app/core/utils/app_text_style.dart';
import 'package:margnetra_super_app/core/utils/responsive.dart';


class AppButtonWidget extends StatelessWidget {
  final String ? buttonText;
  final VoidCallback? onPressed;
  final int alphaValue;
  final Color backgroundColor;
  final Widget ? childWidget;
  final Color textColor ;
  const AppButtonWidget({
    super.key, 
     this.buttonText, 
    required this.onPressed,
    this.alphaValue = 255,
    this.backgroundColor = AppColors.primaryHudCyan,
    this.childWidget,
    this.textColor = AppColors.surface,
    });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor.withAlpha(alphaValue),
        padding: EdgeInsets.symmetric(
          horizontal: max(20, Responsive.wp(context, 5)),
          vertical: max(12, Responsive.hp(context, 2)),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: onPressed,
      child: childWidget ?? Text(buttonText ?? "", style: AppTextStyle.customGilroyFontMedium(
        fontSize: Responsive.sp(context, 18),
        color: textColor,
        fontWeight: FontWeight.w800,
        ),
      ),

    );
  }
}