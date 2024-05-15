import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tripster/data/cubits/landmark_cubit/landmark_state.dart';

class LandmarkCubit extends Cubit<LandmarkState> {
  final picker = ImagePicker();

  LandmarkCubit() : super(LandmarkInitial());

  Future<void> getImageAndRecognize(ImageSource source) async {
    emit(LandmarkLoading());
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
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
          emit(LandmarkLoaded(landmark['description'], File(pickedFile.path)));
        } else {
          emit(LandmarkLoaded('Landmark not found', null));
        }
      } else {
        emit(LandmarkError());
        print('Request failed with status: ${response.statusCode}');
      }
    }
  }
}
