class Gallery {
  late String galleryId;
  late String name;
  late DateTime dateStart;
  late DateTime dateEnd;
  late String location;
  late List<String> imageUrls;

  Gallery({
    required this.galleryId,
    required this.name,
    required this.dateStart,
    required this.dateEnd,
    required this.location,
    required this.imageUrls,
  });

  Gallery.parseJson(Map<String, dynamic> json) {
    galleryId = json['galleryId'];
    name = json['name'];
    dateStart = json['dateStart'];
    dateEnd = json['dateEnd'];
    location = json['location'];
    imageUrls = List<String>.from(json['imageUrls']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['dateStart'] = dateStart.toIso8601String();
    data['galleryId'] = galleryId;
    data['dateEnd'] = dateEnd;
    data['dateStart'] = dateEnd.toIso8601String();
    data['imageUrl'] = imageUrls;
    data['location'] = location;
    return data;
  }
}
