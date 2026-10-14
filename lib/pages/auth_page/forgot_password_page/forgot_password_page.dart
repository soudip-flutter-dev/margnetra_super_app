import 'package:flutter/material.dart';
import 'package:margnetra_super_app/core/app_page_route/app_page_route.dart';
import 'package:margnetra_super_app/core/global_widgets/app_button_widget.dart';
import 'package:margnetra_super_app/core/global_widgets/app_text_field.dart';
import 'package:margnetra_super_app/core/utils/app_colors.dart';
import 'package:margnetra_super_app/core/utils/app_text_style.dart';
import 'package:margnetra_super_app/core/utils/app_textfield_validation.dart';
import 'package:margnetra_super_app/core/utils/custom_snack_bar.dart';
import 'package:margnetra_super_app/core/utils/responsive.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _phoneController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _onSendOtpPressed() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      // Simulating network delay for smooth UX transition
      await Future.delayed(const Duration(milliseconds: 600));

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      final phone = _phoneController.text.trim();
      CustomSnackBar.showSuccess(
        context,
        "OTP sent successfully to +91 $phone",
      );

      Navigator.pushNamed(
        context,
        AppPageRoute.resetPasswordPage,
        arguments: {'phone': phone},
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
                      // Logo / Icon Badge
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
                            Icons.lock_reset_rounded,
                            color: AppColors.primaryHudCyan,
                            size: 44,
                          ),
                        ),
                      ),

                      SizedBox(height: Responsive.hp(context, 3)),

                      // Title
                      Text(
                        'Forgot Password',
                        style: AppTextStyle.customGilroyFontBold(
                          fontSize: Responsive.sp(context, 22),
                          color: AppColors.primaryText,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      SizedBox(height: Responsive.hp(context, 1.2)),

                      // Subtitle
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Responsive.wp(context, 4),
                        ),
                        child: Text(
                          'Enter your registered 10-digit mobile number. We will send you an OTP to reset your password.',
                          textAlign: TextAlign.center,
                          style: AppTextStyle.customGilroyFontRegular(
                            fontSize: Responsive.sp(context, 14),
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                      ),

                      SizedBox(height: Responsive.hp(context, 4)),

                      // Mobile Number Input Field
                      AppTextField(
                        controller: _phoneController,
                        labelText: "Phone Number",
                        hintText: "Enter 10-digit mobile number",
                        labelTextColor: AppColors.primaryHudCyan,
                        keyboardType: TextInputType.phone,
                        lenghtLimit: 10,
                        prefixIconWidget: const Icon(
                          Icons.phone_android_rounded,
                          color: AppColors.primaryHudCyan,
                          size: 20,
                        ),
                        validator: (value) {
                          return AppTextfieldValidation.validatePhoneNumber(value);
                        },
                      ),

                      SizedBox(height: Responsive.hp(context, 3.5)),

                      // Send OTP Button
                      SizedBox(
                        width: double.infinity,
                        child: _isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primaryHudCyan,
                                ),
                              )
                            : AppButtonWidget(
                                buttonText: "Send OTP",
                                onPressed: _onSendOtpPressed,
                              ),
                      ),

                      SizedBox(height: Responsive.hp(context, 4)),

                      // Back to Login link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Remember your password? ",
                            style: AppTextStyle.customGilroyFontLight(
                              fontSize: Responsive.sp(context, 14),
                              color: AppColors.primaryText,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
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
