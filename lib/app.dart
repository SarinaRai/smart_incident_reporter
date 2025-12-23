import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:beamer/beamer.dart';
import 'package:smart_incident_reporter/features/auth/view/login_screen.dart';
import 'package:smart_incident_reporter/features/auth/view/register_screen.dart';
import 'core/constants/app_strings.dart';
import 'features/incidents/view/incident_list_screen.dart';
import 'features/incidents/view/incident_form_screen.dart';
import 'features/incidents/view/incident_detail_screen.dart';
import 'features/profile/view/profile_screen.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routerDelegate = BeamerDelegate(
      initialPath: '/login',
      locationBuilder: RoutesLocationBuilder(
        routes: {
          '/login': (context, state, data) => const LoginScreen(),
          '/register': (context, state, data) => const RegisterScreen(),
          '/incidents': (context, state, data) => const IncidentListScreen(),
          '/create': (context, state, data) => const IncidentFormScreen(),
          '/incidents/:id': (context, state, data) =>
              const IncidentDetailScreen(),
          '/profile': (context, state, data) => const ProfileScreen(),
        },
      ).call,
    );

    final routeParser = BeamerParser();

    return MaterialApp.router(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      routerDelegate: routerDelegate,
      routeInformationParser: routeParser,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
