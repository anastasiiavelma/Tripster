import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tripster/data/repository/gallery_repository.dart';
import 'package:tripster/domain/models/gallery_model.dart';
import 'package:tripster/presentation/cubits/gallery_cubit/gallery_state.dart';

class GalleryCubit extends Cubit<GalleryState> {
  final GalleryRepository galleryRepository;

  GalleryCubit(this.galleryRepository) : super(GalleryInitial());

  Future<void> getUserGallery(String? token) async {
    emit(GalleryLoading());
    try {
      final List<Gallery>? galleryUser =
          await galleryRepository.getUserGalleries(token);
      emit(GalleryLoaded(galleryUser as List<Gallery>));
    } catch (e) {
      emit(GalleryError('Failed to load user: $e'));
    }
  }

  Future<void> createGallery({
    required List<File>? image,
    required String vacationId,
    required String? token,
  }) async {
    try {
      final gallery = await galleryRepository.createGallery(
        token: token,
        images: image!,
        vacationId: vacationId,
      );
      emit(GalleryLoading());

      getUserGallery(token);
    } catch (e) {
      if (!isClosed) {
        emit(GalleryError(e.toString()));
      }
    }
  }
}
