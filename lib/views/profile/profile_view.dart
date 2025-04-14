import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/blocs/auth/auth_cubit.dart';

// ProfileScreen displays the user's profile and allows them to perform actions like logging out or requesting admin privileges.
class ProfileScreen extends StatelessWidget {
  final String role;
  final String email;

  const ProfileScreen({required this.role, required this.email, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'profile',
          style: TextStyle(color: Colors.white),
        ).tr(),
        backgroundColor: const Color(0xFF001A6E),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Icon(
                Icons.shield,
                size: 100,
                color: Color(0xFF001A6E),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${'role'.tr()}: ${role == 'admin' ? 'admin'.tr() : 'user'.tr()}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    if (role == 'admin')
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'admin_features',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ).tr(),
                          const SizedBox(height: 10),
                          _buildFeatureTile(
                            icon: Icons.link,
                            title: 'add_link',
                            onTap: () {
                              Navigator.pushNamed(context,
                                  '/addLink'); // Navigate to add link screen
                            },
                          ),
                          _buildFeatureTile(
                            icon: Icons.request_page,
                            title: 'admin_requests',
                            onTap: () {
                              Navigator.pushNamed(context,
                                  '/adminRequests'); // Navigate to admin requests screen
                            },
                          ),
                          _buildFeatureTile(
                            icon: Icons.report,
                            title: 'view_reports',
                            onTap: () {
                              Navigator.pushNamed(context,
                                  '/viewReports'); // Navigate to view reports screen
                            },
                          ),
                        ],
                      ),
                    if (role != 'admin')
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'user_features',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ).tr(),
                          const SizedBox(height: 10),
                          _buildFeatureTile(
                            icon: Icons.person_add,
                            title: 'request_admin_role',
                            onTap: () {
                              Navigator.pushNamed(context,
                                  '/requestAdmin'); // Navigate to request admin screen
                            },
                          ),
                        ],
                      ),
                    _buildFeatureTile(
                      icon: Icons.language,
                      title: 'language',
                      onTap: () {
                        Navigator.pushNamed(context,
                            '/language'); // Navigate to language selection screen
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  const storage = FlutterSecureStorage();
                  await storage.delete(
                      key: 'token'); // Delete token from secure storage
                  await storage.delete(
                      key: 'role'); // Delete role from secure storage

                  final prefs = await SharedPreferences.getInstance();
                  await prefs
                      .remove('email'); // Remove email from shared preferences
                  await prefs
                      .remove('role'); // Remove role from shared preferences
                  await prefs
                      .remove('name'); // Remove name from shared preferences

                  context.read<AuthCubit>().logout(); // Logout the user

                  Navigator.pushReplacementNamed(
                      context, '/login'); // Navigate to login screen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF001A6E),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  'logout',
                  style: TextStyle(color: Colors.white),
                ).tr(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Builds a feature tile with an icon, title, and onTap action.
  Widget _buildFeatureTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF001A6E)),
        title: Text(title).tr(),
        onTap: onTap,
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}
