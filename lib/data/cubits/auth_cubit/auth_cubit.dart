import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tripster/data/cubits/auth_cubit/auth_state.dart';
import 'package:http/http.dart' as http;

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial()) {
    checkUserLoggedIn();
  }

  Future<void> checkUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
      emit(AuthAuthenticated(token));
    }
  }

  Future<void> loginUser(String email, String password) async {
    emit(AuthLoading());
    try {
      final response = await http.post(
        Uri.parse('https://tripser-backend.onrender.com/login'),
        body: json.encode({
          'email': email ?? '',
          'password': password ?? '',
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        print(response.body);

        final token = jsonData['token'];
        print(token);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', token);
        emit(AuthAuthenticated(token));
      } else {
        throw Exception('Failed to login ${response.statusCode}');
      }
    } catch (e) {
      emit(AuthError('$e'));
      print(e);
    }
  }

  Future<void> registerUser(String name, String email, String password) async {
    emit(AuthLoading());
    try {
      final response = await http.post(
        Uri.parse('https://tripser-backend.onrender.com/register'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        emit(AuthRegistered());
      } else if (response.statusCode == 400) {
        final responseData = jsonDecode(response.body);
        print(responseData);
        final errorMessage = responseData['message'];
        emit(AuthError(errorMessage));
      } else {
        emit(AuthError('Failed to register: ${response.statusCode}'));
      }
    } catch (e) {
      emit(AuthError('Failed to register: $e'));
    }
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
