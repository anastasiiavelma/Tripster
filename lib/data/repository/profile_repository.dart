import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tripster/domain/models/user_model.dart';

class ProfileRepository {
  Future<ProfileUser?> getUserProfile(String? token) async {
    final response = await http.get(
      Uri.parse('https://tripser-backend.onrender.com/profile'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', token!);

      final jsonData = json.decode(response.body);
      return ProfileUser.fromJson(jsonData);
    } else if (response.statusCode == 401) {
      return null;
    } else {
      throw Exception('Failed to load user: ${response.statusCode}');
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}
