import 'dart:async';
import 'package:flutter/material.dart';
import 'package:margnetra_super_app/core/app_page_route/app_page_route.dart';
import 'package:margnetra_super_app/core/global_widgets/app_button_widget.dart';
import 'package:margnetra_super_app/core/global_widgets/app_text_field.dart';
import 'package:margnetra_super_app/core/utils/app_colors.dart';
import 'package:margnetra_super_app/core/utils/app_text_style.dart';
import 'package:margnetra_super_app/core/utils/app_textfield_validation.dart';
import 'package:margnetra_super_app/core/utils/custom_snack_bar.dart';
import 'package:margnetra_super_app/core/utils/responsive.dart';

class ResetPasswordPage extends StatefulWidget {
  final String? initialPhone;

  const ResetPasswordPage({super.key, this.initialPhone});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _otpController;
  late final TextEditingController _newPasswordController;
  late final TextEditingController _confirmPasswordController;

  bool _isObscureNewPassword = true;
  bool _isNewPasswordVisible = false;

  bool _isObscureConfirmPassword = true;
  bool _isConfirmPasswordVisible = false;

  bool _isLoading = false;

  int _resendCountdown = 30;
  Timer? _timer;
  String _phone = '';

  @override
  void initState() {
    super.initState();
    _otpController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _phone = widget.initialPhone ?? '';
    _startResendTimer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_phone.isEmpty) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map<String, dynamic> && args['phone'] != null) {
        _phone = args['phone'].toString();
      }
    }
  }

  void _startResendTimer() {
    _timer?.cancel();
    setState(() {
      _resendCountdown = 30;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown > 0) {
        setState(() {
          _resendCountdown--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onResendOtp() {
    if (_resendCountdown > 0) return;
    _startResendTimer();
    CustomSnackBar.showInfo(
      context,
      "A new OTP has been sent to +91 $_phone",
    );
  }

  void _onResetPasswordPressed() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      // Simulating request delay
      await Future.delayed(const Duration(milliseconds: 700));

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      CustomSnackBar.showSuccess(
        context,
        "Password reset successfully! Please sign in with your new password.",
      );

      Navigator.pushNamedAndRemoveUntil(
        context,
        AppPageRoute.loginPage,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.primaryHudCyan,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.wp(context, 5),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Lock Security Badge
                      Container(
                        height: Responsive.wp(context, 22),
                        width: Responsive.wp(context, 22),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.surface,
                          border: Border.all(
                            color: AppColors.primaryHudCyan.withValues(alpha: 0.3),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryHudCyan.withValues(alpha: 0.15),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.shield_outlined,
                            color: AppColors.primaryHudCyan,
                            size: 42,
                          ),
                        ),
                      ),

                      SizedBox(height: Responsive.hp(context, 2.8)),

                      // Title
                      Text(
                        'Reset Password',
                        style: AppTextStyle.customGilroyFontBold(
                          fontSize: Responsive.sp(context, 22),
                          color: AppColors.primaryText,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      SizedBox(height: Responsive.hp(context, 1.2)),

                      // Subtitle with Phone pill
                      Text(
                        'Enter the OTP sent to your phone and create a strong new password.',
                        textAlign: TextAlign.center,
                        style: AppTextStyle.customGilroyFontRegular(
                          fontSize: Responsive.sp(context, 14),
                          color: const Color(0xFF94A3B8),
                        ),
                      ),

                      if (_phone.isNotEmpty) ...[
                        SizedBox(height: Responsive.hp(context, 1.5)),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.secondaryTeal.withValues(alpha: 0.4),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.phone_android_rounded,
                                color: AppColors.primaryHudCyan,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '+91 $_phone',
                                style: AppTextStyle.customGilroyFontMedium(
                                  fontSize: Responsive.sp(context, 13),
                                  color: AppColors.primaryText,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      SizedBox(height: Responsive.hp(context, 3.5)),

                      // OTP Field
                      AppTextField(
                        controller: _otpController,
                        labelText: "OTP Verification Code",
                        hintText: "Enter 6-digit OTP",
                        labelTextColor: AppColors.primaryHudCyan,
                        keyboardType: TextInputType.number,
                        lenghtLimit: 6,
                        prefixIconWidget: const Icon(
                          Icons.pin_outlined,
                          color: AppColors.primaryHudCyan,
                          size: 20,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'OTP code is required';
                          }
                          if (value.trim().length < 4) {
                            return 'Enter a valid OTP code';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: Responsive.hp(context, 1)),

                      // Resend OTP row
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _resendCountdown == 0 ? _onResendOtp : null,
                          child: Text(
                            _resendCountdown > 0
                                ? "Resend OTP in ${_resendCountdown}s"
                                : "Resend OTP",
                            style: AppTextStyle.customGilroyFontMedium(
                              fontSize: Responsive.sp(context, 13),
                              color: _resendCountdown > 0
                                  ? const Color(0xFF64748B)
                                  : AppColors.secondaryTeal,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: Responsive.hp(context, 1.5)),

                      // New Password Field
                      AppTextField(
                        controller: _newPasswordController,
                        labelText: "New Password",
                        hintText: "Enter your new password",
                        labelTextColor: AppColors.primaryHudCyan,
                        obscureText: _isObscureNewPassword,
                        prefixIconWidget: const Icon(
                          Icons.lock_outline_rounded,
                          color: AppColors.primaryHudCyan,
                          size: 20,
                        ),
                        visibleIcon: _isNewPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        onPressIcon: () {
                          setState(() {
                            _isNewPasswordVisible = !_isNewPasswordVisible;
                            _isObscureNewPassword = !_isObscureNewPassword;
                          });
                        },
                        validator: (value) {
                          return AppTextfieldValidation.validatePassword(value);
                        },
                      ),

                      SizedBox(height: Responsive.hp(context, 2.4)),

                      // Confirm Password Field
                      AppTextField(
                        controller: _confirmPasswordController,
                        labelText: "Confirm New Password",
                        hintText: "Re-enter your new password",
                        labelTextColor: AppColors.primaryHudCyan,
                        obscureText: _isObscureConfirmPassword,
                        prefixIconWidget: const Icon(
                          Icons.lock_reset_rounded,
                          color: AppColors.primaryHudCyan,
                          size: 20,
                        ),
                        visibleIcon: _isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        onPressIcon: () {
                          setState(() {
                            _isConfirmPasswordVisible =
                                !_isConfirmPasswordVisible;
                            _isObscureConfirmPassword =
                                !_isObscureConfirmPassword;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != _newPasswordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: Responsive.hp(context, 3.5)),

                      // Submit Reset Button
                      SizedBox(
                        width: double.infinity,
                        child: _isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primaryHudCyan,
                                ),
                              )
                            : AppButtonWidget(
                                buttonText: "Reset Password",
                                onPressed: _onResetPasswordPressed,
                              ),
                      ),

                      SizedBox(height: Responsive.hp(context, 3)),

                      // Back to Login link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Back to ",
                            style: AppTextStyle.customGilroyFontLight(
                              fontSize: Responsive.sp(context, 14),
                              color: AppColors.primaryText,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                AppPageRoute.loginPage,
                                (route) => false,
                              );
                            },
                            child: Text(
                              "Sign In",
                              style: AppTextStyle.customGilroyFontBold(
                                fontSize: Responsive.sp(context, 14),
                                color: AppColors.primaryHudCyan,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: Responsive.hp(context, 2)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
