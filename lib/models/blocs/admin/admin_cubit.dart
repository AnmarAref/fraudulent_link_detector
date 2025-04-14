import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../approval_request_model.dart';
part 'admin_state.dart';

// AdminCubit is responsible for handling admin-related operations such as sending admin requests,
// fetching admin requests, approving or rejecting admin requests.
class AdminCubit extends Cubit<AdminState> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Initial state is AdminInitial
  AdminCubit() : super(AdminInitial());

  // Sends an admin request for the given email
  Future<void> sendAdminRequest(String email) async {
    emit(AdminLoading()); // Emit loading state
    try {
      final String? token =
          await _storage.read(key: 'token'); // Read token from secure storage

      if (token == null) {
        emit(AdminInitial()); // If no token, emit initial state
        return;
      }

      // Send a POST request to the server to send an admin request
      final response = await http.post(
        Uri.parse('https://url-checker-omega.vercel.app/api/users/sendRequest'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        emit(const AdminSuccess(
            message:
                'Approval request created successfully')); // Emit success state
      } else {
        emit(AdminInitial()); // If request fails, emit initial state
      }
    } catch (e) {
      emit(AdminInitial()); // If any error occurs, emit initial state
    }
  }

  // Fetches all admin requests
  Future<void> fetchAdminRequests() async {
    emit(AdminLoading()); // Emit loading state
    try {
      final String? token =
          await _storage.read(key: 'token'); // Read token from secure storage

      if (token == null) {
        emit(const AdminFailure(
            error: 'You are not logged in')); // If no token, emit failure state
        return;
      }

      // Send a GET request to fetch admin requests
      final response = await http.get(
        Uri.parse(
            'https://url-checker-omega.vercel.app/api/users/readRequests'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final dynamic decodedData =
            jsonDecode(response.body); // Decode the response

        if (decodedData is Map && decodedData.containsKey('requests')) {
          final List<dynamic> requestsData = decodedData['requests'];
          final requests = requestsData
              .map((request) => ApprovalRequestModel.fromJson(request))
              .toList();
          emit(AdminRequestsLoaded(
              requests: requests)); // Emit state with loaded requests
        } else {
          emit(const AdminFailure(
              error:
                  'Invalid data format')); // Emit failure state if data is invalid
        }
      } else {
        emit(AdminFailure(
            error:
                'Failed to fetch requests: ${response.body}')); // Emit failure state if request fails
      }
    } catch (e) {
      emit(AdminFailure(
          error: e.toString())); // Emit failure state if any error occurs
    }
  }

  // Approves an admin request for the given email
  Future<void> approveAdminRequest(String email) async {
    emit(AdminLoading()); // Emit loading state
    try {
      final String? token =
          await _storage.read(key: 'token'); // Read token from secure storage

      if (token == null) {
        emit(const AdminFailure(
            error: 'You are not logged in')); // If no token, emit failure state
        return;
      }

      // Send a POST request to approve the admin request
      final response = await http.post(
        Uri.parse(
            'https://url-checker-omega.vercel.app/api/users/permession_change'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'user_email': email,
        }),
      );

      if (response.statusCode == 200) {
        emit(const AdminSuccess(
            message:
                'User role changed to admin successfully')); // Emit success state
      } else {
        emit(AdminFailure(
            error:
                'Failed to change role: ${response.body}')); // Emit failure state if request fails
      }
    } catch (e) {
      emit(AdminFailure(
          error: e.toString())); // Emit failure state if any error occurs
    }
  }

  // Rejects an admin request for the given email
  Future<void> rejectAdminRequest(String email) async {
    emit(AdminLoading()); // Emit loading state
    try {
      final String? token =
          await _storage.read(key: 'token'); // Read token from secure storage

      if (token == null) {
        emit(const AdminFailure(
            error: 'You are not logged in')); // If no token, emit failure state
        return;
      }

      // Send a POST request to reject the admin request
      final response = await http.post(
        Uri.parse(
            'https://url-checker-omega.vercel.app/api/users/rejectRequest'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'user_email': email,
        }),
      );

      if (response.statusCode == 200) {
        emit(const AdminSuccess(
            message: 'Request rejected successfully')); // Emit success state
        fetchAdminRequests(); // Fetch updated admin requests
      } else {
        emit(AdminFailure(
            error:
                'Failed to reject request: ${response.body}')); // Emit failure state if request fails
      }
    } catch (e) {
      emit(AdminFailure(
          error: e.toString())); // Emit failure state if any error occurs
    }
  }
}
