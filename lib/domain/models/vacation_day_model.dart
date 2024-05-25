import 'package:tripster/domain/models/note_model.dart';

class VacationDay {
  late String vacationDayId;
  late String name;
  late String vacationId;
  late DateTime date;
  late String? places;
  late String? cities;
  late List<Note>? notes;
  late double budget;

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
      vacationDayId: json['_id'],
      name: json['name'],
      vacationId: json['vacationId'],
      date: DateTime.parse(json['date']),
      places: json['places'],
      cities: json['cities'],
      notes: (json['notes'] as List)
          .map((noteJson) => Note.fromJson(noteJson))
          .toList(),
      budget: json['budget'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['vacationDayId'] = vacationDayId;
    data['date'] = date;
    data['places'] = places;
    data['notes'] = notes;
    data['budget'] = budget;
    return data;
  }
}
