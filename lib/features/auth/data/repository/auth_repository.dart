import 'package:dio/dio.dart';
import 'package:docdoc/models/auth_model.dart';
import '../../../../core/api/dio_factory.dart';
import '../../../../core/constants/end_points.dart';

class AuthRepository {
  final Dio dio =  DioFactory.getDio();
  // -------------------------------------------------------------------------
  // 1. LOGIN
  // -------------------------------------------------------------------------
  Future<AuthModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        EndPoints.login,
        data: FormData.fromMap({
          "email": email,
          "password": password,
        }),
      );
      return AuthModel.fromJson(response.data);
    } on DioException catch (e) {
      final responseData = e.response?.data;
      final errorMessage = responseData?['message'] ?? e.message;
      throw Exception("Login failed: $errorMessage");
    }
  }
  // -------------------------------------------------------------------------
  // 2. REGISTER
  // -------------------------------------------------------------------------
  Future<AuthModel> register({
    required String name,
    required String email,
    required String phone,
    required String gender,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final FormData formData = FormData.fromMap({
        "name": name,
        "email": email,
        "phone": phone,
        "gender": gender,
        "password": password,
        "password_confirmation": passwordConfirmation,
      });

      final response = await dio.post(
        EndPoints.register,
        data: formData,
      );

      return AuthModel.fromJson(response.data);

    } on DioException catch (e) {
      final responseData = e.response?.data;
      final errorMessage = responseData?['message'] ?? e.message;
      throw Exception("Registration failed: $errorMessage");
    }
  }
  // -------------------------------------------------------------------------
  // 3. LOGOUT
  // -------------------------------------------------------------------------
  Future<void> logout() async{
    try {
      await dio.post(EndPoints.logout);
    }on DioException catch(e){
      throw Exception("Logout failed : ${e.message}");
    }
  }

}


