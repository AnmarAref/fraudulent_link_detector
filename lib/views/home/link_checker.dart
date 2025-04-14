import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/blocs/link/link_cubit.dart';

// LinkCheckerSection allows the user to check the safety of a link.
class LinkCheckerSection extends StatelessWidget {
  final TextEditingController linkController;

  const LinkCheckerSection({required this.linkController, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LinkCubit, LinkState>(
      listener: (context, state) {
        if (state is LinkNotFound) {
          _showLinkNotFoundDialog(
              context, state.url); // Show dialog if link is not found
        } else if (state is LinkFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)), // Show error message
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: linkController,
                decoration: InputDecoration(
                  hintText: 'enter_link_here'.tr(), // Translated hint text
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(
                      color: Color(0xFF001A6E),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(
                      color: Color(0xFF001A6E),
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.paste),
                    onPressed: () async {
                      final clipboardData = await Clipboard.getData(
                          'text/plain'); // Get clipboard data
                      if (clipboardData != null && clipboardData.text != null) {
                        linkController.text =
                            clipboardData.text!; // Paste clipboard text
                      }
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton.icon(
              onPressed: () {
                final url = linkController.text;
                if (url.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: const Text('please_enter_url')
                            .tr()), // Show error if URL is empty
                  );
                } else {
                  context
                      .read<LinkCubit>()
                      .checkLink(url); // Trigger link check
                }
              },
              label: const Text(
                'check',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ).tr(), // Translated check button text
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF001A6E), // Button color
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Shows a dialog when the link is not found.
  void _showLinkNotFoundDialog(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('link_not_found').tr(), // Translated dialog title
          content: const Text('link_not_found_message')
              .tr(), // Translated dialog message
          actions: [
            TextButton(
              onPressed: () async {
                final Uri uri = Uri.parse(url);
                await launchUrl(uri); // Open the link in a browser
                Navigator.pop(context); // Close the dialog
              },
              child:
                  const Text('open_link').tr(), // Translated open link button
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child:
                  const Text('scan_again').tr(), // Translated scan again button
            ),
          ],
        );
      },
    );
  }
}
