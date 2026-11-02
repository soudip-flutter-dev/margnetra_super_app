import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:margnetra_super_app/core/app_page_route/app_page_route.dart';
import 'package:margnetra_super_app/core/global_widgets/app_button_widget.dart';
import 'package:margnetra_super_app/core/global_widgets/app_text_field.dart';
import 'package:margnetra_super_app/core/utils/app_colors.dart';
import 'package:margnetra_super_app/core/utils/app_text_style.dart';
import 'package:margnetra_super_app/core/utils/app_textfield_validation.dart';
import 'package:margnetra_super_app/core/utils/custom_snack_bar.dart';
import 'package:margnetra_super_app/core/utils/responsive.dart';
import 'package:margnetra_super_app/pages/auth_page/data/models/models.dart';
import 'package:margnetra_super_app/pages/auth_page/logic/blocs/auth_bloc/auth_bloc.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onSendResetInstructionsPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text.trim();
      context.read<AuthBloc>().add(
            ForgotPasswordEvent(
              mForgotPasswordRequest: ForgotPasswordRequestModel(email: email),
            ),
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
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is ForgotPasswordSuccess) {
            CustomSnackBar.showSuccess(
              context,
              state.response.message ??
                  "If an account exists for this email, password reset instructions will be sent.",
            );
            Navigator.pushNamed(
              context,
              AppPageRoute.resetPasswordPage,
              arguments: {'email': _emailController.text.trim()},
            );
          } else if (state is AuthError) {
            CustomSnackBar.showError(context, state.message);
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return SafeArea(
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
                              'Enter your registered email address. We will send you password reset instructions.',
                              textAlign: TextAlign.center,
                              style: AppTextStyle.customGilroyFontRegular(
                                fontSize: Responsive.sp(context, 14),
                                color: const Color(0xFF94A3B8),
                              ),
                            ),
                          ),

                          SizedBox(height: Responsive.hp(context, 4)),

                          // Email Input Field
                          AppTextField(
                            controller: _emailController,
                            labelText: "Email Address",
                            hintText: "Enter registered email address",
                            labelTextColor: AppColors.primaryHudCyan,
                            keyboardType: TextInputType.emailAddress,
                            prefixIconWidget: const Icon(
                              Icons.email_outlined,
                              color: AppColors.primaryHudCyan,
                              size: 20,
                            ),
                            validator: (value) {
                              return AppTextfieldValidation.validateEmail(value);
                            },
                          ),

                          SizedBox(height: Responsive.hp(context, 3.5)),

                          // Submit Button
                          SizedBox(
                            width: double.infinity,
                            child: isLoading
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.primaryHudCyan,
                                    ),
                                  )
                                : AppButtonWidget(
                                    buttonText: "Send Reset Link",
                                    onPressed: _onSendResetInstructionsPressed,
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
          );
        },
      ),
    );
  }
}
