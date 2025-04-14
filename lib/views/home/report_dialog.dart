import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/blocs/report/report_cubit.dart';
import 'thank_you_dialog.dart';
import 'package:easy_localization/easy_localization.dart';

// ReportDialog allows the user to report the result of a link check.
class ReportDialog extends StatelessWidget {
  final String url;
  final String category;

  const ReportDialog({
    required this.url,
    required this.category,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('report_result').tr(),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('url: $url'),
          Text('category: $category'),
          const Text('is_result_correct').tr(),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            context
                .read<ReportCubit>()
                .reportResult(url, 'true'); // Report the result as correct
            Navigator.pop(context);
            _showThankYouDialog(context); // Show thank you dialog
          },
          child: const Text('yes').tr(),
        ),
        TextButton(
          onPressed: () {
            context
                .read<ReportCubit>()
                .reportResult(url, 'false'); // Report the result as incorrect
            Navigator.pop(context);
            _showThankYouDialog(context); // Show thank you dialog
          },
          child: const Text('no').tr(),
        ),
      ],
    );
  }

  // Shows a thank you dialog after reporting the result.
  void _showThankYouDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const ThankYouDialog();
      },
    );
  }
}
