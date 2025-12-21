import 'package:dio/dio.dart';
import 'package:docdoc/core/api/dio_factory.dart';
import 'package:docdoc/core/constants/end_points.dart';
import 'package:docdoc/models/appointment_model.dart';

class AppointmentRepository {
  final Dio _dio = DioFactory.getDio();

  Future<List<AppointmentData>> getAppointmentData() async {
    try {
      final response = await _dio.get(EndPoints.getAppointments);
      final responseModel = AppointmentModel.fromJson(response.data);

      return responseModel.data;
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? e.message;
      throw Exception("Failed to fetch home data : $errorMessage");
    }
  }

  Future<void> storeAppointment({
    required int doctorId,
    required String startTime,
    String? notes,
  }) async {
    try {
      await _dio.post(
        EndPoints.storeAppointment,
        data: {'doctor_id': doctorId, 'start_time': startTime, 'notes': notes},
      );
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? e.message;
      throw Exception("Failed to book appointment: $errorMessage");
    }
  }
}
