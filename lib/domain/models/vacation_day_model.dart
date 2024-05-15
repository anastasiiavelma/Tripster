import 'package:tripster/domain/models/note_model.dart';
import 'package:tripster/domain/models/place_model.dart';
import 'package:tripster/domain/models/vacation_model.dart';

class VacationDay {
  late String vacationDayId;
  late String name;
  late String vacationId;
  late DateTime createdAt;
  late String location;
  late List<Place>? place;
  late List<Note> notes;
  late double budget;

  VacationDay(
      {required this.budget,
      required this.vacationId,
      required this.createdAt,
      required this.location,
      required this.name,
      required this.notes,
      this.place,
      required this.vacationDayId});

  VacationDay.parseJson(Map<String, dynamic> json) {
    vacationDayId = json['vacationDayId'];
    name = json['name'];
    createdAt = json['createdAt'];
    location = json['location'];
    place = json['place'];
    notes = List<Note>.from(json['notes']);
    ;
    budget = json['budget'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['vacationDayId'] = vacationDayId;
    data['location'] = location;
    data['createdAt'] = createdAt;
    data['place'] = place;
    data['notes'] = notes;
    data['budget'] = budget;
    return data;
  }
}

List<VacationDay> vacationDays = [
  VacationDay(
    vacationId: '1',
    vacationDayId: '1',
    name: 'First Day of Vacation',
    createdAt: DateTime.now(),
    location: 'Miami, Florida',
    // place: [places[1], places[2]],
    notes: [
      Note(
        noteId: '1',
        title: 'Breakfast at Ocean Drive',
        description: 'Try the Cuban coffee!',
        userId: '1',
      ),
      Note(
        noteId: '2',
        title: 'Visit Art Deco Historic District',
        description: 'Enjoy the vibrant colors and architecture.',
        userId: '2',
      ),
    ],
    budget: 500.0,
  ),
  VacationDay(
    vacationId: '1',
    vacationDayId: '2',
    name: 'Second Day of Vacation',
    createdAt: DateTime.now(),
    location: 'Los Angeles, California',
    // place: [places[1], places[2]],
    notes: [
      Note(
        noteId: '2',
        title: 'Visit Art Deco Historic District',
        description: 'Enjoy the vibrant colors and architecture.',
        userId: '2',
      ),
      Note(
        noteId: '2',
        title: 'Visit Art Deco Historic District',
        description: 'Enjoy the vibrant colors and architecture.',
        userId: '2',
      ),
    ],
    budget: 700.0,
  ),
];
