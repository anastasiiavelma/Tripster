abstract class AuthState {
  const AuthState();

  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  // final String userId;
  final String token;
  const AuthAuthenticated(this.token);

  // @override
  // List<Object?> get props => [userId];
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}
