import 'dart:io';

class ProfileUser {
  final String userId;
  final String name;
  final String email;
  final String token;
  final String? avatarUrl;
  final File? avatar;

  ProfileUser({
    required this.userId,
    required this.name,
    required this.email,
    required this.token,
    required this.avatarUrl,
    required this.avatar,
  });

  factory ProfileUser.fromJson(Map<String, dynamic> json) {
    File? avatarFile;
    if (json['avatar'] != null) {
      avatarFile = File(json['avatar']);
    }

    return ProfileUser(
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      token: json['token'] ?? '',
      email: json['email'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
      avatar: avatarFile,
    );
  }
}
