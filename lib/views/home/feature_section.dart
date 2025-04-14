import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

// FeatureSection displays the features of the application.
class FeatureSection extends StatelessWidget {
  const FeatureSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildFeatureItem(
          icon: Icons.verified_user,
          title: 'secure'.tr(), // Translated secure title
          subtitle: 'ensure_safety'.tr(), // Translated ensure safety subtitle
        ),
        _buildFeatureItem(
          icon: Icons.speed,
          title: 'fast'.tr(), // Translated fast title
          subtitle:
              'instant_results'.tr(), // Translated instant results subtitle
        ),
      ],
    );
  }

  // Builds a feature item with an icon, title, and subtitle.
  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Flexible(
      child: Column(
        children: [
          Icon(
            icon,
            size: 40,
            color: const Color(0xFF001A6E), // Icon color
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF001A6E),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            subtitle,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
