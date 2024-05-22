import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tripster/domain/models/place_model.dart';

class PlaceRepository {
  Future<List<Place>> getPlaces() async {
    final response = await http
        .get(Uri.parse('https://tripser-backend.onrender.com/places'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      final List<dynamic> placesData = jsonData['placeCollection']['items'];
      final List<Place> places =
          placesData.map((json) => Place.fromJson(json)).toList();

      return places;
    } else {
      throw Exception('Failed to load places: ${response.statusCode}');
    }
  }
}
