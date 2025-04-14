import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../models/blocs/auth/auth_cubit.dart';

// ResetPasswordScreen allows the user to reset their password.
class ResetPasswordScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'reset_password',
          style: TextStyle(color: Colors.white),
        ).tr(), // Translated reset password title
        backgroundColor: const Color(0xFF001A6E),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'email'.tr(), // Translated email label
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.read<AuthCubit>().resetPassword(
                    _emailController.text); // Trigger password reset
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF001A6E), // Button color
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: const Text(
                'reset_password',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ).tr(), // Translated reset password button text
            ),
          ],
        ),
      ),
    );
  }
}
