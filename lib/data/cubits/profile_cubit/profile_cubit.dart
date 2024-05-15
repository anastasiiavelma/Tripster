import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:tripster/data/cubits/place_cubit/place_state.dart';
import 'package:tripster/data/cubits/profile_cubit/profile_state.dart';
import 'package:tripster/domain/models/place_model.dart';
import 'package:tripster/domain/models/user_model.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  Future<void> getUserProfile(String? token) async {
    emit(ProfileLoading());
    await Future.delayed(const Duration(seconds: 1));
    try {
      final response = await http.get(
        Uri.parse('https://tripser-backend.onrender.com/profile'),
        headers: {'Authorization': 'Bearer $token'},
      );
      print(token);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print(jsonData);
        final userProfile = ProfileUser.fromJson(jsonData);
        emit(ProfileLoaded(userProfile));
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Invalid token ${response.statusCode}');
      } else {
        throw Exception('Failed to load user ${response.statusCode}');
      }
    } catch (e) {
      emit(ProfileError('Failed to load user: $e'));
    }
  }
}
