import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../models/blocs/report/report_cubit.dart';

// ViewReportsScreen displays a list of reports and allows the admin to edit the category of a link.
class ViewReportsScreen extends StatefulWidget {
  const ViewReportsScreen({super.key});

  @override
  _ViewReportsScreenState createState() => _ViewReportsScreenState();
}

class _ViewReportsScreenState extends State<ViewReportsScreen> {
  @override
  void initState() {
    super.initState();
    context
        .read<ReportCubit>()
        .fetchReports(); // Fetch reports when the screen is loaded
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'view_reports',
          style: TextStyle(color: Colors.white),
        ).tr(),
        backgroundColor: const Color(0xFF001A6E),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocBuilder<ReportCubit, ReportState>(
        builder: (context, state) {
          if (state is ReportLoading) {
            return const Center(
                child: CircularProgressIndicator()); // Show loading indicator
          } else if (state is ReportsLoaded) {
            final reports = state.reports;
            return ListView.builder(
              itemCount: reports.length,
              itemBuilder: (context, index) {
                final report = reports[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(report['url'] ?? 'no_url').tr(),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('category: ${report['category']}'),
                        Text('true_votes: ${report['number_of_trueVotes']}'),
                        Text('wrong_votes: ${report['number_of_wrongVotes']}'),
                        Text(
                            'first_submission: ${report['date_of_firstSubmession']}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _editCategory(context,
                            report['url']); // Edit the category of the link
                      },
                    ),
                  ),
                );
              },
            );
          } else if (state is ReportFailure) {
            return Center(child: Text(state.error)); // Show error message
          }
          return Center(
              child: const Text('no_reports_available')
                  .tr()); // Show message if no reports are available
        },
      ),
    );
  }

  // Edits the category of a link.
  Future<void> _editCategory(BuildContext context, String url) async {
    String? newCategory = await showDialog<String>(
      context: context,
      builder: (context) {
        String? selectedCategory = 'safe';
        return AlertDialog(
          title: const Text('edit_category').tr(),
          content: DropdownButtonFormField<String>(
            value: selectedCategory,
            items: ['safe', 'suspicious', 'dangerous']
                .map((category) => DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    ))
                .toList(),
            onChanged: (value) {
              selectedCategory = value; // Update the selected category
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                    context, selectedCategory); // Save the selected category
              },
              child: const Text('save').tr(),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cancel the edit
              },
              child: const Text('cancel').tr(),
            ),
          ],
        );
      },
    );

    if (newCategory != null) {
      context
          .read<ReportCubit>()
          .editCategory(url, newCategory); // Update the category
    }
  }
}
