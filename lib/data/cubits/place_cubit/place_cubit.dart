import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:tripster/data/cubits/place_cubit/place_state.dart';
import 'package:tripster/domain/models/place_model.dart';

class PlaceCubit extends Cubit<PlaceState> {
  PlaceCubit() : super(PlaceInitial());

  Future<void> getPlaces() async {
    emit(PlaceLoading());

    try {
      final response = await http
          .get(Uri.parse('https://tripser-backend.onrender.com/places'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        final List<dynamic> placesData = jsonData['placeCollection']['items'];
        final List<Place>? places =
            placesData.map((json) => Place.fromJson(json)).toList();

        emit(PlaceLoaded(places!));
        close();
      } else {
        throw Exception('Failed to load places');
      }
    } catch (e) {
      emit(PlaceError('Failed to load places: $e'));
    }
    return super.close();
  }
}
