import 'package:tripster/domain/models/gallery_model.dart';

abstract class GalleryState {}

class GalleryInitial extends GalleryState {}

class GalleryLoading extends GalleryState {}

class GalleryLoaded extends GalleryState {
  final List<Gallery> galleries;
  GalleryLoaded(this.galleries);
}

class GalleryError extends GalleryState {
  final String error;
  GalleryError(this.error);
}
