import 'package:tripster/domain/models/note_model.dart';

class VacationDay {
  late String vacationDayId;
  late String name;
  late String vacationId;
  late DateTime date;
  final List<String>? cities;
  final List<String>? places;
  late List<String>? notes;
  late double? budget;

  VacationDay(
      {required this.budget,
      required this.vacationId,
      required this.date,
      required this.name,
      required this.notes,
      required this.places,
      required this.cities,
      required this.vacationDayId});

  factory VacationDay.fromJson(Map<String, dynamic> json) {
    return VacationDay(
      vacationDayId: json['_id'] ?? '',
      name: json['name'] ?? '',
      vacationId: json['vacation'] ?? '',
      date: DateTime.parse(json['date']),
      cities: json['cities'] != null ? List<String>.from(json['cities']) : [],
      places: json['places'] != null ? List<String>.from(json['places']) : [],
      notes: json['notes'] != null ? List<String>.from(json['notes']) : [],
      budget:
          json['budget'] != null ? (json['budget'] as num).toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['vacationDayId'] = vacationDayId;
    data['name'] = name;
    data['vacation'] = vacationId;
    data['date'] = date.toIso8601String();
    data['cities'] = cities;
    data['places'] = places;
    data['notes'] = notes;
    data['budget'] = budget;
    return data;
  }
}
