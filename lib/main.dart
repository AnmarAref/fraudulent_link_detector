import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'models/blocs/admin/admin_cubit.dart';
import 'models/blocs/auth/auth_cubit.dart';
import 'models/blocs/link/link_cubit.dart';
import 'models/blocs/report/report_cubit.dart';
import 'views/app_localizations/language_selection.dart';
import 'views/home/home_view.dart';
import 'views/authentication/login_view.dart';
import 'views/authentication/signup_view.dart';
import 'views/splash/splash_view.dart';
import 'views/profile/profile_view.dart';
import 'views/profile/admin_requests/request_admin_view.dart';
import 'views/profile/admin_requests/admin_requests_view.dart';
import 'views/profile/add_link/add_link_view.dart';
import 'views/profile/reports_view.dart';
import 'views/authentication/reset_password_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const MyApp(),
    ),
  );
}

// MyApp is the root widget of the application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LinkCubit>(
          create: (context) => LinkCubit(),
        ),
        BlocProvider<ReportCubit>(
          create: (context) => ReportCubit(),
        ),
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(),
        ),
        BlocProvider<AdminCubit>(
          create: (context) => AdminCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Link Detector',
        theme: ThemeData(
          primaryColor: const Color(0xFF001A6E),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/language': (context) => const LanguageSelectionScreen(),
          '/login': (context) => LoginScreen(),
          '/signup': (context) => SignUpScreen(),
          '/home': (context) => HomeScreen(
                role: ModalRoute.of(context)!.settings.arguments as String,
              ),
          '/profile': (context) => ProfileScreen(
                role: ModalRoute.of(context)!.settings.arguments as String,
                email: '',
              ),
          '/requestAdmin': (context) => RequestAdminScreen(),
          '/adminRequests': (context) => const AdminRequestsScreen(),
          '/addLink': (context) => const AddLinkScreen(),
          '/viewReports': (context) => const ViewReportsScreen(),
          '/resetPassword': (context) => ResetPasswordScreen(),
        },
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
      ),
    );
  }
}