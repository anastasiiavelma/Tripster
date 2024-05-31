abstract class AuthState {
  const AuthState();

  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String token;
  const AuthAuthenticated(this.token);
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);
}
