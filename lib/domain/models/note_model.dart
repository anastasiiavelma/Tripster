class Note {
  late String noteId;
  late String vacationDayId;
  late String title;
  late String description;

  Note({
    required this.noteId,
    required this.vacationDayId,
    required this.title,
    required this.description,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      noteId: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      vacationDayId: json['vacationDayId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['vacationDayId'] = vacationDayId;
    data['noteId'] = noteId;
    data['title'] = title;
    data['description'] = description;
    return data;
  }
}
