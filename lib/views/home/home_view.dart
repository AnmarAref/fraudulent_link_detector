import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/blocs/link/link_cubit.dart';
import 'link_checker.dart';
import 'feature_section.dart';
import 'result_bottom_sheet.dart';
import 'package:easy_localization/easy_localization.dart';

// HomeScreen is the main screen of the application.
class HomeScreen extends StatefulWidget {
  final String role;

  const HomeScreen({required this.role, super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _linkController = TextEditingController();

  @override
  void dispose() {
    _linkController.dispose(); // Dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'home',
          style: TextStyle(color: Colors.white),
        ).tr(), // Translated home title
        backgroundColor: const Color(0xFF001A6E),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 5,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, size: 26),
            onPressed: () {
              Navigator.pushNamed(context, '/profile',
                  arguments: widget.role); // Navigate to profile screen
            },
          ),
        ],
      ),
      body: BlocListener<LinkCubit, LinkState>(
        listener: (context, state) {
          if (state is LinkSuccess) {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return ResultBottomSheet(
                  category: state.category,
                  url: state.url,
                  controller: _linkController,
                ); // Show result bottom sheet
              },
            );
          } else if (state is LinkFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)), // Show error message
            );
          }
        },
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
                vertical: screenHeight * 0.02,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.security,
                    size: 100,
                    color: Color(0xFF001A6E), // Security icon
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  const Text(
                    'stay_safe_online',
                    style: TextStyle(
                      color: Color(0xFF001A6E),
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ).tr(), // Translated stay safe online text
                  SizedBox(height: screenHeight * 0.03),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: const Text(
                      'got_a_link',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                      ),
                    ).tr(), // Translated got a link text
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  LinkCheckerSection(
                      linkController: _linkController), // Link checker section
                  SizedBox(height: screenHeight * 0.04),
                  const FeatureSection(), // Feature section
                  SizedBox(height: screenHeight * 0.08),
                  const Text(
                    'your_safety_priority',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ).tr(), // Translated your safety priority text
                  SizedBox(height: screenHeight * 0.02),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
