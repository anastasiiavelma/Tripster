import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tripster/presentation/cubits/profile_cubit/profile_state.dart';
import 'package:tripster/data/repository/profile_repository.dart';
import 'package:tripster/presentation/screens/auth/sign_up_screen.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository profileRepository;

  ProfileCubit(this.profileRepository) : super(ProfileInitial());

  Future<void> getUserProfile(String? token) async {
    emit(ProfileLoading());
    try {
      final userProfile = await profileRepository.getUserProfile(token);
      print(userProfile);
      if (userProfile != null) {
        emit(ProfileLoaded(userProfile));
      } else {
        emit(ProfileUnauthenticated());
      }
    } catch (e) {
      emit(ProfileError('Failed to load user: $e'));
    }
  }

  Future<void> updateUserProfile(
      String? token, String name, File? avatar) async {
    try {
      final updateData = {
        'name': name,
        'avatar': avatar,
      };

      final userProfile =
          await profileRepository.updateProfile(token!, updateData);
      print(userProfile);

      if (userProfile != null) {
        emit(ProfileLoaded(userProfile));
      } else {
        emit(ProfileUnauthenticated());
      }
    } catch (e) {
      emit(ProfileError('Failed to load user: $e'));
    }
  }

  Future<void> logout(BuildContext context) async {
    await profileRepository.logout();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => SignUpScreen()),
      (Route<dynamic> route) => false,
    );
    emit(ProfileUnauthenticated());
  }
}
