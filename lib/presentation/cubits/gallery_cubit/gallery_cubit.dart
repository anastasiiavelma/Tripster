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
      emit(GalleryError('Failed: $e'));
    }
  }

  Future<void> createGallery({
    required List<File>? image,
    required String vacationId,
    required String? token,
  }) async {
    try {
      emit(GalleryLoading());
      await galleryRepository.createGallery(
        token: token,
        images: image!,
        vacationId: vacationId,
      );

      emit(GalleryLoading());
      getUserGallery(token);
    } catch (e) {
      if (!isClosed) {
        print(e);
        emit(GalleryError(e.toString()));
      }
    }
  }

  Future<void> addImageToGallery({
    required List<File>? image,
    required String vacationId,
    required String? token,
    required String galleryId,
  }) async {
    try {
      emit(GalleryLoading());
      await galleryRepository.addImageToGallery(
        token: token,
        images: image!,
        vacationId: vacationId,
        galleryId: galleryId,
      );
      emit(GalleryLoading());

      getUserGallery(token);
    } catch (e) {
      if (!isClosed) {
        emit(GalleryError(e.toString()));
      }
    }
  }

  Future<void> deleteGallery({
    required String galleryId,
    required String vacationId,
    required String? token,
  }) async {
    try {
      await galleryRepository.deleteGallery(
        galleryId: galleryId,
        vacationId: vacationId,
        token: token,
      );

      emit(GalleryLoading());
      getUserGallery(token);
    } catch (e) {
      if (!isClosed) {
        emit(GalleryError(e.toString()));
      }
    }
  }

  Future<void> deleteImageFromGallery({
    required String image,
    required String? token,
    required String galleryId,
  }) async {
    try {
      await galleryRepository.updateGallery(
        token: token!,
        removeImageUrl: image,
        galleryId: galleryId,
      );
      emit(GalleryLoading());

      getUserGallery(token);
    } catch (e) {
      if (!isClosed) {
        emit(GalleryError(e.toString()));
      }
    }
  }

  Future<void> loadGallery({required String galleryId}) async {
    try {
      final gallery = await galleryRepository.getGalleryById(galleryId);
      emit(GalleryLoading());
      emit(GalleryPhotosLoaded(gallery!));
      loadGallery(galleryId: galleryId);
      if (!isClosed) {
        emit(GalleryPhotosLoaded(gallery));
      }
    } catch (e) {
      if (!isClosed) {
        emit(GalleryError(e.toString()));
      }
      print('Error loading gallery: $e');
    }
  }
}
