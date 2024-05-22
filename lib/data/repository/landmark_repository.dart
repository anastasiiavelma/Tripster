import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class LandmarkRepository {
  final picker = ImagePicker();

  Future<XFile?> getImage(ImageSource source) async {
    return picker.pickImage(source: source);
  }

  Future<Landmark> getLandmark(XFile pickedFile) async {
    final imageBytes = await pickedFile.readAsBytes();
    final response = await http.post(
      Uri.parse(
          'https://vision.googleapis.com/v1/images:annotate?key=AIzaSyAyquNtFHwBbECH15Qekzr4cAvA2fFpP_s'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'requests': [
          {
            'image': {'content': base64Encode(imageBytes)},
            'features': [
              {'type': 'LANDMARK_DETECTION'}
            ]
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final landmarkAnnotations =
          responseData['responses']?[0]?['landmarkAnnotations'];

      if (landmarkAnnotations != null && landmarkAnnotations.isNotEmpty) {
        final landmark = landmarkAnnotations[0];
        return Landmark(
          description: landmark['description'],
          image: File(pickedFile.path),
        );
      } else {
        return Landmark(description: 'Landmark not found', image: null);
      }
    } else {
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  }
}

class Landmark {
  final String description;
  final File? image;

  Landmark({required this.description, required this.image});
}
