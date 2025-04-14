import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

// ThankYouDialog shows a thank you message after the user reports a result.
class ThankYouDialog extends StatelessWidget {
  const ThankYouDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('thank_you').tr(),
      content: const Text('appreciate_feedback').tr(),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close the dialog
          },
          child: const Text('ok').tr(),
        ),
      ],
    );
  }
}
