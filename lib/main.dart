import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:margnetra_super_app/core/app_page_route/app_page_route.dart';
import 'package:margnetra_super_app/core/app_services/local_storage/shared_pref_service.dart';
import 'package:margnetra_super_app/pages/auth_page/data/repositories/auth_repository.dart';
import 'package:margnetra_super_app/pages/auth_page/logic/blocs/auth_bloc/auth_bloc.dart';

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
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
            authRepository: AuthRepository(),
          )..add(CheckAuthStatusEvent()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MargNetra',
        theme: ThemeData(
          brightness: Brightness.dark,
          fontFamily: 'Roboto',
          scaffoldBackgroundColor: const Color(0xFF010A12),
        ),
        initialRoute: AppPageRoute.splashPage,
        routes: AppPageRoute.mRoutes,
      ),
    );
  }
}
