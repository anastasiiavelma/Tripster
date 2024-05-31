import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tripster/presentation/cubits/landmark_cubit/landmark_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tripster/data/repository/landmark_repository.dart';

class LandmarkCubit extends Cubit<LandmarkState> {
  final LandmarkRepository _landmarkRepository;

  LandmarkCubit(this._landmarkRepository) : super(LandmarkInitial());

  Future<void> getImageAndRecognize(ImageSource source) async {
    emit(LandmarkLoading());
    try {
      final pickedFile = await _landmarkRepository.getImage(source);
      if (pickedFile == null) {
        emit(LandmarkError("No image selected."));
        return;
      }

      emit(LandmarkLoading());
      final landmark = await _landmarkRepository.getLandmark(pickedFile!);
      emit(LandmarkLoaded(landmark.description, landmark.image));
    } catch (e) {
      emit(LandmarkError('Something went wrong'));
      print('Error: $e');
    }
  }
}
