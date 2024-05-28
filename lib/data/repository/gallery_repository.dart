import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tripster/domain/models/gallery_model.dart';
import 'package:tripster/domain/models/user_model.dart';
import 'package:tripster/domain/models/vacation_model.dart';

class GalleryRepository {
  Future<List<Gallery>?> getUserGalleries(String? token) async {
    final response = await http.get(
      Uri.parse('https://tripser-backend.onrender.com/user-galleries'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', token!);

      final jsonData = json.decode(response.body) as List;
      return jsonData
          .map((galleryJson) => Gallery.fromJson(galleryJson))
          .toList();
    } else if (response.statusCode == 401) {
      return null;
    } else {
      throw Exception('Failed to load gallery list: ${response.statusCode}');
    }
  }

  Future<List<Vacation>> getUserVacations(String? token) async {
    final response = await http.get(
      Uri.parse('https://tripser-backend.onrender.com/vacations'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return (jsonData as List<dynamic>)
          .map((item) => Vacation.fromJson(item))
          .toList();
    } else if (response.statusCode == 401) {
      return [];
    } else {
      throw Exception('Failed to load vacations: ${response.statusCode}');
    }
  }

  Future<Gallery> createGallery({
    required List<File> images,
    required String vacationId,
    required String? token,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://tripser-backend.onrender.com/vacations/gallery'),
      );

      request.headers.addAll({
        'Authorization': 'Bearer $token',
      });

      request.fields['vacationId'] = vacationId;

      for (var image in images) {
        request.files
            .add(await http.MultipartFile.fromPath('image', image.path));
      }

      var response = await http.Response.fromStream(await request.send());

      final jsonData = json.decode(response.body);
      return Gallery.fromJson(jsonData);
    } catch (e) {
      throw Exception('Failed to create gallery: ${e}');
    }
  }

  Future<ProfileUser?> updateGallery(
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
}
