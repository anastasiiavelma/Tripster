class Vacation {
  late String vacationId;
  late String name;
  late String location;
  late DateTime dateStart;
  late DateTime dateEnd;
  late String fullBudget;

  Vacation({
    required this.vacationId,
    required this.name,
    required this.dateStart,
    required this.dateEnd,
    required this.location,
    required this.fullBudget,
  });

  // Vacation.parseJson(Map<String, dynamic> json) {
  //   vacationId = json['vacationId'];
  //   name = json['name'];
  //   dateStart = json['dateStart'];
  //   dateEnd = json['dateEnd'];
  //   location = json['location'];
  //   fullBudget = json['fullBudget'];
  // }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = <String, dynamic>{};
  //   data['name'] = name;
  //   data['dateStart'] = dateStart.toIso8601String();
  //   data['vacationId'] = vacationId;
  //   data['dateEnd'] = dateEnd;
  //   data['dateStart'] = dateEnd.toIso8601String();
  //   data['location'] = location;
  //   return data;
  // }
}

List<Vacation> vacations = [
  Vacation(
    vacationId: '1',
    name: 'Summer Trip to Europe',
    dateStart: DateTime(2024, 6, 15),
    dateEnd: DateTime(2024, 7, 5),
    location: 'Europe',
    fullBudget: '5000',
  ),
  Vacation(
    vacationId: '2',
    name: 'Winter Ski Trip',
    dateStart: DateTime(2024, 12, 20),
    dateEnd: DateTime(2024, 12, 27),
    location: 'Aspen, Colorado',
    fullBudget: '8000',
  ),
];
