import 'package:flutter/material.dart';
import 'package:margnetra_super_app/core/utils/app_colors.dart';
import 'package:margnetra_super_app/pages/all_nav_pages/bluetooth_connect_cab_page/bluetooth_connect_cab_page.dart';
import 'package:margnetra_super_app/pages/all_nav_pages/digilocker_page/digilocker_page.dart';
import 'package:margnetra_super_app/pages/all_nav_pages/e_chalan_page/e_chalan_page.dart';
import 'package:margnetra_super_app/pages/all_nav_pages/legal_page/legal_page.dart';
import 'package:margnetra_super_app/pages/all_nav_pages/wallet_page/wallet_page.dart';

class NavigationHomePage extends StatefulWidget {
  const NavigationHomePage({super.key});

  @override
  State<NavigationHomePage> createState() => _NavigationHomePageState();
}

class _NavigationHomePageState extends State<NavigationHomePage> {
  int currentPageIndex = 0;
  
  NavigationDestinationLabelBehavior labelBehavior = NavigationDestinationLabelBehavior.alwaysShow;
  final List<Widget> pages =  <Widget>[
    HudDashboardWidget(),
    MgcWalletWidget(),
    EChallanWidget(),
    LegalVaultWidget(),
    DigiLockerWidget(),
    const Center(child: Text('Settings Page')),
    const Center(child: Text('More Page')),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          iconTheme: WidgetStateProperty.resolveWith<IconThemeData?>(
            (Set<WidgetState> states) => IconThemeData(
              color: states.contains(WidgetState.selected)
                  ? AppColors.primaryHudCyan
                  : Colors.white,
            ),
          ),
        ),
        child: NavigationBar(
        labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>(
          (Set<WidgetState> states) => TextStyle(
            fontSize: 12,
            fontWeight:states.contains(WidgetState.selected) ? FontWeight.w600 : null,
            color: states.contains(WidgetState.selected)
                ? AppColors.primaryHudCyan
                : Colors.white,
          ),
        ),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow ,
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
            print('Current Page Index: $currentPageIndex');
          });
        },
        destinations:  <Widget>[
          
          NavigationDestination(icon: Icon(Icons.bluetooth_drive_outlined), label: 'Home',selectedIcon:  Image.asset('assets/icon/app_logo_without_bg.png', width: 35, height: 35,),
          // ColorFiltered(
          //   colorFilter: ColorFilter.mode(AppColors.primaryHudCyan, BlendMode.srcIn),
          //   child: Image.asset('assets/icon/app_logo_without_bg.png', width: 35, height: 35,),
          // ),
          ),
          NavigationDestination(icon: Icon(Icons.wallet), label: 'Wallet',),
          NavigationDestination(icon: Icon(Icons.drive_eta_outlined),label: 'Drive',),
          NavigationDestination(icon: Icon(Icons.luggage_outlined),label: 'Legal',),
          NavigationDestination(icon: Icon(Icons.history), label: 'Digiloker'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), label: 'Family'),
          // NavigationDestination(icon: Icon(Icons.more_horiz), label: 'More'),
        ],
        backgroundColor: AppColors.surface,
        height: 65,
        indicatorColor: Colors.transparent,
        
       
        ),
      ),
      body: pages[currentPageIndex],
    );
  }
}
