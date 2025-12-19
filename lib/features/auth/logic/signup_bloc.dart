import 'package:docdoc/features/auth/data/repository/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:docdoc/core/services/secure_storage_service.dart';
import '../../../models/auth_model.dart';
import 'auth_state.dart';
import 'signup_event.dart';

class SignupBloc extends Bloc<SignupEvent, AuthState> {
  final AuthRepository _authRepository;
  final SecureStorageService _secureStorage = SecureStorageService();

  SignupBloc(this._authRepository) : super(AuthInitial()) {
    on<SignupButtonPressed>(_onSignupButtonPressed);
  }

  Future<void> _onSignupButtonPressed(
      SignupButtonPressed event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());

    try {
      final authModel = await _authRepository.register(
        name: event.name.trim(),
        email: event.email.trim(),
        phone: event.phone.trim(),
        gender: event.gender.trim(),
        password: event.password.trim(),
        passwordConfirmation: event.passwordConfirmation.trim(),
      );

      // Check if the response contains a valid token
      if (authModel.data.token.isEmpty) {
        emit(const AuthError("Signup Failed: No token received"));
        return;
      }

      // Save session securely
      await _secureStorage.saveUserSession(
        token: authModel.data.token,
        username: authModel.data.username,
      );

      emit(AuthSuccess(authModel as AuthModel));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}