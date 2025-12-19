import 'package:equatable/equatable.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object?> get props => [];
}

class SignupButtonPressed extends SignupEvent {
  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;
  final String phone;
  final String gender;

  const SignupButtonPressed({
    required this.name,
    required this.email,
    required this.phone,
    required this.gender,
    required this.password,
    required this.passwordConfirmation,
  });

  @override
  List<Object> get props => [
    name,
    email,
    phone,
    gender,
    password,
    passwordConfirmation,
  ];
}
