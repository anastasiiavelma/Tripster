import 'dart:convert';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';

class ImageSharedPrefs {
  static const String IMAGE_LIST_KEY = 'IMAGE_LIST_KEY';

  static Future<bool> saveImagesToPrefs(List<Uint8List> images) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> encodedImages =
        images.map((image) => base64String(image)).toList();
    return await prefs.setStringList(IMAGE_LIST_KEY, encodedImages);
  }

  static Future<List<Uint8List>?> loadImagesFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? encodedImages = prefs.getStringList(IMAGE_LIST_KEY);
    if (encodedImages != null) {
      return encodedImages
          .map((encodedImage) => base64Decode(encodedImage))
          .toList();
    } else {
      return null;
    }
  }

  static String base64String(Uint8List data) {
    return base64Encode(data);
  }

  static Uint8List imageFromBase64String(String base64String) {
    return base64Decode(base64String);
  }
}
