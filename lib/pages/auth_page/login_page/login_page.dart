import 'package:flutter/material.dart';
import 'package:margnetra_super_app/core/app_page_route/app_page_route.dart';
import 'package:margnetra_super_app/core/global_widgets/app_button_widget.dart';
import 'package:margnetra_super_app/core/global_widgets/app_text_field.dart';
import 'package:margnetra_super_app/core/utils/app_colors.dart';
import 'package:margnetra_super_app/core/utils/app_text_style.dart';
import 'package:margnetra_super_app/core/utils/app_textfield_validation.dart';
import 'package:margnetra_super_app/core/utils/responsive.dart';

class LoginPage extends StatelessWidget {
   LoginPage({super.key});
  bool isObscurePasswordText = false;
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return 
    Scaffold(
      backgroundColor: AppColors.surface,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          // image: DecorationImage(
          //   image: AssetImage('assets/imgs/medlif_login_bg_green.png'),
          //   fit: BoxFit.cover,
          // ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Responsive.wp(context, 5)),
            child: SingleChildScrollView(
              child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                // key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: Responsive.wp(context, 24),
                      width: Responsive.wp(context, 35),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: AssetImage('assets/icon/app_logo_without_bg.png'),
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
                      // controller: emailController,
                      labelText: "Enter your email",
                      hintText: "Enter your email",
                      labelTextColor: AppColors.primaryHudCyan,
                      prefixIconWidget: Icon(
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
                   
                    StatefulBuilder(
                      builder: (context, ss) {
                        return AppTextField(
                          labelText: "Enter your password",
                          hintText: "Enter your password",
                          // controller: passwordController,
                          labelTextColor: AppColors.primaryHudCyan,
                          keyboardType: TextInputType.visiblePassword,
                          fillColor: Colors.transparent,
                          obscureText: isObscurePasswordText,
                          prefixIconWidget: Icon(
                            Icons.lock_outline_rounded,
                            color: AppColors.primaryHudCyan,
                            size: 20,
                          ),
                          visibleIcon: isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off_outlined,
                          onPressIcon: () {
                            ss(() {
                              isPasswordVisible = !isPasswordVisible;
                              isObscurePasswordText = !isObscurePasswordText;
                            });
                          },
                          validator: (value) {
                            return AppTextfieldValidation.validatePassword(
                              value,
                            );
                          },
                          onTap: (value) {
                            print("Password: $value");
                            // password = value;
                          },
                        );
                      },
                    ),
                    SizedBox(height: Responsive.hp(context, 2.5)),
                     Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "",
                          style: AppTextStyle.customGilroyFontMedium(
                            fontSize: Responsive.sp(context, 16),
                            color: AppColors.primaryHudCyan,
                          ),
                        ),
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
                          child: 
                          AppButtonWidget(
                            buttonText:   "Login",
                            
                            // backgroundColor:  AppColors.primaryHudCyan,

                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                AppPageRoute.navigationHomePage,
                              );
                              // if (_formKey.currentState!.validate()) {
                              //   context.read<AuthBloc>().add(
                              //     LoginEvent(
                              //       mLoginRequest: LoginRequest(
                              //         email: emailController.text,
                              //         password: passwordController.text,
                              //       ),
                              //     ),
                              //   );
                              // }
                            },
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
                              // AppPageRoute.bottomNavBar,
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

  }
}