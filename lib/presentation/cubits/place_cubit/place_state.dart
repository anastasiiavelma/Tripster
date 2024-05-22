import 'package:tripster/domain/models/place_model.dart';

abstract class PlaceState {}

class PlaceInitial extends PlaceState {}

class PlaceLoading extends PlaceState {}

class PlaceLoaded extends PlaceState {
  final List<Place> places;

  PlaceLoaded(this.places);
}

class PlaceError extends PlaceState {
  final String error;

  PlaceError(this.error);
}
