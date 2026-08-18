import 'package:flutter/material.dart';
import 'package:margnetra_super_app/core/utils/app_colors.dart';
import 'package:margnetra_super_app/core/utils/app_text_style.dart';
import 'package:margnetra_super_app/core/utils/responsive.dart';


class AppbarWidget {
  static AppBar appbarWidget({required BuildContext context, required String title}){
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AppBar(
        backgroundColor: isDark ? Theme.of(context).colorScheme.surface : AppColors.accentSaffron,
        toolbarHeight: Responsive.minHeight(context, 8, 90),
        leading: Builder(
          builder: (context) {
            return InkWell(
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: Icon(Icons.menu, color: isDark ? Theme.of(context).colorScheme.onSurface : AppColors.accentSaffron),
            );
          }
        ),
        title: Text(
          title,
          style: AppTextStyle.customGilroyFontMedium(
            color: isDark ? Theme.of(context).colorScheme.onSurface : AppColors.accentSaffron,
            fontSize: Responsive.sp(context, 20),
          ),
        ),
        centerTitle: true,
        actions: [
          // IconButton(
          //   onPressed: () {
             
          //   },
          //   icon:  Icon(Icons.notifications, color: AppColors.white),
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
             Container(
                        height: 40,
                        width: 40,
                        // margin: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: AssetImage('assets/icons/medlif_icon.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Text("Patients App", style: AppTextStyle.customGilroyFontBold(fontSize: 12,fontWeight: FontWeight.w500,color: isDark ? Theme.of(context).colorScheme.onSurface.withOpacity(0.7) : Colors.white),)
            ],),
          )
        ],
      );
  }
}