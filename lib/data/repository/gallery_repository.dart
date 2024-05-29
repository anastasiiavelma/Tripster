import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tripster/domain/models/gallery_model.dart';

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
      print(jsonData);
      return jsonData
          .map((galleryJson) => Gallery.fromJson(galleryJson))
          .toList();
    } else {
      throw Exception('Failed to load gallery list: ${response.statusCode}');
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

  Future<Gallery> addImageToGallery({
    required List<File> images,
    required String vacationId,
    required String galleryId,
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
      request.fields['galleryId'] = galleryId;
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

  Future<Gallery?> getGalleryById(String galleryId) async {
    final response = await http.get(
      Uri.parse(
          'https://tripser-backend.onrender.com/vacations/gallery/$galleryId'),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return Gallery.fromJson(jsonData);
    } else {
      throw Exception('Failed to load gallery: ${response.statusCode}');
    }
  }

  Future<void> deleteGallery({
    required String galleryId,
    required String vacationId,
    required String? token,
  }) async {
    try {
      await http.delete(
        Uri.parse(
            'https://tripser-backend.onrender.com/vacations/gallery/$galleryId'),
        headers: {'Authorization': 'Bearer $token'},
      );
    } on Exception catch (e) {
      throw Exception('Failed to delete gallery: $e');
    }
  }

  Future<bool> updateGallery({
    required String token,
    required String? removeImageUrl,
    required String galleryId,
  }) async {
    final url = Uri.parse(
        'https://tripser-backend.onrender.com/vacations/gallery/$galleryId');

    final body = json.encode({
      'removeImageURLs': removeImageUrl,
    });

    try {
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Error updating gallery: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error updating gallery: $e');
      return false;
    }
  }
}
