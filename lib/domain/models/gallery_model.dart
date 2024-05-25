import 'dart:io';

import 'package:tripster/domain/models/vacation_model.dart';

class Gallery {
  late String galleryId;
  late List<File>? imageUrls;
  late Vacation vacation;

  Gallery({
    required this.galleryId,
    this.imageUrls,
    required this.vacation,
  });

  Gallery.parseJson(Map<String, dynamic> json)
      : galleryId = json['galleryId'],
        imageUrls = List<File>.from(json['imageUrls']),
        vacation = Vacation.fromJson(json['vacation']);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['galleryId'] = galleryId;
    data['imageUrls'] = imageUrls;
    data['vacation'] = vacation.toJson();
    return data;
  }
}
