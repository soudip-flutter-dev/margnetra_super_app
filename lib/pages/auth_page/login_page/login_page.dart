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
import 'package:margnetra_super_app/pages/auth_page/data/models/auth_login_request_model.dart';
import 'package:margnetra_super_app/pages/auth_page/logic/blocs/auth_bloc/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  bool _isObscurePasswordText = true;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
            LoginEvent(
              mLoginRequest: LoginRequestModel(
                email: _emailController.text.trim(),
                password: _passwordController.text,
              ),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          CustomSnackBar.showSuccess(context, "Login successful!");
          Navigator.pushReplacementNamed(
            context,
            AppPageRoute.speedometerPage,
          );
        } else if (state is AuthError) {
          CustomSnackBar.showError(context, state.message);
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Center(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: Responsive.wp(context, 5)),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: Responsive.wp(context, 24),
                          width: Responsive.wp(context, 35),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: const DecorationImage(
                              image: AssetImage(
                                  'assets/icon/app_logo_without_bg.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: Responsive.hp(context, 2.5)),
                        Text(
                          'Welcome back',
                          style: AppTextStyle.customGilroyFontBold(
                            fontSize: Responsive.sp(context, 18),
                            color: AppColors.primaryText,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: Responsive.hp(context, 1.5)),
                        Text(
                          'Login to your account to continue',
                          style: AppTextStyle.customGilroyFontLight(
                            fontSize: Responsive.sp(context, 14),
                            color: AppColors.primaryText,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: Responsive.hp(context, 5)),
                        AppTextField(
                          controller: _emailController,
                          labelText: "Enter your email",
                          hintText: "Enter your email",
                          labelTextColor: AppColors.primaryHudCyan,
                          prefixIconWidget: const Icon(
                            Icons.mail_outlined,
                            color: AppColors.primaryHudCyan,
                            size: 20,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            return AppTextfieldValidation.validateEmail(value);
                          },
                        ),
                        SizedBox(height: Responsive.hp(context, 2.4)),
                        AppTextField(
                          labelText: "Enter your password",
                          hintText: "Enter your password",
                          controller: _passwordController,
                          labelTextColor: AppColors.primaryHudCyan,
                          keyboardType: TextInputType.visiblePassword,
                          fillColor: Colors.transparent,
                          obscureText: _isObscurePasswordText,
                          prefixIconWidget: const Icon(
                            Icons.lock_outline_rounded,
                            color: AppColors.primaryHudCyan,
                            size: 20,
                          ),
                          visibleIcon: _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off_outlined,
                          onPressIcon: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                              _isObscurePasswordText = !_isObscurePasswordText;
                            });
                          },
                          validator: (value) {
                            return AppTextfieldValidation.validatePassword(
                              value,
                            );
                          },
                        ),
                        SizedBox(height: Responsive.hp(context, 2.5)),
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(""),
                            Text(
                              "Forgot Password?",
                              style: AppTextStyle.customGilroyFontMedium(
                                fontSize: Responsive.sp(context, 16),
                                color: AppColors.secondaryTeal,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: Responsive.hp(context, 3.5)),
                        SizedBox(
                          width: double.infinity,
                          child: isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.primaryHudCyan,
                                  ),
                                )
                              : AppButtonWidget(
                                  buttonText: "Login",
                                  onPressed: () => _onLoginPressed(context),
                                ),
                        ),
                        SizedBox(height: Responsive.hp(context, 3.8)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account?",
                              style: AppTextStyle.customGilroyFontMedium(
                                fontSize: Responsive.sp(context, 14),
                                color: AppColors.primaryHudCyan,
                              ),
                            ),
                            SizedBox(width: Responsive.wp(context, 1.5)),
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppPageRoute.registrationPage,
                                );
                              },
                              child: Text(
                                "Create Account",
                                style: AppTextStyle.customGilroyFontMedium(
                                  fontSize: Responsive.sp(context, 16),
                                  color: AppColors.secondaryTeal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}