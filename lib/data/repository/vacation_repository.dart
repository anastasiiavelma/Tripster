import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tripster/domain/models/note_model.dart';
import 'package:tripster/domain/models/vacation_day_model.dart';
import 'package:tripster/domain/models/vacation_model.dart';

class VacationRepository {
  Future<List<Vacation>?> getUserVacations(String? token) async {
    final response = await http.get(
      Uri.parse('https://tripser-backend.onrender.com/vacations'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', token!);

      final jsonData = json.decode(response.body) as List;
      return jsonData
          .map((vacationJson) => Vacation.fromJson(vacationJson))
          .toList();
    } else if (response.statusCode == 401) {
      return null;
    } else {
      throw Exception('Failed to load user: ${response.statusCode}');
    }
  }

  Future<Vacation?> getVacation(String vacationId, String? token) async {
    final response = await http.get(
      Uri.parse('https://tripser-backend.onrender.com/vacations/$vacationId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return Vacation.fromJson(jsonData);
    } else {
      throw Exception('Failed to load vacation: ${response.statusCode}');
    }
  }

  Future<List<VacationDay>?> getUserVacationDays(
      String vacationId, String? token) async {
    final response = await http.get(
      Uri.parse('https://tripser-backend.onrender.com/vacationDays'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', token!);

      final jsonData = json.decode(response.body) as List;
      return jsonData
          .map((vacationJson) => VacationDay.fromJson(vacationJson))
          .toList();
    } else if (response.statusCode == 401) {
      return null;
    } else {
      throw Exception('Failed to load user: ${response.statusCode}');
    }
  }

  Future<VacationDay?> getVacationDay(
      String vacationDayId, String? token) async {
    final response = await http.get(
      Uri.parse(
          'https://tripser-backend.onrender.com/vacationDays/$vacationDayId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return VacationDay.fromJson(jsonData);
    } else {
      throw Exception('Failed to load vacation day: ${response.statusCode}');
    }
  }

  Future<Note> createNote({
    required String title,
    required String description,
    required String vacationDayId,
    required String? token,
  }) async {
    final response = await http.post(
      Uri.parse('https://tripser-backend.onrender.com/notes/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'title': title,
        'description': description,
        'vacationDayId': vacationDayId,
      }),
    );

    if (response.statusCode == 201) {
      final jsonData = json.decode(response.body);
      return Note.fromJson(jsonData);
    } else {
      throw Exception('Failed to create note: ${response.statusCode}');
    }
  }

  Future<void> deleteNote({
    required String noteId,
    required String vacationDayId,
    required String? token,
  }) async {
    final response = await http.delete(
      Uri.parse('https://tripster-backend.onrender.com/notes/$noteId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete note: ${response.statusCode}');
    }
  }
}
