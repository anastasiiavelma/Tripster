import 'package:tripster/domain/models/vacation_model.dart';

class Gallery {
  late String galleryId;
  late String name;
  late DateTime dateStart;
  late DateTime dateEnd;
  late String location;
  late List<String>? imageUrls;
  late Vacation vacation;

  Gallery({
    required this.galleryId,
    required this.name,
    required this.dateStart,
    required this.dateEnd,
    required this.location,
    this.imageUrls,
    required this.vacation,
  });

  Gallery.parseJson(Map<String, dynamic> json)
      : galleryId = json['galleryId'],
        name = json['name'],
        dateStart = DateTime.parse(json['dateStart']),
        dateEnd = DateTime.parse(json['dateEnd']),
        location = json['location'],
        imageUrls = List<String>.from(json['imageUrls']),
        vacation = Vacation.parseJson(json['vacation']);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['galleryId'] = galleryId;
    data['name'] = name;
    data['dateStart'] = dateStart.toIso8601String();
    data['dateEnd'] = dateEnd.toIso8601String();
    data['location'] = location;
    data['imageUrls'] = imageUrls;
    data['vacation'] = vacation.toJson();
    return data;
  }
}

List<Gallery> galleries = [
  Gallery(
    galleryId: '101',
    name: 'Europe Trip Gallery',
    dateStart: DateTime(2024, 6, 15),
    dateEnd: DateTime(2024, 7, 5),
    location: 'Europe',
    imageUrls: [
      'https://images.unsplash.com/photo-1714837003223-5144b6e082cb?q=80&w=2071&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      'https://images.unsplash.com/photo-1714837003223-5144b6e082cb?q=80&w=2071&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      'https://images.unsplash.com/photo-1714837003223-5144b6e082cb?q=80&w=2071&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      'https://images.unsplash.com/photo-1714837003223-5144b6e082cb?q=80&w=2071&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      'https://images.unsplash.com/photo-1714837003223-5144b6e082cb?q=80&w=2071&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ],
    vacation: vacations[0],
  ),
  Gallery(
    galleryId: '102',
    name: 'Aspen Ski Trip Gallery',
    dateStart: DateTime(2024, 12, 20),
    dateEnd: DateTime(2024, 12, 27),
    location: 'Aspen, Colorado',
    imageUrls: [
      'https://images.unsplash.com/photo-1714837003223-5144b6e082cb?q=80&w=2071&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      'https://images.unsplash.com/photo-1714837003223-5144b6e082cb?q=80&w=2071&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ],
    vacation: vacations[1],
  ),
  Gallery(
    galleryId: '102',
    name: 'Aspen Ski Trip Gallery',
    dateStart: DateTime(2024, 12, 20),
    dateEnd: DateTime(2024, 12, 27),
    location: 'Aspen, Colorado',
    imageUrls: [],
    vacation: vacations[1],
  ),
];
