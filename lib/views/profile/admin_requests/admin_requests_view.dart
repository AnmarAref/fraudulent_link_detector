import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../models/blocs/admin/admin_cubit.dart';

// AdminRequestsScreen displays a list of admin requests and allows the admin to approve or reject them.
class AdminRequestsScreen extends StatelessWidget {
  const AdminRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdminCubit()
        ..fetchAdminRequests(), // Fetch admin requests when the screen is loaded
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'admin_requests',
            style: TextStyle(color: Colors.white),
          ).tr(),
          backgroundColor: const Color(0xFF001A6E),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: BlocBuilder<AdminCubit, AdminState>(
          builder: (context, state) {
            if (state is AdminLoading) {
              return const Center(
                  child: CircularProgressIndicator()); // Show loading indicator
            } else if (state is AdminRequestsLoaded) {
              final requests = state.requests;
              return ListView.builder(
                itemCount: requests.length,
                itemBuilder: (context, index) {
                  final request = requests[index];
                  return ListTile(
                    title: Text(request.email),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.check, color: Colors.green),
                          onPressed: () {
                            context.read<AdminCubit>().approveAdminRequest(
                                request.email); // Approve the request
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () {
                            context.read<AdminCubit>().rejectAdminRequest(
                                request.email); // Reject the request
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            } else if (state is AdminFailure) {
              return Center(child: Text(state.error)); // Show error message
            }
            return Center(
                child: const Text('no_requests_found')
                    .tr()); // Show message if no requests are found
          },
        ),
      ),
    );
  }
}
