import 'package:dio/dio.dart';
import 'package:docdoc/core/api/dio_factory.dart';
import 'package:docdoc/core/constants/end_points.dart';
import 'package:docdoc/models/user_profile_model.dart';

class ProfileRepository {
  final Dio _dio = DioFactory.getDio();

  Future<UserProfileModel> getUserProfile() async {
    try {
      final response = await _dio.get(EndPoints.userProfile);
      return UserProfileModel.fromJson(response.data);
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? e.message;
      throw Exception("Failed to fetch user profile: $errorMessage");
    }
  }

  Future<UserProfileModel> updateUserProfile(UserData body) async {
    try {
      final response = await _dio.post(
        EndPoints.updateProfile,
        data: body.toJson(),
      );
;
      return UserProfileModel.fromJson(response.data);
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? e.message;
      throw Exception("Failed to update profile: $errorMessage");
    }
  }
}