import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:margnetra_super_app/core/utils/app_colors.dart';
import 'package:margnetra_super_app/core/utils/app_text_style.dart';
import 'package:margnetra_super_app/core/utils/responsive.dart';


class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final Function(String)? onTap;
  final String? labelText;
  final String? hintText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int? maxLines;
  final int? maxLength;
  final Color? cursorColor;
  final Color? fillColor;
  final IconData? visibleIcon;
  final Widget? prefixIconWidget;
  final VoidCallback? onPressIcon;
  final String? Function(String?)? validator;
  final GestureTapCallback? onTapAction;
  final Color? textColor;
  final Color? labelTextColor;
  final Widget? suffixWidget;
  final bool isReadOnly;
  final int? lenghtLimit;
  final Color? borderColor;


  const AppTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.keyboardType,
    this.obscureText = false,
    this.maxLines = 1,
    this.maxLength,
    this.cursorColor,
    this.fillColor = Colors.transparent,
    this.visibleIcon,
    this.prefixIconWidget,
    this.onTap,
    this.onPressIcon,
    this.validator,
    this.onTapAction,
    this.textColor,
    this.labelTextColor,
    this.suffixWidget,
    this.isReadOnly = false,
    this.lenghtLimit,
    this.borderColor = AppColors.secondaryTeal
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      inputFormatters: [
        if (keyboardType == TextInputType.phone)
          FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(lenghtLimit),
      ],
      onChanged: onTap,
      autocorrect: false,
      validator: validator,
      onTap: onTapAction,
      readOnly: isReadOnly || onTapAction != null ? true : false,
      // //////////////////////////////////////////////
      enableSuggestions: true,
      keyboardAppearance: Brightness.light,
      textInputAction: TextInputAction.next,
      style: AppTextStyle.customGilroyFontMedium(
        color: textColor ?? AppColors.primaryHudCyan,
        fontSize: Responsive.sp(context, 16),
      ),

      // //////////////////////////////////////////////
      keyboardType: keyboardType,
      obscureText: obscureText,
      cursorColor: cursorColor ?? Theme.of(context).primaryColor,
      maxLines: maxLines,
      maxLength: maxLength,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        filled: true,
        fillColor: fillColor,
        labelText: labelText ?? 'Enter Something',
        labelStyle: AppTextStyle.customGilroyFontMedium(
          color: labelTextColor ?? AppColors.surface,
          fontSize: Responsive.sp(context, 18),
        ),
        hintText: hintText,
        border: inputBorder(borderColor ?? AppColors.primaryHudCyan),
        enabledBorder: inputBorder(borderColor ?? AppColors.primaryHudCyan),
        focusedBorder: inputBorder(borderColor ?? AppColors.primaryHudCyan),
        errorBorder: inputBorder(AppColors.errorDangerRed),
        focusedErrorBorder: inputBorder(borderColor ?? AppColors.accentSaffron),
        disabledBorder: inputBorder(AppColors.secondaryTeal),
        prefixIcon: prefixIconWidget,
        suffix: suffixWidget,

        suffixIcon: IconButton(
          icon: Icon(visibleIcon),
          onPressed: onPressIcon,
          color: AppColors.secondaryTeal,
        ),
      ),
    );
  }
}

InputBorder inputBorder(Color borderColor) {
  return OutlineInputBorder(
    borderSide: BorderSide(
      color: borderColor,
      width: 1,
      style: BorderStyle.solid,
      strokeAlign: BorderSide.strokeAlignCenter,
    ),
    borderRadius: BorderRadius.circular(10),
  );
}
