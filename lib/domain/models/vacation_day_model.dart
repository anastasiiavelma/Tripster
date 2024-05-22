import 'package:tripster/domain/models/note_model.dart';
import 'package:tripster/domain/models/place_model.dart';

class VacationDay {
  late String vacationDayId;
  late String name;
  late String vacationId;
  late DateTime createdAt;
  late String location;
  late final List<Place>? place;
  late List<Note> notes;
  late double budget;

  VacationDay(
      {required this.budget,
      required this.vacationId,
      required this.createdAt,
      required this.location,
      required this.name,
      required this.notes,
      required this.place,
      required this.vacationDayId});

  VacationDay.parseJson(Map<String, dynamic> json) {
    vacationDayId = json['vacationDayId'];
    name = json['name'];
    createdAt = json['createdAt'];
    location = json['location'];
    place = List<Place>.from(json['place']);
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
    place: [
      Place(
        id: '1',
        name: 'Эйфелева башня',
        latitude: 48.8584,
        longitude: 2.2945,
        description: 'Знаменитая башня в Париже.',
        rating: 5,
        openHours: ['9:00', '22:00'],
        imageUrl: 'https://example.com/eiffel.jpg',
      ),
    ],
    vacationId: '1',
    vacationDayId: '1',
    name: 'Первый день отпуска',
    createdAt: DateTime(2023, 5, 10),
    location: 'Париж, Франция',
    notes: [
      Note(
        noteId: '1',
        title: 'Завтрак в кафе Le Procope',
        description: 'Попробуйте круассаны и кофе.',
        userId: '1',
      ),
      Note(
        noteId: '3',
        title: 'Посещение Лувра',
        description: 'Увидеть Мону Лизу и другие шедевры.',
        userId: '1',
      ),
      Note(
        noteId: '3',
        title: 'Посещение Лувра',
        description: 'Увидеть Мону Лизу и другие шедевры.',
        userId: '1',
      ),
    ],
    budget: 300.0,
  ),
  VacationDay(
    place: [
      Place(
        id: '1',
        name: 'Эйфелева башня',
        latitude: 48.8584,
        longitude: 2.2945,
        description: 'Знаменитая башня в Париже.',
        rating: 5,
        openHours: ['9:00', '22:00'],
        imageUrl: 'https://example.com/eiffel.jpg',
      ),
    ],
    vacationId: '1',
    vacationDayId: '2',
    name: 'Второй день отпуска',
    createdAt: DateTime(2023, 5, 11),
    location: 'Париж, Франция',
    notes: [
      Note(
        noteId: '3',
        title: 'Прогулка по Елисейским полям',
        description: 'Насладитесь атмосферой Парижа.',
        userId: '1',
      ),
      Note(
        noteId: '4',
        title: 'Посещение Эйфелевой башни',
        description: 'Поднимитесь на вершину для великолепного вида на город.',
        userId: '2',
      ),
    ],
    budget: 400.0,
  ),
  VacationDay(
    place: [
      Place(
        id: '2',
        name: 'Эйфелева башня',
        latitude: 48.8584,
        longitude: 2.2945,
        description: 'Знаменитая башня в Париже.',
        rating: 5,
        openHours: ['9:00', '22:00'],
        imageUrl: 'https://example.com/eiffel.jpg',
      ),
    ],
    vacationId: '2',
    vacationDayId: '3',
    name: 'Третий день отпуска',
    createdAt: DateTime(2023, 5, 12),
    location: 'Рим, Италия',
    notes: [
      Note(
        noteId: '5',
        title: 'Посещение Колизея',
        description: 'Погрузитесь в историю Древнего Рима.',
        userId: '1',
      ),
      Note(
        noteId: '6',
        title: 'Прогулка по Ватикану',
        description: 'Осмотрите Сикстинскую капеллу и собор Святого Петра.',
        userId: '2',
      ),
    ],
    budget: 600.0,
  ),
];
