import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

// LanguageSelectionScreen allows the user to select the application language.
class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF001A6E),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'choose_language'.tr(),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),
              LanguageCard(
                languageName: 'arabic'.tr(),
                icon: Icons.language,
                color: Colors.green.shade400,
                onPressed: () async {
                  context
                      .setLocale(const Locale('ar')); // Set language to Arabic
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString(
                      'language', 'ar'); // Save language preference
                  Navigator.pushReplacementNamed(
                      context, '/login'); // Navigate to login screen
                },
              ),
              const SizedBox(height: 20),
              LanguageCard(
                languageName: 'english'.tr(),
                icon: Icons.translate,
                color: Colors.orange.shade400,
                onPressed: () async {
                  context
                      .setLocale(const Locale('en')); // Set language to English
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString(
                      'language', 'en'); // Save language preference
                  Navigator.pushReplacementNamed(
                      context, '/login'); // Navigate to login screen
                },
              ),
              const SizedBox(height: 40),
              Text(
                'language_selection_hint'.tr(),
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// LanguageCard is a custom widget for displaying a language option.
class LanguageCard extends StatelessWidget {
  final String languageName;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const LanguageCard({
    super.key,
    required this.languageName,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(width: 20),
              Text(
                languageName,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Icon(Icons.arrow_forward_ios, color: Colors.grey.shade600),
            ],
          ),
        ),
      ),
    );
  }
}
