import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tripster/presentation/cubits/auth_cubit/auth_state.dart';
import 'package:tripster/data/repository/auth_repository.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(AuthInitial()) {
    checkUserLoggedIn();
  }

  Future<void> checkUserLoggedIn() async {
    final token = await _authRepository.getToken();
    if (token != null) {
      emit(AuthAuthenticated(token));
    }
  }

  Future<void> loginUser(String email, String password) async {
    emit(AuthLoading());
    try {
      final token = await _authRepository.loginUser(email, password);
      emit(AuthAuthenticated(token));
    } catch (e) {
      print(e);
      emit(AuthError('Incorrect email or password'));
    }
  }

  Future<void> registerUser(String name, String email, String password) async {
    emit(AuthLoading());
    try {
      final token = await _authRepository.registerUser(name, email, password);
      emit(AuthAuthenticated(token));
    } catch (e) {
      print(e);
      emit(AuthError('Incorrect email or password'));
    }
  }
}
