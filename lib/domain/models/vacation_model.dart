import 'package:tripster/domain/models/gallery_model.dart';
import 'package:tripster/domain/models/vacation_day_model.dart';

class Vacation {
  final String vacationId;
  final String name;
  final String countryName;
  final double? countryLat;
  final double? countryLon;
  final List<String>? cities;
  final List<String>? places;
  final List<String>? days;
  final double? fullBudget;
  final String? gallery;
  final DateTime startDate;
  final DateTime endDate;

  Vacation({
    required this.vacationId,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.countryName,
    required this.cities,
    required this.places,
    required this.days,
    required this.countryLat,
    required this.countryLon,
    required this.fullBudget,
    required this.gallery,
  });

  factory Vacation.fromJson(Map<String, dynamic> json) {
    return Vacation(
      vacationId: json['_id'] ?? '',
      name: json['name'] ?? '',
      countryName: json['country']['name'] ?? '',
      countryLat: (json['country']['location']['lat'] as num).toDouble(),
      countryLon: (json['country']['location']['lon'] as num).toDouble(),
      cities: json['cities'] != null ? List<String>.from(json['cities']) : [],
      places: json['places'] != null ? List<String>.from(json['places']) : [],
      days: json['days'] != null ? List<String>.from(json['days']) : [],
      fullBudget: json['fullBudget'] != null
          ? (json['fullBudget'] as num).toDouble()
          : null,
      gallery: json['gallery'] ?? '',
      startDate: DateTime.parse(json['dateDiapazone']['startDate']),
      endDate: DateTime.parse(json['dateDiapazone']['endDate']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['startDate'] = startDate.toIso8601String();
    data['_id'] = vacationId;
    data['endDate'] = endDate.toIso8601String();
    return data;
  }
}
