import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../models/blocs/auth/auth_cubit.dart';

// LoginScreen allows the user to log in to the application.
class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit()
        ..checkLoginStatus(), // Initialize AuthCubit and check login status
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock,
                      size: 100, color: Color(0xFF001A6E)), // Lock icon
                  const SizedBox(height: 20),
                  const Text(
                    'login',
                    style: TextStyle(
                      color: Color(0xFF001A6E),
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ).tr(), // Translated login text
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
                          context,
                          '/home',
                          arguments: state
                              .role, // Navigate to home screen with user role
                        );
                      } else if (state is AuthFailure) {
                        _showErrorDialog(context,
                            state.error); // Show error dialog if login fails
                      }
                    },
                    builder: (context, state) {
                      if (state is AuthLoading) {
                        return const CircularProgressIndicator(); // Show loading indicator
                      }
                      return ElevatedButton(
                        onPressed: () {
                          final email = _emailController.text.trim();
                          final password = _passwordController.text.trim();

                          if (email.isEmpty || password.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: const Text('all_fields_required')
                                      .tr()), // Show error if fields are empty
                            );
                          } else {
                            context
                                .read<AuthCubit>()
                                .login(email, password); // Trigger login
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFF001A6E), // Button color
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                        ),
                        child: const Text(
                          'login',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ).tr(), // Translated login button text
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context,
                          '/resetPassword'); // Navigate to reset password screen
                    },
                    child: const Text(
                      'forgot_password',
                      style: TextStyle(color: Color(0xFF001A6E)),
                    ).tr(), // Translated forgot password text
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, '/signup'); // Navigate to signup screen
                    },
                    child: const Text(
                      "don't_have_account",
                      style: TextStyle(color: Color(0xFF001A6E)),
                    ).tr(), // Translated don't have account text
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
                Navigator.pop(context);
                _emailController.text = ""; // Clear email field
                _passwordController.text = ""; // Clear password field
              },
              child: const Text('retry').tr(), // Translated retry button
            ),
          ],
        );
      },
    );
  }
}
