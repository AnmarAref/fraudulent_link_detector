import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'link_state.dart';

// LinkCubit is responsible for handling link-related operations such as checking a link and adding a link.
class LinkCubit extends Cubit<LinkState> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Initial state is LinkInitial
  LinkCubit() : super(LinkInitial());
//  Checks the safety of a given URL
  Future<void> checkLink(String url) async {
    emit(LinkLoading()); // Emit loading state
    try {
      final String? token =
          await _storage.read(key: 'token'); // Read token from secure storage

      if (token == null) {
        emit(const LinkFailure(
            error: 'You are not logged in')); // If no token, emit failure state
        return;
      }

      // Send a POST request to check the link
      final response = await http.post(
        Uri.parse('https://url-checker-omega.vercel.app/api/users/link_check'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'url': url,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        emit(LinkSuccess(
          url: url,
          category: data['category'],
          trueVotes: data['number_of_people_say_its_true'],
          wrongVotes: data['number_of_people_say_its_false'],
          submissionDate: data['submession_date'],
        )); // Emit success state with link details
      } else if (response.statusCode == 404) {
        emit(LinkNotFound(
            url: url)); // Emit not found state if link is not found
      } else {
        emit(const LinkFailure(
            error: 'Link check failed')); // Emit failure state if request fails
      }
    } catch (e) {
      emit(const LinkFailure(
          error:
              'حدث خطأ أثناء فحص الرابط')); // Emit failure state if any error occurs
    }
  }

  // Adds a new link with a given category
  Future<bool> addLink(String url, String category) async {
    emit(LinkLoading()); // Emit loading state
    try {
      final String? token =
          await _storage.read(key: 'token'); // Read token from secure storage

      if (token == null) {
        emit(const LinkFailure(
            error: 'You are not logged in')); // If no token, emit failure state
        return false;
      }

      // Send a POST request to add the link
      final response = await http.post(
        Uri.parse('https://url-checker-omega.vercel.app/api/users/add_link'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'url': url,
          'category': category,
        }),
      );

      if (response.statusCode == 200) {
        emit(LinkSuccessadd(
            url: url,
            category: category)); // Emit success state with link details
        return true;
      } else {
        emit(LinkFailure(
            error:
                'Failed to add link: ${response.body}')); // Emit failure state if request fails
        return false;
      }
    } catch (e) {
      emit(LinkFailure(
          error: e.toString())); // Emit failure state if any error occurs
      return false;
    }
  }
}
