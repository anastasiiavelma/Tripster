import 'package:http/http.dart' as http;
import 'dart:convert';

class Place {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String description;
  final int rating;
  final List<String> openHours;
  final String imageUrl;

  Place({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.rating,
    required this.openHours,
    required this.imageUrl,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['sys'] != null ? json['sys']['id'] : '',
      name: json['name'] ?? '',
      latitude: json['location'] != null ? json['location']['lat'] : 0.0,
      longitude: json['location'] != null ? json['location']['lon'] : 0.0,
      description: json['description'] ?? '',
      rating: json['rating'] ?? 0,
      openHours:
          json['openHours'] != null ? List<String>.from(json['openHours']) : [],
      imageUrl: json['mediaCollection'] != null &&
              json['mediaCollection']['items'].isNotEmpty
          ? json['mediaCollection']['items'][0]['url']
          : '',
    );
  }
}
