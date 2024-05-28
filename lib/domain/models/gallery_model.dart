import 'dart:io';

import 'package:tripster/domain/models/vacation_model.dart';

class Gallery {
  late String galleryId;
  late List<File>? images;
  late List<String>? imageUrls;
  late String vacationId;

  Gallery({
    required this.galleryId,
    required this.imageUrls,
    required this.images,
    required this.vacationId,
  });

  factory Gallery.fromJson(Map<String, dynamic> json) {
    List<File>? images;
    if (json['images'] != null) {
      images = File(json['images']) as List<File>?;
    }
    return Gallery(
      galleryId: json['galleryId'] ?? '',
      images: images,
      imageUrls: List<String>.from(json['imageURLs'] ?? ''),
      vacationId: json['vacationId'] ?? '',
    );
  }

  Map<String, dynamic> fromJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['vacationId'] = vacationId;
    data['galleryId'] = galleryId;
    data['images'] = images;
    data['imageURLs'] = imageUrls;
    return data;
  }
}
