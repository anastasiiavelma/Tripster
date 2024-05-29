import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tripster/presentation/cubits/place_cubit/place_state.dart';
import 'package:tripster/data/repository/place_repository.dart';
import 'package:tripster/domain/models/place_model.dart';

class PlaceCubit extends Cubit<PlaceState> {
  final PlaceRepository placeRepository;

  PlaceCubit(this.placeRepository) : super(PlaceInitial());

  Future<void> getPlaces(String? token) async {
    emit(PlaceLoading());
    try {
      final List<Place> places = await placeRepository.getPlaces(token);
      if (!isClosed) {
        emit(PlaceLoaded(places));
      }
    } catch (e) {
      if (!isClosed) {
        emit(PlaceError('Failed to load places: $e'));
      }
    }
  }

  Future<void> getRecommendedPlaces(String? token) async {
    emit(PlaceLoading());
    try {
      final List<Place> places = await placeRepository.getRecommendation(token);
      if (!isClosed) {
        emit(PlaceLoaded(places));
      }
    } catch (e) {
      if (!isClosed) {
        emit(PlaceError('Failed to load places: $e'));
      }
    }
  }
}
