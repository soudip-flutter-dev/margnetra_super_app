import 'package:flutter/material.dart';
import 'package:margnetra_super_app/core/global_widgets/app_button_widget.dart';
import 'package:margnetra_super_app/core/utils/app_colors.dart';
import 'package:margnetra_super_app/core/utils/app_specers.dart';
import 'package:margnetra_super_app/core/utils/app_text_style.dart';
import 'package:margnetra_super_app/core/utils/responsive.dart';

class AppDrawer extends StatelessWidget {
  AppDrawer({super.key});
  // String? patientName = DbServices().getPatientName();
  // String? patientId = DbServices().getPatientCode();
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // AppSpace.customHeight(35),
          // UserAccountsDrawerHeader(
          //   accountName: const Text("Driver Name"),
          //   accountEmail: const Text("driver@example.com"),
          //   currentAccountPicture: CircleAvatar(
          //     backgroundColor: Colors.white,
          //     child: Text(
          //       "D",
          //       style: TextStyle(
          //         fontSize: 40.0,
          //         color: Theme.of(context).colorScheme.primary,
          //       ),
          //     ),
          //   ),
          //   decoration: BoxDecoration(
          //     color: Theme.of(context).colorScheme.primary,
          //   ),
          // ),
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: AppColors.accentSaffron,
                    size: Responsive.sp(context, 20),
                  ),
                ),
                AppSpace.customWidth(10),
                CircleAvatar(
                  backgroundColor: AppColors.primaryHudCyan,
                  radius: Responsive.sp(context, 15),
                  child: CircleAvatar(
                    backgroundColor: AppColors.secondaryTeal,
                    radius: Responsive.sp(context, 14),
                    child: Icon(
                      Icons.person,
                      color: AppColors.accentSaffron,
                      size: Responsive.sp(context, 18),
                    ),
                  ),
                ),
                AppSpace.customWidth(10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "ID UserId",
                      style: AppTextStyle.customGilroyFontLight(
                        color: AppColors.primaryText,
                      ),
                    ),
                    Text(
                      "UserName" ,
                      style: AppTextStyle.customGilroyFontMedium(
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                        color: AppColors.primaryHudCyan,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          ListTile(
            leading: leading_icon(icon: Icons.info_outlined),
            title: title_text_widget(text: "Help & Support"),
            trailing: trailing_icon(),
            onTap: () {
              // Navigator.pushNamed(context, AppPageRoute.helpAndSupportPage);
            },
          ),
          ListTile(
            leading: leading_icon(icon: Icons.help_outline),
            title: title_text_widget(text: "FAQs"),
            trailing: trailing_icon(),
            onTap: () {
              // Navigator.pushNamed(context, AppPageRoute.faqPage);
            },
          ),
          // BlocBuilder<ThemeCubit, ThemeMode>(
          //   builder: (context, themeMode) {
          //     final isDarkMode = themeMode == ThemeMode.dark;
          //     return SwitchListTile(
          //       secondary: Icon(
          //         isDarkMode ? Icons.dark_mode : Icons.light_mode,
          //         color: Theme.of(context).colorScheme.primary,
          //       ),
          //       title: title_text_widget(
          //         text: isDarkMode ? 'Dark mode' : 'Light mode',
          //       ),
          //       value: isDarkMode,
          //       onChanged: (enabled) {
          //         context.read<ThemeCubit>().setDarkMode(enabled);
          //       },
          //     );
          //   },
          // ),
          ListTile(
            leading: leading_icon(icon: Icons.logout),
            title: title_text_widget(text: "Logout"),
            trailing: trailing_icon(),
            onTap: () {
              //  Navigator.pushNamed(context, AppPageRoute.logout);
              // AppPopUp.show(
              //   context: context,
              //   child: Container(
              //     height: 200,
              //     // width: MediaQuery.of( context).size.width *0.6,
              //     width: 430,
              //     decoration: BoxDecoration(
              //       color: isDark ? Colors.grey[900]! : AppColors.white,
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.center,
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         Text(
              //           "Logout",
              //           style: AppTextStyle.customGilroyFontMedium(
              //             color: isDark ? Colors.white : AppColors.primary,
              //             fontSize: Responsive.sp(context, 22),
              //             fontWeight: FontWeight.w700,
              //           ),
              //         ),
              //         SizedBox(height: Responsive.hp(context, 1.5)),
              //         Text(
              //           "Are you sure you want to Logout?",
              //           style: AppTextStyle.customGilroyFontMedium(
              //             color: isDark ? Colors.grey[300]! : AppColors.primary,
              //             fontSize: Responsive.sp(context, 16),
              //             fontWeight: FontWeight.w400,
              //           ),
              //         ),
              //         AppSpace.customHeight(20),
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //           children: [
              //             AppButtonWidget(
              //               onPressed: () {
              //                 // DbServices().removeToken();
              //                 // Navigator.pop(context);
              //                 // Navigator.pushReplacementNamed(
              //                 //   context,
              //                 //   AppPageRoute.loginPage,
              //                 // );
              //               },
              //               backgroundColor: AppColors.accentSaffron,
              //               buttonText: "Logout",
              //             ),
              //             AppButtonWidget(
              //               onPressed: () {
              //                 Navigator.pop(context);
              //               },
              //               backgroundColor: AppColors.surface,
              //               buttonText: "Cancel",
              //             ),
              //           ],
              //         ),
              //       ],
              //     ),
              //   ),
              // );
            },
          ),
        ],
      ),
    );
  }

  Icon leading_icon({required IconData icon}) =>
      Icon(icon, color: AppColors.accentSaffron, size: 20);

  Icon trailing_icon() => Icon(
    Icons.arrow_forward_ios_outlined,
    color: AppColors.accentSaffron,
    size: 15,
  );

  Text title_text_widget({required String text}) => Text(
    text,
    style: AppTextStyle.customGilroyFontMedium(
      color: AppColors.accentSaffron,
      fontSize: 18,
    ),
  );
}
