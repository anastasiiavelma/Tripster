import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthRepository {
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<String> loginUser(String email, String password) async {
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
      final token = jsonData['token'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', token);
      return token;
    } else {
      throw Exception('Failed to login ${response.statusCode}');
    }
  }

  Future<String> registerUser(
      String name, String email, String password) async {
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
      final responseData = jsonDecode(response.body);
      final token = responseData['token'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', token);
      return token;
    } else if (response.statusCode == 400) {
      final responseData = jsonDecode(response.body);
      final errorMessage = responseData['message'];
      throw Exception(errorMessage);
    } else {
      throw Exception('Failed to register: ${response.statusCode}');
    }
  }
}
