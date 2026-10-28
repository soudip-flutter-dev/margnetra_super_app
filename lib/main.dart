import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:margnetra_super_app/core/app_page_route/app_page_route.dart';
import 'package:margnetra_super_app/core/app_services/local_storage/shared_pref_service.dart';
import 'package:margnetra_super_app/pages/auth_page/data/repositories/auth_repository.dart';
import 'package:margnetra_super_app/pages/auth_page/logic/blocs/auth_bloc/auth_bloc.dart';
import 'package:margnetra_super_app/pages/profile_page/data/repositories/user_repository.dart';
import 'package:margnetra_super_app/pages/profile_page/logic/blocs/profile_bloc/profile_bloc.dart';
import 'package:margnetra_super_app/pages/profile_page/logic/blocs/settings_bloc/settings_bloc.dart';
import 'package:margnetra_super_app/pages/profile_page/logic/blocs/vehicle_bloc/vehicle_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize local persistent storage
  await SharedPrefService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final userRepository = UserRepository();

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
            authRepository: AuthRepository(),
          )..add(CheckAuthStatusEvent()),
        ),
        BlocProvider<ProfileBloc>(
          create: (context) => ProfileBloc(
            userRepository: userRepository,
          )..add(const LoadProfileEvent()),
        ),
        BlocProvider<VehicleBloc>(
          create: (context) => VehicleBloc(
            userRepository: userRepository,
          )..add(const LoadVehiclesEvent()),
        ),
        BlocProvider<SettingsBloc>(
          create: (context) => SettingsBloc(
            userRepository: userRepository,
          )..add(const LoadSettingsEvent()),
        ),
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          final isDark = (state is SettingsLoaded) ? state.settings.darkMode : true;

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'MargNetra',
            themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
            theme: ThemeData(
              brightness: Brightness.light,
              fontFamily: 'Roboto',
              scaffoldBackgroundColor: const Color(0xFFF8FAFC),
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              fontFamily: 'Roboto',
              scaffoldBackgroundColor: const Color(0xFF010A12),
            ),
            initialRoute: AppPageRoute.splashPage,
            routes: AppPageRoute.mRoutes,
          );
        },
      ),
    );
  }
}
