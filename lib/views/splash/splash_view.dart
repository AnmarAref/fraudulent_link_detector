import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

// SplashScreen is the initial screen that shows a splash 
//animation and navigates to the appropriate screen based on the user's login status.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen(); // Navigate to the next screen after a delay
  }

  void _navigateToNextScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = await const FlutterSecureStorage()
        .read(key: 'token'); // Read token from secure storage
    final String? role =
        prefs.getString('role'); // Read role from shared preferences
    final String? language =
        prefs.getString('language'); // Read language from shared preferences

    await Future.delayed(const Duration(seconds: 3)); // Wait for 3 seconds

    if (!mounted) return;

    if (language == null) {
      Navigator.pushReplacementNamed(context,
          '/language'); // Navigate to language selection screen if no language is set
    } else if (token != null && role != null) {
      Navigator.pushReplacementNamed(
        context,
        '/home',
        arguments: role, // Navigate to home screen if the user is logged in
      );
    } else {
      Navigator.pushReplacementNamed(context,
          '/login'); // Navigate to login screen if the user is not logged in
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001A6E),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shield, size: 100, color: Colors.white),
            const SizedBox(height: 20),
            Text(
              'link_detector'.tr(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
