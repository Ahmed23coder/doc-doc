import 'package:dio/dio.dart';
import 'package:docdoc/core/api/dio_factory.dart';
import 'package:docdoc/core/constants/end_points.dart';
import 'package:docdoc/models/doctor_filter_model.dart';
import '../../../../models/doctor_model.dart';
import '../../../../models/specialization_model.dart';
class SearchRepository {
  final Dio _dio = DioFactory.getDio();

  Future<DoctorSearchResponse> getSearchData({
    required String query,
    required DoctorFilterModel filters,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {'name': query};

      queryParams.addAll(filters.toJson());

      final response = await _dio.get(
        EndPoints
            .doctorSearch,
        queryParameters: queryParams,
      );

      return DoctorSearchResponse.fromJson(response.data);
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? e.message;
      throw Exception("Failed to search doctors: $errorMessage");
    }
  }

  Future<List<SpecializationModel>> getAllSpecializations() async {
    try {
      final response = await _dio.get(EndPoints.specializationIndex);

      if (response.data['data'] is List) {
        return (response.data['data'] as List)
            .map((e) => SpecializationModel.fromJson(e))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      throw Exception("Failed to load specializations");
    }
  }
}
