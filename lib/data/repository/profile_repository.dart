import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
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

  Future<ProfileUser?> updateProfile(
      String token, Map<String, dynamic> updateData) async {
    final Uri url = Uri.parse('https://tripser-backend.onrender.com/profile');
    var request = http.MultipartRequest('PUT', url);
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['name'] = updateData['name'];

    if (updateData['avatar'] != null && updateData['avatar'] is File) {
      var avatar = updateData['avatar'] as File;
      var stream = http.ByteStream(avatar.openRead());
      var length = await avatar.length();
      var multipartFile = http.MultipartFile('avatar', stream, length,
          filename: avatar.path.split('/').last);
      request.files.add(multipartFile);
    }

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await http.Response.fromStream(response);
      final decodedData = json.decode(responseData.body);
      return ProfileUser.fromJson(decodedData);
    } else if (response.statusCode == 401) {
      return null;
    } else {
      throw Exception('Failed to update profile: ${response.statusCode}');
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}
