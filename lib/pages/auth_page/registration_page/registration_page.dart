import 'package:flutter/material.dart';
import 'package:margnetra_super_app/core/utils/app_colors.dart';
import 'package:margnetra_super_app/core/utils/app_text_style.dart';
import 'package:margnetra_super_app/core/utils/responsive.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  @override
  Widget build(BuildContext context) {
    return 
    Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/imgs/registration_bg_pic.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            // key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: Responsive.hp(context, 8)),
                  Text(
                    'Create your account',
                    style: AppTextStyle.customGilroyFontMedium(
                      fontSize: Responsive.sp(context, 18),
                      color: AppColors.primaryText,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: Responsive.hp(context, 2.5)),

                  // Container(
                  //   constraints: BoxConstraints(minHeight: Responsive.hp(context, 56)),
                  //   child: SingleChildScrollView(
                  //     child: Column(
                  //       children: [
                  //         Row(
                  //           mainAxisAlignment: MainAxisAlignment.start,
                  //           children: [
                  //             Text(
                  //               "Register as",
                  //               style: AppTextStyle.customGilroyFontMedium(
                  //                 fontSize: Responsive.sp(context, 16),
                  //                 color: AppColors.primary2,
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //         SizedBox(height: Responsive.hp(context, 1.2)),

                  //         //    Row(
                  //         //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         //   children: [
                  //         //     // Text(
                  //         //     //   selectedVehicleType,
                  //         //     //   style: AppTextStyle.customGilroyFontLight(
                  //         //     //     fontSize: 15,
                  //         //     //     color: selectedVehicleType == "Select Option"
                  //         //     //         ? AppColors.errorColor
                  //         //     //         : AppColors.primary,
                  //         //     //   ),
                  //         //     // ),
                  //         //     Container(
                  //         //       width: MediaQuery.of(context).size.width * 0.9,
                  //         //       height: 45,
                  //         //       padding: EdgeInsets.symmetric(horizontal: 15),
                  //         //       decoration: BoxDecoration(
                  //         //         borderRadius: BorderRadius.circular(12),
                  //         //         color: AppColors.textColor2,
                  //         //       ),
                  //         //       child:

                  //         //        DropdownButton<String>(
                  //         //         hint: Text(
                  //         //           dfaultValue,
                  //         //           style: AppTextStyle.customGilroyFontMedium(),
                  //         //         ),
                  //         //         borderRadius: BorderRadius.circular(12),
                  //         //         dropdownColor: AppColors.textColor2,
                  //         //         padding: EdgeInsets.all(0),
                  //         //         elevation: 0,
                  //         //         underline: SizedBox(),
                  //         //         isExpanded: true,
                  //         //         value: selectedValue,
                  //         //         items: items.map((String item) {
                  //         //           return DropdownMenuItem<String>(
                  //         //             value: item,
                  //         //             child: Text(item),
                  //         //           );
                  //         //         }).toList(),
                  //         //         onChanged: (String? newValue) {
                  //         //           setState(() {
                  //         //              selectedValue = newValue!;
                  //         //              print("selectedValue $selectedValue");
                  //         //             if (selectedValue != null) {
                  //         //               dfaultValue = "Patient";
                  //         //             }
                  //         //           });(() {

                  //         //             // print("selectedValue $selectedValue");
                  //         //           });
                  //         //         },
                  //         //       ),

                  //         //     ),
                  //         //   ],
                  //         // ),
                  //         //             selectedValue != "Patient" || selectedValue == null ? selectedValue == null ? SizedBox():      Row(
                  //         //       mainAxisAlignment: MainAxisAlignment.start,
                  //         //       children: [
                  //         //        Text( "${selectedValue != "Patient" || selectedValue == null ? selectedValue == null ? "" : selectedValue : ""}",style: AppTextStyle.customGilroyFontMedium(fontSize: 16,color: AppColors.textColor2),),

                  //         //     ],) : SizedBox(),
                  //         //    selectedValue != "Patient" || selectedValue == null ? selectedValue == null ? AppSpace.h10 : AppSpace.h10 : SizedBox(),
                  //         //   selectedValue != "Patient" || selectedValue == null ? selectedValue == null ? SizedBox() : AppTextField(

                  //         //       hintText: selectedValue == "Doctor" ? "Enter your medical license number" : "Enter your employee ID",
                  //         //       labelText: selectedValue == "Doctor" ? "Enter your medical license number" : "Enter your employee ID",
                  //         //     ) : SizedBox(),

                  //         // <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>
                  //         AppTextField(
                  //           controller: registerAsController,
                  //           hintText: "Patient Name",
                  //           labelText: "This is default role assigned to you",
                  //           isReadOnly: true,
                  //           cursorColor: AppColors.primary2,
                  //           labelTextColor: AppColors.greyShade,
                  //           textColor: AppColors.primary2,
                  //           prefixIconWidget: Icon(
                  //             Icons.person_outline,
                  //             color: AppColors.primary2,
                  //           ),
                  //         ),

                  //         space12,
                  //         Row(
                  //           mainAxisAlignment: MainAxisAlignment.start,
                  //           children: [
                  //             Text(
                  //               "Full Name",
                  //               style: AppTextStyle.customGilroyFontMedium(
                  //                 fontSize: Responsive.sp(context, 16),
                  //                 color: AppColors.primary2,
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //         space12,
                  //         AppTextField(
                  //           controller: nameController,
                  //           hintText: "Name",
                  //           labelText: "Enter your name",
                  //           cursorColor: AppColors.primary2,
                  //           labelTextColor: AppColors.greyShade,
                  //           textColor: AppColors.primary2,
                  //           prefixIconWidget: Icon(
                  //             Icons.person_outline,
                  //             color: AppColors.primary2,
                  //           ),
                  //           validator: (value) {
                  //             return AppTextfieldValidation.validateUsername(
                  //               value,
                  //             );
                  //           },
                  //         ),
                  //         space12,
                  //         Row(
                  //           mainAxisAlignment: MainAxisAlignment.start,
                  //           children: [
                  //             Text(
                  //               "Email",
                  //               style: AppTextStyle.customGilroyFontMedium(
                  //                 fontSize: Responsive.sp(context, 16),
                  //                 color: AppColors.primary2,
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //         SizedBox(height: Responsive.hp(context, 1.2)),
                  //         AppTextField(
                  //           controller: emailController,
                  //           hintText: "Email",
                  //           labelText: "Enter your email",
                  //           keyboardType: TextInputType.emailAddress,
                  //           cursorColor: AppColors.primary2,
                  //           labelTextColor: AppColors.greyShade,
                  //           textColor: AppColors.primary2,
                  //           prefixIconWidget: Icon(
                  //             Icons.email_outlined,
                  //             color: AppColors.primary2,
                  //           ),
                  //           validator: (value) {
                  //             return AppTextfieldValidation.validateEmail(
                  //               value,
                  //             );
                  //           },
                  //         ),

                  //         space12,
                  //         Row(
                  //           mainAxisAlignment: MainAxisAlignment.start,
                  //           children: [
                  //             Text(
                  //               "Mobile No",
                  //               style: AppTextStyle.customGilroyFontMedium(
                  //                 fontSize: Responsive.sp(context, 16),
                  //                 color: AppColors.primary2,
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //         SizedBox(height: Responsive.hp(context, 1.2)),
                  //         AppTextField(
                  //           controller: mobileNoController,
                  //           hintText: "Mobile No",
                  //           labelText: "Enter your mobile number",
                  //           keyboardType: TextInputType.phone,
                  //           lenghtLimit: 10,
                  //           cursorColor: AppColors.primary2,
                  //           labelTextColor: AppColors.greyShade,
                  //           textColor: AppColors.primary2,
                  //           prefixIconWidget: Icon(
                  //             Icons.phone_android,
                  //             color: AppColors.primary2,
                  //           ),
                  //           validator: (value) {
                  //             return AppTextfieldValidation.validatePhoneNumber(
                  //               value,
                  //             );
                  //           },
                  //         ),
                  //         space12,
                  //         Row(
                  //           mainAxisAlignment: MainAxisAlignment.start,
                  //           children: [
                  //             Text(
                  //               "Create Password",
                  //               style: AppTextStyle.customGilroyFontMedium(
                  //                 fontSize: Responsive.sp(context, 16),
                  //                 color: AppColors.primary2,
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //         SizedBox(height: Responsive.hp(context, 1.2)),
                  //         StatefulBuilder(
                  //           builder: (context, ss) {
                  //             return AppTextField(
                  //               labelText: "Enter your password",
                  //               hintText: "Enter your password",
                  //               cursorColor: AppColors.primary2,
                  //               labelTextColor: AppColors.greyShade,
                  //               textColor: AppColors.primary2,
                  //               prefixIconWidget: Icon(
                  //                 Icons.lock_outline,
                  //                 color: AppColors.primary2,
                  //               ),
                  //               controller: passwordController,
                  //               keyboardType: TextInputType.visiblePassword,
                  //               fillColor: Colors.transparent,
                  //               obscureText: isObscurePasswordText,
                  //               visibleIcon: isPasswordVisible
                  //                   ? Icons.visibility
                  //                   : Icons.visibility_off_outlined,
                  //               onPressIcon: () {
                  //                 ss(() {
                  //                   isPasswordVisible = !isPasswordVisible;
                  //                   isObscurePasswordText =
                  //                       !isObscurePasswordText;
                  //                 });
                  //               },
                  //               validator: (value) {
                  //                 return AppTextfieldValidation.validatePassword(
                  //                   value,
                  //                 );
                  //               },
                  //               onTap: (value) {
                  //                 password = value;
                  //                 print("password $password");
                  //               },
                  //             );
                  //           },
                  //         ),
                  //         space12,
                  //         Row(
                  //           mainAxisAlignment: MainAxisAlignment.start,
                  //           children: [
                  //             Text(
                  //               "Confirm Password",
                  //               style: AppTextStyle.customGilroyFontMedium(
                  //                 fontSize: Responsive.sp(context, 16),
                  //                 color: AppColors.primary2,
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //         SizedBox(height: Responsive.hp(context, 1.2)),
                  //         StatefulBuilder(
                  //           builder: (context, ss) {
                  //             return AppTextField(
                  //               labelText: "Confirm your password",
                  //               hintText: "Confirm your password",
                  //               controller: confirmPasswordController,
                  //               keyboardType: TextInputType.visiblePassword,
                  //               fillColor: Colors.transparent,
                  //               obscureText: isObscurePasswordText,
                  //               visibleIcon: isPasswordVisible
                  //                   ? Icons.visibility
                  //                   : Icons.visibility_off_outlined,
                  //               cursorColor: AppColors.primary2,
                  //               labelTextColor: AppColors.greyShade,
                  //               textColor: AppColors.primary2,
                  //               prefixIconWidget: Icon(
                  //                 Icons.lock_outline,
                  //                 color: AppColors.primary2,
                  //               ),
                  //               onPressIcon: () {
                  //                 ss(() {
                  //                   isPasswordVisible = !isPasswordVisible;
                  //                   isObscurePasswordText =
                  //                       !isObscurePasswordText;
                  //                 });
                  //               },
                  //               validator: (value) {
                  //                 if (value == null || value.isEmpty) {
                  //                   return 'Please confirm your password';
                  //                 } else if (value != passwordController.text) {
                  //                   return 'Passwords do not match';
                  //                 }
                  //                 return null;
                  //               },
                  //             );
                  //           },
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(height: Responsive.hp(context, 3.5)),
                  // SizedBox(
                  //   width: double.infinity,
                  //   child: BlocConsumer<AuthBloc, AuthState>(
                  //     listener: (context, state) {
                  //       if (state is AuthLoading) {
                  //         isLoading = true;

                  //         FullScreenDialogLoder.showLoadingDialog(context);
                  //       } else {
                  //         isLoading = false;
                  //         FullScreenDialogLoder.hideLoadingDialog(context);
                  //       }
                  //       if (state is RegisterSuccess) {
                  //         isLoading = false;
                  //         AppSnackber.showSuccessSnackber(
                  //           context,
                  //           state.message,
                  //         );
                  //         Navigator.pushNamed(context, AppPageRoute.loginPage);
                  //       } else if (state is RegisterFailure) {
                  //         isLoading = false;
                  //         AppSnackber.showErrorSnackber(context, state.error);
                  //       }
                  //     },
                  //     builder: (context, state) {
                  //       return AppButtonWidget(
                  //         buttonText: isLoading
                  //             ? "Creating Account..."
                  //             : "Create Account",
                  //         backgroundColor: isLoading
                  //             ? AppColors.primary
                  //             : AppColors.primary2,
                  //         onPressed: () {
                  //           if (_formKey.currentState!.validate()) {
                  //             context.read<AuthBloc>().add(
                  //               RegisterEvent(
                  //                 mRegisterRequest: RegisterRequest(
                  //                   name: nameController.text,
                  //                   email: emailController.text,
                  //                   password: passwordController.text,
                  //                   role: selectedValue ?? "Patient",
                  //                   phone: mobileNoController.text,
                  //                 ),
                  //               ),
                  //             );
                  //           }
                  //         },
                  //       );
                  //     },
                  //   ),
                  // ),
                  // SizedBox(height: Responsive.hp(context, 3.8)),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Text(
                  //       "Got an account?",
                  //       style: AppTextStyle.customGilroyFontMedium(
                  //         fontSize: Responsive.sp(context, 14),
                  //         color: AppColors.greyShade,
                  //       ),
                  //     ),
                  //     SizedBox(width: 5),
                  //     InkWell(
                  //       onTap: () {
                  //         Navigator.pushNamed(context, AppPageRoute.loginPage);
                  //       },

                  //       child: Text(
                  //         "Login",
                  //         style: AppTextStyle.customGilroyFontMedium(
                  //           fontSize: 16,
                  //           color: AppColors.primary,
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                
                ],
              ),
            ),
          ),
        ),
      ),
    );
  
  }
}