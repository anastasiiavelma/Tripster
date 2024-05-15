class Note {
  late String noteId;
  late String userId;
  late String title;
  late String description;

  Note({
    required this.noteId,
    required this.userId,
    required this.title,
    required this.description,
  });

  Note.parseJson(Map<String, dynamic> json) {
    userId = json['userId'];
    noteId = json['noteId'];
    title = json['title'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['noteId'] = noteId;
    data['title'] = title;
    data['description'] = description;
    return data;
  }
}
