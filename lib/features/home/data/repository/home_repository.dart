import 'package:dio/dio.dart';
import 'package:docdoc/core/api/dio_factory.dart';
import 'package:docdoc/core/constants/end_points.dart';
import 'package:docdoc/models/home_response_model.dart';

class HomeRepository{
  final Dio _dio = DioFactory.getDio();



  Future<HomeDataResponse> getHomeData () async {
    try {
      final response = await _dio.get(EndPoints.homeIndex);

      return HomeDataResponse.fromJson(response.data);
    }on DioException catch(e){
      final errorMessage= e.response?.data['message'] ?? e.message;
      throw Exception("Failed to fetch home data : $errorMessage");
    }
  }
}