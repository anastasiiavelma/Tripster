import 'dart:io';

abstract class LandmarkState {}

class LandmarkInitial extends LandmarkState {}

class LandmarkLoading extends LandmarkState {}

class LandmarkLoaded extends LandmarkState {
  final String landmarkName;
  final File? selectedImage;

  LandmarkLoaded(this.landmarkName, this.selectedImage);
}

class LandmarkError extends LandmarkState {}
