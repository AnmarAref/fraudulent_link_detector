import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../models/blocs/auth/auth_cubit.dart';

// SignUpScreen allows the user to create a new account.
class SignUpScreen extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(), // Initialize AuthCubit
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.person_add,
                      size: 100, color: Color(0xFF001A6E)), // Person add icon
                  const SizedBox(height: 20),
                  const Text(
                    'signup',
                    style: TextStyle(
                      color: Color(0xFF001A6E),
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ).tr(), // Translated signup text
                  const SizedBox(height: 20),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'name'.tr(), // Translated name label
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'email'.tr(), // Translated email label
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.email),
                    ),
                    keyboardType: TextInputType
                        .emailAddress, // Set keyboard type to email
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'password'.tr(), // Translated password label
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.lock),
                    ),
                    obscureText: true, // Hide password text
                  ),
                  const SizedBox(height: 30),
                  BlocConsumer<AuthCubit, AuthState>(
                    listener: (context, state) {
                      if (state is AuthSuccess) {
                        Navigator.pushReplacementNamed(
                            context, '/home'); // Navigate to home screen
                      } else if (state is AuthFailure) {
                        _showErrorDialog(context,
                            state.error); // Show error dialog if signup fails
                      }
                    },
                    builder: (context, state) {
                      if (state is AuthLoading) {
                        return const CircularProgressIndicator(); // Show loading indicator
                      }
                      return ElevatedButton(
                        onPressed: () {
                          final name = _nameController.text.trim();
                          final email = _emailController.text.trim();
                          final password = _passwordController.text.trim();

                          if (name.isEmpty ||
                              email.isEmpty ||
                              password.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: const Text('all_fields_required')
                                      .tr()), // Show error if fields are empty
                            );
                          } else {
                            context.read<AuthCubit>().signup(
                                name, email, password); // Trigger signup
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFF001A6E), // Button color
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                        ),
                        child: const Text(
                          'signup',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ).tr(), // Translated signup button text
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, '/login'); // Navigate to login screen
                    },
                    child: const Text(
                      'already_have_account',
                      style: TextStyle(color: Color(0xFF001A6E)),
                    ).tr(), // Translated already have account text
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Shows an error dialog with the given error message.
  void _showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('error').tr(), // Translated error title
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('cancel').tr(), // Translated cancel button
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('retry').tr(), // Translated retry button
            ),
          ],
        );
      },
    );
  }
}
