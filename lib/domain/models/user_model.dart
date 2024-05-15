class ProfileUser {
  final String userId;
  final String name;
  final String email;
  final String token;
  // final List<Vacation> usersVacation;

  ProfileUser({
    required this.userId,
    required this.name,
    required this.email,
    required this.token,
  });

  factory ProfileUser.fromJson(Map<String, dynamic> json) {
    return ProfileUser(
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      token: json['token'] ?? '',
      email: json['email'] ?? '',
    );
  }
}
