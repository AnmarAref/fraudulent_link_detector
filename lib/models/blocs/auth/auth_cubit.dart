import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_state.dart';

// AuthCubit is responsible for handling authentication-related operations such as login, signup, and logout.
class AuthCubit extends Cubit<AuthState> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Initial state is AuthInitial
  AuthCubit() : super(AuthInitial());

  // Handles the login process
  Future<void> login(String email, String password) async {
    emit(AuthLoading()); // Emit loading state
    try {
      // Send a POST request to the server to login
      final response = await http
          .post(
            Uri.parse('https://url-checker-omega.vercel.app/api/users/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'email': email,
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token']; // Extract token from response
        await _storage.write(
            key: 'token', value: token); // Store token in secure storage

        final decodedToken = JwtDecoder.decode(token); // Decode the token
        final role = decodedToken['role']; // Extract role from token

        final String message = data['msg'];
        final name =
            _extractNameFromMessage(message); // Extract name from message

        final userRole = role ?? 'user'; // Default role is 'user'
        await _storage.write(
            key: 'role', value: userRole); // Store role in secure storage

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
            'email', email); // Store email in shared preferences
        await prefs.setString(
            'role', userRole); // Store role in shared preferences
        await prefs.setString('name', name); // Store name in shared preferences

        emit(AuthSuccess(role: userRole)); // Emit success state with user role
      } else {
        final errorMessage = _handleLoginError(response); // Handle login error
        emit(AuthFailure(
            error: errorMessage)); // Emit failure state with error message
      }
    } on TimeoutException {
      emit(const AuthFailure(
          error:
              'Request timed out. Please try again.')); // Emit failure state if request times out
    } catch (e) {
      emit(const AuthFailure(
          error:
              'An error occurred. Please check your internet connection and try again.')); // Emit failure state if any error occurs
    }
  }

  // Extracts the name from the login message
  String _extractNameFromMessage(String message) {
    final RegExp regExp = RegExp(r'hi\s+(\w+)');
    final Match? match = regExp.firstMatch(message);
    if (match != null && match.groupCount >= 1) {
      return match.group(1)!;
    }
    return 'Unknown';
  }

  // Handles the signup process
  Future<void> signup(String name, String email, String password) async {
    emit(AuthLoading()); // Emit loading state
    try {
      // Send a POST request to the server to signup
      final response = await http
          .post(
            Uri.parse('https://url-checker-omega.vercel.app/api/users/signup'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'name': name,
              'email': email,
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 60));

      if (response.statusCode == 201 ||
          response.body.contains('"msg":"done"')) {
        emit(const AuthSuccess(
            role: 'user')); // Emit success state with default role 'user'
      } else {
        final errorMessage =
            _handleSignupError(response); // Handle signup error
        emit(AuthFailure(
            error: errorMessage)); // Emit failure state with error message
      }
    } catch (e) {
      emit(const AuthFailure(
          error:
              'An error occurred. Please check your internet connection and try again.')); // Emit failure state if any error occurs
    }
  }

  // Handles login errors
  String _handleLoginError(http.Response response) {
    final Map<String, dynamic> responseBody = jsonDecode(response.body);
    if (responseBody.containsKey('message')) {
      final String errorMessage =
          responseBody['message'].toString().toLowerCase();

      if (errorMessage.contains('invalid email or password') ||
          errorMessage.contains('user not found')) {
        return 'invalid_email_or_password'.tr();
      }
    }
    return 'invalid_email_or_password'.tr();
  }

  // Handles signup errors
  String _handleSignupError(http.Response response) {
    final Map<String, dynamic> responseBody = jsonDecode(response.body);

    if (responseBody.containsKey('msg')) {
      final String errorMessage = responseBody['msg'].toString().toLowerCase();

      if (errorMessage.contains('user already exists')) {
        return 'email_or_username_exists'.tr();
      }
    }

    return 'email_or_username_exists'.tr();
  }

  // Handles the password reset process
  Future<void> resetPassword(String email) async {
    emit(AuthLoading()); // Emit loading state
    try {
      // Send a POST request to reset the password
      final response = await http.post(
        Uri.parse('https://url-checker-omega.vercel.app/api/users/sendEmail'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        emit(const AuthSuccess(role: 'user')); // Emit success state
      } else {
        emit(AuthFailure(
            error:
                'Failed to send reset email: ${response.body}')); // Emit failure state if request fails
      }
    } catch (e) {
      emit(AuthFailure(
          error: e.toString())); // Emit failure state if any error occurs
    }
  }

  // Checks the login status of the user
  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final String? email =
        prefs.getString('email'); // Get email from shared preferences
    final String? role =
        prefs.getString('role'); // Get role from shared preferences

    if (email != null && role != null) {
      emit(AuthSuccess(role: role)); // Emit success state if user is logged in
    } else {
      emit(AuthInitial()); // Emit initial state if user is not logged in
    }
  }

  // Handles the logout process
  Future<void> logout() async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'token'); // Delete token from secure storage
    await storage.delete(key: 'role'); // Delete role from secure storage

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('email'); // Remove email from shared preferences
    await prefs.remove('role'); // Remove role from shared preferences
    await prefs.remove('name'); // Remove name from shared preferences

    emit(AuthInitial()); // Emit initial state after logout
  }
}
// import 'dart:async';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:jwt_decoder/jwt_decoder.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// part 'auth_state.dart';

// // AuthCubit is responsible for handling authentication-related operations such as login, signup, and logout.
// class AuthCubit extends Cubit<AuthState> {
//   final FlutterSecureStorage _storage = const FlutterSecureStorage();

//   // Initial state is AuthInitial
//   AuthCubit() : super(AuthInitial());

//   // Handles the login process
//   Future<void> login(String email, String password) async {
//     emit(AuthLoading()); // Emit loading state
//     try {
//       // Send a POST request to the server to login
//       final response = await http
//           .post(
//             Uri.parse('https://url-checker-omega.vercel.app/api/users/login'),
//             headers: {'Content-Type': 'application/json'},
//             body: jsonEncode({
//               'email': email,
//               'password': password,
//             }),
//           )
//           .timeout(const Duration(seconds: 30));

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         final token = data['token']; // Extract token from response
//         await _storage.write(
//             key: 'token', value: token); // Store token in secure storage

//         final decodedToken = JwtDecoder.decode(token); // Decode the token
//         final role = decodedToken['role']; // Extract role from token

//         final String message = data['msg'];
//         final name =
//             _extractNameFromMessage(message); // Extract name from message

//         final userRole = role ?? 'user'; // Default role is 'user'
//         await _storage.write(
//             key: 'role', value: userRole); // Store role in secure storage

//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setString(
//             'email', email); // Store email in shared preferences
//         await prefs.setString(
//             'role', userRole); // Store role in shared preferences
//         await prefs.setString('name', name); // Store name in shared preferences

//         emit(AuthSuccess(role: userRole, navigateToProxyInstructions: true));
//         // Emit success state with user role
//       } else {
//         final errorMessage = _handleLoginError(response); // Handle login error
//         emit(AuthFailure(
//             error: errorMessage)); // Emit failure state with error message
//       }
//     } on TimeoutException {
//       emit(const AuthFailure(
//           error:
//               'Request timed out. Please try again.')); // Emit failure state if request times out
//     } catch (e) {
//       emit(const AuthFailure(
//           error:
//               'An error occurred. Please check your internet connection and try again.')); // Emit failure state if any error occurs
//     }
//   }

//   // Extracts the name from the login message
//   String _extractNameFromMessage(String message) {
//     final RegExp regExp = RegExp(r'hi\s+(\w+)');
//     final Match? match = regExp.firstMatch(message);
//     if (match != null && match.groupCount >= 1) {
//       return match.group(1)!;
//     }
//     return 'Unknown';
//   }

//   // Handles the signup process
//   Future<void> signup(String name, String email, String password) async {
//     emit(AuthLoading()); // Emit loading state
//     try {
//       // Send a POST request to the server to signup
//       final response = await http
//           .post(
//             Uri.parse('https://url-checker-omega.vercel.app/api/users/signup'),
//             headers: {'Content-Type': 'application/json'},
//             body: jsonEncode({
//               'name': name,
//               'email': email,
//               'password': password,
//             }),
//           )
//           .timeout(const Duration(seconds: 60));

//       if (response.statusCode == 201 ||
//           response.body.contains('"msg":"done"')) {
//         emit(const AuthSuccess(
//             role: 'user')); // Emit success state with default role 'user'
//       } else {
//         final errorMessage =
//             _handleSignupError(response); // Handle signup error
//         emit(AuthFailure(
//             error: errorMessage)); // Emit failure state with error message
//       }
//     } catch (e) {
//       emit(const AuthFailure(
//           error:
//               'An error occurred. Please check your internet connection and try again.')); // Emit failure state if any error occurs
//     }
//   }

//   // Handles login errors
//   String _handleLoginError(http.Response response) {
//     final Map<String, dynamic> responseBody = jsonDecode(response.body);
//     if (responseBody.containsKey('message')) {
//       final String errorMessage =
//           responseBody['message'].toString().toLowerCase();

//       if (errorMessage.contains('invalid email or password') ||
//           errorMessage.contains('user not found')) {
//         return 'invalid_email_or_password'.tr();
//       }
//     }
//     return 'invalid_email_or_password'.tr();
//   }

//   // Handles signup errors
//   String _handleSignupError(http.Response response) {
//     final Map<String, dynamic> responseBody = jsonDecode(response.body);

//     if (responseBody.containsKey('msg')) {
//       final String errorMessage = responseBody['msg'].toString().toLowerCase();

//       if (errorMessage.contains('user already exists')) {
//         return 'email_or_username_exists'.tr();
//       }
//     }

//     return 'email_or_username_exists'.tr();
//   }

//   // Handles the password reset process
//   Future<void> resetPassword(String email) async {
//     emit(AuthLoading()); // Emit loading state
//     try {
//       // Send a POST request to reset the password
//       final response = await http.post(
//         Uri.parse('https://url-checker-omega.vercel.app/api/users/sendEmail'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'email': email,
//         }),
//       );

//       if (response.statusCode == 200) {
//         emit(const AuthSuccess(role: 'user')); // Emit success state
//       } else {
//         emit(AuthFailure(
//             error:
//                 'Failed to send reset email: ${response.body}')); // Emit failure state if request fails
//       }
//     } catch (e) {
//       emit(AuthFailure(
//           error: e.toString())); // Emit failure state if any error occurs
//     }
//   }

//   // Checks the login status of the user
//   Future<void> checkLoginStatus() async {
//     final prefs = await SharedPreferences.getInstance();
//     final String? email =
//         prefs.getString('email'); // Get email from shared preferences
//     final String? role =
//         prefs.getString('role'); // Get role from shared preferences

//     if (email != null && role != null) {
//       emit(AuthSuccess(role: role)); // Emit success state if user is logged in
//     } else {
//       emit(AuthInitial()); // Emit initial state if user is not logged in
//     }
//   }

//   // Handles the logout process
//   Future<void> logout() async {
//     const storage = FlutterSecureStorage();
//     await storage.delete(key: 'token'); // Delete token from secure storage
//     await storage.delete(key: 'role'); // Delete role from secure storage

//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('email'); // Remove email from shared preferences
//     await prefs.remove('role'); // Remove role from shared preferences
//     await prefs.remove('name'); // Remove name from shared preferences

//     emit(AuthInitial()); // Emit initial state after logout
//   }
// }
