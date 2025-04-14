import 'package:flutter/material.dart';
import 'package:fraudulent_link_detector/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'report_dialog.dart';
import 'package:easy_localization/easy_localization.dart';

// ResultBottomSheet displays the result of a link check.
class ResultBottomSheet extends StatelessWidget {

  final String category;
  final String url;
  final TextEditingController controller;

  const ResultBottomSheet({
    required this.category,
    required this.url,
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (category == 'NotFound')
            Text(
              'link_not_found'.tr(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          if (category != 'NotFound')
            Text(
              '${'scan_result'.tr()}: ${translateCategory(category)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          const SizedBox(height: 10),
          if (category == 'NotFound')
            Text(
              'link_not_found_message'.tr(),
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          if (category != 'NotFound')
            Text(
              category.toLowerCase() == 'safe'
                  ? 'link_appears_safe'.tr()
                  : 'link_may_be_unsafe'.tr(),
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (category != 'NotFound')
                ElevatedButton(
                  onPressed: () async {
                    await _launchURL(url); // Open the link in a browser
                  },
                  child: const Text('open_link').tr(),
                ),
              ElevatedButton(
                onPressed: () {
                  controller.clear(); // Clear the link input field
                  Navigator.pop(context); // Close the bottom sheet
                },
                child: const Text('scan_again').tr(),
              ),
              if (category != 'NotFound')
                ElevatedButton(
                  onPressed: () {
                    _showReportDialog(context, url); // Show the report dialog
                  },
                  child: const Text('report').tr(),
                ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'help_us_improve',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ).tr(),
        ],
      ),
    );
  }

  // Shows the report dialog for the given URL.
  void _showReportDialog(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (context) {
        return ReportDialog(
          url: url,
          category: category,
        );
      },
    );
  }

  // Launches the given URL in a browser.
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    await launchUrl(uri);
  }
}
