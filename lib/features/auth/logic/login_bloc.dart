import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:docdoc/features/auth/logic/auth_state.dart';
import 'package:docdoc/features/auth/logic/login_event.dart';
import 'package:docdoc/core/services/secure_storage_service.dart';
import '../data/repository/auth_repository.dart';

class LoginBloc extends Bloc<LoginEvent, AuthState> {
  final AuthRepository _authRepository;
  final SecureStorageService _secureStorage = SecureStorageService();

  LoginBloc(this._authRepository) : super( AuthInitial()) {

    on<LoginButtonPressed>((event, emit) async {
      emit( AuthLoading());

      try {
        final authModel = await _authRepository.login(
          email: event.email.trim(),
          password: event.password.trim(),
        );

        if (authModel.data.token.isEmpty) {
          emit(const AuthError("Login Failed: No token received"));
          return;
        }

        await _secureStorage.saveUserSession(
          token: authModel.data.token,
          username: authModel.data.username,
        );

        emit(AuthSuccess(authModel));

      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });
  }
}