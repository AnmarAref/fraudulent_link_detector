import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../models/blocs/link/link_cubit.dart';

// AddLinkScreen allows the user to add a new link with a category.
class AddLinkScreen extends StatefulWidget {
  const AddLinkScreen({super.key});

  @override
  _AddLinkScreenState createState() => _AddLinkScreenState();
}

class _AddLinkScreenState extends State<AddLinkScreen> {
  final _urlController = TextEditingController();
  String _selectedCategory = 'safe';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'add_link',
          style: TextStyle(color: Colors.white),
        ).tr(),
        backgroundColor: const Color(0xFF001A6E),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: 'url'.tr(),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              items: ['safe', 'suspicious', 'dangerous']
                  .map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!; // Update the selected category
                });
              },
              decoration: InputDecoration(
                labelText: 'category'.tr(),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addLink, // Add the link when the button is pressed
              child: const Text('add_link').tr(),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Adds a new link with the selected category.
  Future<void> _addLink() async {
    final url = _urlController.text;
    if (url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('please_enter_valid_url').tr()),
      );
      return;
    }

    context.read<LinkCubit>().addLink(url, _selectedCategory).then((success) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('link_added_successfully').tr()),
        );
        _urlController.clear(); // Clear the input field after adding the link
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('failed_to_add_link').tr()),
        );
      }
    });
  }
}
