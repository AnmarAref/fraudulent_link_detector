import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../models/blocs/admin/admin_cubit.dart';

// RequestAdminScreen allows the user to request admin privileges.
class RequestAdminScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  RequestAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdminCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'request_admin_role',
            style: TextStyle(color: Colors.white),
          ).tr(),
          backgroundColor: const Color(0xFF001A6E),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                'request_to_become_admin',
                style: TextStyle(fontSize: 18),
              ).tr(),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'email'.tr(),
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 20),
              BlocConsumer<AdminCubit, AdminState>(
                listener: (context, state) {
                  if (state is AdminSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(state.message)), // Show success message
                    );
                  } else if (state is AdminFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(state.error)), // Show error message
                    );
                  }
                },
                builder: (context, state) {
                  if (state is AdminLoading) {
                    return const CircularProgressIndicator(); // Show loading indicator
                  }
                  return ElevatedButton(
                    onPressed: () {
                      final email = _emailController.text.trim();
                      if (email.isNotEmpty) {
                        context
                            .read<AdminCubit>()
                            .sendAdminRequest(email); // Send admin request
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: const Text('please_enter_email')
                                  .tr()), // Show error if email is empty
                        );
                      }
                    },
                    child: const Text('send_request').tr(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
