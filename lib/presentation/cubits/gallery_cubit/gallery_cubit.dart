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
      final Gallery? galleryUser =
          await galleryRepository.getUserGallery(token);
      emit(GalleryLoaded(galleryUser as List<Gallery>));
    } catch (e) {
      emit(GalleryError('Failed to load user: $e'));
    }
  }
}
