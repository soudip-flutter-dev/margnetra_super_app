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
import 'package:margnetra_super_app/pages/auth_page/data/models/auth_registration_request_model.dart';
import 'package:margnetra_super_app/pages/auth_page/logic/blocs/auth_bloc/auth_bloc.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _mobileNoController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  bool _isObscurePasswordText = true;
  bool _isPasswordVisible = false;

  bool _isObscureConfirmPasswordText = true;
  bool _isConfirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _mobileNoController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileNoController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onRegisterPressed(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
            RegisterEvent(
              mRegisterRequest: RegistrationRequestModel(
                fullName: _nameController.text.trim(),
                email: _emailController.text.trim(),
                phone: _mobileNoController.text.trim(),
                password: _passwordController.text,
                confirmPassword: _confirmPasswordController.text,
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
          CustomSnackBar.showSuccess(
            context,
            "Account created successfully!",
          );
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
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
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
                        'Create your account',
                        style: AppTextStyle.customGilroyFontMedium(
                          fontSize: Responsive.sp(context, 18),
                          color: AppColors.primaryText,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: Responsive.hp(context, 2.5)),
                      AppTextField(
                        controller: _nameController,
                        hintText: "Name",
                        labelText: "Enter your name",
                        cursorColor: AppColors.primaryHudCyan,
                        labelTextColor: AppColors.primaryHudCyan,
                        textColor: AppColors.primaryHudCyan,
                        prefixIconWidget: const Icon(
                          Icons.person_outline,
                          color: AppColors.primaryHudCyan,
                        ),
                        validator: (value) {
                          return AppTextfieldValidation.validateUsername(value);
                        },
                      ),
                      SizedBox(height: Responsive.hp(context, 1.2)),
                      AppTextField(
                        controller: _emailController,
                        hintText: "Email",
                        labelText: "Enter your email",
                        keyboardType: TextInputType.emailAddress,
                        cursorColor: AppColors.primaryHudCyan,
                        labelTextColor: AppColors.primaryHudCyan,
                        textColor: AppColors.primaryHudCyan,
                        prefixIconWidget: const Icon(
                          Icons.email_outlined,
                          color: AppColors.primaryHudCyan,
                        ),
                        validator: (value) {
                          return AppTextfieldValidation.validateEmail(value);
                        },
                      ),
                      SizedBox(height: Responsive.hp(context, 1.2)),
                      AppTextField(
                        controller: _mobileNoController,
                        hintText: "Mobile No",
                        labelText: "Enter your mobile number",
                        keyboardType: TextInputType.phone,
                        lenghtLimit: 10,
                        cursorColor: AppColors.primaryHudCyan,
                        labelTextColor: AppColors.primaryHudCyan,
                        textColor: AppColors.primaryHudCyan,
                        prefixIconWidget: const Icon(
                          Icons.phone_android,
                          color: AppColors.primaryHudCyan,
                        ),
                        validator: (value) {
                          return AppTextfieldValidation.validatePhoneNumber(
                            value,
                          );
                        },
                      ),
                      SizedBox(height: Responsive.hp(context, 1.2)),
                      AppTextField(
                        labelText: "Enter your password",
                        hintText: "Enter your password",
                        cursorColor: AppColors.primaryHudCyan,
                        labelTextColor: AppColors.primaryHudCyan,
                        textColor: AppColors.primaryHudCyan,
                        prefixIconWidget: const Icon(
                          Icons.lock_outline,
                          color: AppColors.primaryHudCyan,
                        ),
                        controller: _passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        fillColor: Colors.transparent,
                        obscureText: _isObscurePasswordText,
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
                          return AppTextfieldValidation.validatePassword(value);
                        },
                      ),
                      SizedBox(height: Responsive.hp(context, 1.2)),
                      AppTextField(
                        labelText: "Confirm your password",
                        hintText: "Confirm your password",
                        controller: _confirmPasswordController,
                        keyboardType: TextInputType.visiblePassword,
                        fillColor: Colors.transparent,
                        obscureText: _isObscureConfirmPasswordText,
                        visibleIcon: _isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off_outlined,
                        cursorColor: AppColors.primaryHudCyan,
                        labelTextColor: AppColors.primaryHudCyan,
                        textColor: AppColors.primaryHudCyan,
                        prefixIconWidget: const Icon(
                          Icons.lock_outline,
                          color: AppColors.primaryHudCyan,
                        ),
                        onPressIcon: () {
                          setState(() {
                            _isConfirmPasswordVisible =
                                !_isConfirmPasswordVisible;
                            _isObscureConfirmPasswordText =
                                !_isObscureConfirmPasswordText;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
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
                                buttonText: "Create Account",
                                backgroundColor: AppColors.primaryHudCyan,
                                onPressed: () => _onRegisterPressed(context),
                              ),
                      ),
                      SizedBox(height: Responsive.hp(context, 3.8)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Got an account?",
                            style: AppTextStyle.customGilroyFontMedium(
                              fontSize: Responsive.sp(context, 14),
                              color: AppColors.primaryHudCyan,
                            ),
                          ),
                          const SizedBox(width: 5),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppPageRoute.loginPage,
                              );
                            },
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 16,
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
        );
      },
    );
  }
}