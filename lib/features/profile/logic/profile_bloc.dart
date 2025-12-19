import 'package:docdoc/features/profile/data/repository/profile_repository.dart';
import 'package:docdoc/features/profile/logic/profile_event.dart';
import 'package:docdoc/features/profile/logic/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _profileRepository;

  ProfileBloc(this._profileRepository) : super(ProfileInitial()) {

    // ---------------------------------------------------------
    // 1. GET USER PROFILE
    // ---------------------------------------------------------
    on<GetUserProfileEvent>((event, emit) async {
      emit(ProfileLoading());
      try {
        final response = await _profileRepository.getUserProfile();

        // CHECK: Ensure data is not null before emitting
        if (response.data != null) {
          emit(ProfileLoaded(response.data!));
        } else {
          emit(const ProfileError("Failed to fetch user data (Data is null)"));
        }
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });

    // ---------------------------------------------------------
    // 2. UPDATE USER PROFILE
    // ---------------------------------------------------------
    on<UpdateUserProfileEvent>((event, emit) async {
      emit(ProfileLoading());
      try {
        // Pass the UserData object from the event to the repository
        final response = await _profileRepository.updateUserProfile(event.updatedData);

        // Emit the NEW data returned from the API so the UI updates immediately
        if (response.data != null) {
          emit(ProfileLoaded(response.data!));
        } else {
          emit(const ProfileError("Update failed: No data returned"));
        }
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });
  }
}