import 'package:docdoc/models/user_profile_model.dart';
import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable{
  const ProfileState();
  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState{}
class ProfileLoading extends ProfileState{}
class ProfileLoaded extends ProfileState{
  final UserData userData;
  const ProfileLoaded(this.userData);
  @override
  List<Object?> get props => [userData];
}
class ProfileUpdateSuccess extends ProfileState{
  final String message;
  const ProfileUpdateSuccess(this.message);
  @override
  List<Object?> get props => [message];
}
class ProfileError extends ProfileState{
  final String message;
  const ProfileError(this.message);
  @override
  List<Object?> get props => [message];
}