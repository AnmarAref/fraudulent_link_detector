import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'report_state.dart';

// ReportCubit is responsible for handling report-related operations such as reporting a result and fetching reports.
class ReportCubit extends Cubit<ReportState> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Initial state is ReportInitial
  ReportCubit() : super(ReportInitial());

  // Reports the result of a link check
  Future<void> reportResult(String url, String status) async {
    emit(ReportLoading()); // Emit loading state
    try {
      final String? token =
          await _storage.read(key: 'token'); // Read token from secure storage

      if (token == null) {
        emit(const ReportFailure(
            error: 'You are not logged in')); // If no token, emit failure state
        return;
      }

      final encodedUrl = Uri.encodeComponent(url);
      final apiUrl =
          'https://url-checker-omega.vercel.app/api/users/report_result/$encodedUrl/$status';

      for (int i = 0; i < 3; i++) {
        try {
          // Send a POST request to report the result
          final response = await http.post(
            Uri.parse(apiUrl),
            headers: {
              'Authorization': 'Bearer $token',
            },
          ).timeout(const Duration(seconds: 30));

          if (response.statusCode == 200) {
            emit(ReportSuccess()); // Emit success state
            return;
          } else if (response.statusCode == 308) {
            final redirectUrl = response.headers['location'];
            if (redirectUrl != null) {
              final fullRedirectUrl =
                  Uri.parse('https://url-checker-omega.vercel.app$redirectUrl');

              // Send a POST request to the redirected URL
              final redirectedResponse = await http.post(
                fullRedirectUrl,
                headers: {
                  'Authorization': 'Bearer $token',
                },
              ).timeout(const Duration(seconds: 30));
              if (redirectedResponse.statusCode == 200) {
                emit(ReportSuccess()); // Emit success state
                return;
              } else {
                emit(ReportFailure(
                    error:
                        'Failed to report result: ${redirectedResponse.body}')); // Emit failure state if request fails
                return;
              }
            } else {
              emit(const ReportFailure(
                  error:
                      'Failed to report result: Redirect URL not found')); // Emit failure state if redirect URL is not found
              return;
            }
          } else {
            emit(ReportFailure(
                error:
                    'Failed to report result: ${response.body}')); // Emit failure state if request fails
            return;
          }
        } catch (e) {
          if (i == 2) {
            emit(ReportFailure(
                error:
                    'Failed to report result: $e')); // Emit failure state if any error occurs
          }
          await Future.delayed(const Duration(seconds: 5));
        }
      }
    } catch (e) {
      emit(ReportFailure(
          error: e.toString())); // Emit failure state if any error occurs
    }
  }

  // Fetches all reports
  Future<void> fetchReports() async {
    emit(ReportLoading()); // Emit loading state
    try {
      final String? token =
          await _storage.read(key: 'token'); // Read token from secure storage

      if (token == null) {
        emit(const ReportFailure(
            error: 'You are not logged in')); // If no token, emit failure state
        return;
      }

      // Send a GET request to fetch reports
      final response = await http.get(
        Uri.parse(
            'https://url-checker-omega.vercel.app/api/users/getWrongReports'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data.containsKey('falseReports')) {
          emit(ReportsLoaded(
              reports: data['falseReports'])); // Emit state with loaded reports
        } else {
          emit(const ReportFailure(
              error:
                  'Invalid data format')); // Emit failure state if data is invalid
        }
      } else {
        emit(ReportFailure(
            error:
                'Failed to fetch reports: ${response.body}')); // Emit failure state if request fails
      }
    } catch (e) {
      emit(ReportFailure(
          error: e.toString())); // Emit failure state if any error occurs
    }
  }

  // Edits the category of a link
  Future<void> editCategory(String url, String newCategory) async {
    emit(ReportLoading()); // Emit loading state
    try {
      final String? token =
          await _storage.read(key: 'token'); // Read token from secure storage

      if (token == null) {
        emit(const ReportFailure(
            error: 'You are not logged in')); // If no token, emit failure state
        return;
      }

      // Send a PUT request to edit the category
      final response = await http.put(
        Uri.parse(
            'https://url-checker-omega.vercel.app/api/users/editCategory'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'url': url,
          'category': newCategory,
        }),
      );

      if (response.statusCode == 200) {
        emit(ReportSuccess()); // Emit success state
        fetchReports(); // Fetch updated reports
      } else {
        emit(ReportFailure(
            error:
                'Failed to update category: ${response.body}')); // Emit failure state if request fails
      }
    } catch (e) {
      emit(ReportFailure(
          error: e.toString())); // Emit failure state if any error occurs
    }
  }
}
