import 'package:docdoc/models/user_profile_model.dart';
import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable{
  const ProfileEvent ();

  @override
  List<Object?> get props => [];
}

class GetUserProfileEvent extends ProfileEvent{}


class UpdateUserProfileEvent extends ProfileEvent {
  final UserData updatedData;

  const UpdateUserProfileEvent({required this.updatedData});

  @override
  List<Object?> get props => [updatedData];
}