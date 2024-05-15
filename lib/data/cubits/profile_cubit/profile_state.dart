import 'package:tripster/domain/models/user_model.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  ProfileUser profileUser;
  ProfileLoaded(this.profileUser);
}

class ProfileError extends ProfileState {
  final String error;

  ProfileError(this.error);
}
