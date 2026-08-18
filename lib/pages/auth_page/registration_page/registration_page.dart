import 'package:flutter/material.dart';
import 'package:margnetra_super_app/core/app_page_route/app_page_route.dart';
import 'package:margnetra_super_app/core/global_widgets/app_button_widget.dart';
import 'package:margnetra_super_app/core/global_widgets/app_text_field.dart';
import 'package:margnetra_super_app/core/utils/app_colors.dart';
import 'package:margnetra_super_app/core/utils/app_text_style.dart';
import 'package:margnetra_super_app/core/utils/app_textfield_validation.dart';
import 'package:margnetra_super_app/core/utils/responsive.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool isObscurePasswordText = true;

  bool isPasswordVisible = false;

  String password = "";
  @override
  Widget build(BuildContext context) {
    return 
    Scaffold(
      backgroundColor: AppColors.surface,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          
          child: SingleChildScrollView(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
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
                 
                // SizedBox(height: Responsive.hp(context, 8)),
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
                        // controller: nameController,
                        hintText: "Name",
                        labelText: "Enter your name",
                        cursorColor: AppColors.primaryHudCyan,
                        labelTextColor: AppColors.primaryHudCyan,
                        textColor: AppColors.primaryHudCyan,
                        prefixIconWidget: Icon(
                          Icons.person_outline,
                          color: AppColors.primaryHudCyan,
                        ),
                        validator: (value) {
                          return AppTextfieldValidation.validateUsername(
                            value,
                          );
                        },
                      ),
                      // space12,
                     
                      SizedBox(height: Responsive.hp(context, 1.2)),
                      AppTextField(
                        // controller: emailController,
                        hintText: "Email",
                        labelText: "Enter your email",
                        keyboardType: TextInputType.emailAddress,
                        cursorColor: AppColors.primaryHudCyan,
                        labelTextColor: AppColors.primaryHudCyan,
                        textColor: AppColors.primaryHudCyan,
                        prefixIconWidget: Icon(
                          Icons.email_outlined,
                          color: AppColors.primaryHudCyan,
                        ),
                        validator: (value) {
                          return AppTextfieldValidation.validateEmail(
                            value,
                          );
                        },
                      ),
                
                      // space12,
                     
                      SizedBox(height: Responsive.hp(context, 1.2)),
                      AppTextField(
                        // controller: mobileNoController,
                        hintText: "Mobile No",
                        labelText: "Enter your mobile number",
                        keyboardType: TextInputType.phone,
                        lenghtLimit: 10,
                        cursorColor: AppColors.primaryHudCyan,
                        labelTextColor: AppColors.primaryHudCyan,
                        textColor: AppColors.primaryHudCyan,
                        prefixIconWidget: Icon(
                          Icons.phone_android,
                          color: AppColors.primaryHudCyan,
                        ),
                        validator: (value) {
                          return AppTextfieldValidation.validatePhoneNumber(
                            value,
                          );
                        },
                      ),
                      // space12,
                      
                      SizedBox(height: Responsive.hp(context, 1.2)),
                      StatefulBuilder(
                        builder: (context, ss) {
                          return AppTextField(
                            labelText: "Enter your password",
                            hintText: "Enter your password",
                            cursorColor: AppColors.primaryHudCyan,
                            labelTextColor: AppColors.primaryHudCyan,
                            textColor: AppColors.primaryHudCyan,
                            prefixIconWidget: Icon(
                              Icons.lock_outline,
                              color: AppColors.primaryHudCyan,
                            ),
                            // controller: passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            fillColor: Colors.transparent,
                            obscureText: isObscurePasswordText,
                            visibleIcon: isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off_outlined,
                            onPressIcon: () {
                              ss(() {
                                isPasswordVisible = !isPasswordVisible;
                                isObscurePasswordText =
                                    !isObscurePasswordText;
                              });
                            },
                            validator: (value) {
                              return AppTextfieldValidation.validatePassword(
                                value,
                              );
                            },
                            onTap: (value) {
                              password = value;
                              print("password $password");
                            },
                          );
                        },
                      ),
                      // space12,
                      
                      SizedBox(height: Responsive.hp(context, 1.2)),
                      StatefulBuilder(
                        builder: (context, ss) {
                          return AppTextField(
                            labelText: "Confirm your password",
                            hintText: "Confirm your password",
                            // controller: confirmPasswordController,
                            keyboardType: TextInputType.visiblePassword,
                            fillColor: Colors.transparent,
                            obscureText: isObscurePasswordText,
                            visibleIcon: isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off_outlined,
                            cursorColor: AppColors.primaryHudCyan,
                            labelTextColor: AppColors.primaryHudCyan,
                            textColor: AppColors.primaryHudCyan,
                            prefixIconWidget: Icon(
                              Icons.lock_outline,
                              color: AppColors.primaryHudCyan,
                            ),
                            onPressIcon: () {
                              ss(() {
                                isPasswordVisible = !isPasswordVisible;
                                isObscurePasswordText =
                                    !isObscurePasswordText;
                              });
                            },
                            validator: (value) {
                              // if (value == null || value.isEmpty) {
                              //   return 'Please confirm your password';
                              // } else if (value != passwordController.text) {
                              //   return 'Passwords do not match';
                              // }
                              // return null;
                            },
                          );
                        },
                      ),
                    
                SizedBox(height: Responsive.hp(context, 3.5)),
                SizedBox(
                  width: double.infinity,
                  child:AppButtonWidget(
                        buttonText: "Create Account",
                        backgroundColor: AppColors.primaryHudCyan,
                        onPressed: () {
                          
                        },
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
                    SizedBox(width: 5),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, AppPageRoute.loginPage);
                      },
                
                      child: Text(
                        "Login",
                        style: AppTextStyle.customGilroyFontMedium(
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
    );
  
  }
}