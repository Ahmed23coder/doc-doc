import 'package:docdoc/models/doctor_model.dart';

class HomeDataResponse {
  final String message;
  final List<SpecializationData> data;
  final bool status;
  final int code;

  HomeDataResponse({
    required this.message,
    required this.data,
    required this.status,
    required this.code,
  });

  factory HomeDataResponse.fromJson(Map<String, dynamic> json) {
    return HomeDataResponse(
      message: json['message'] ?? '',
      data:
          (json['data'] as List?)
              ?.map((e) => SpecializationData.fromJson(e))
              .toList() ??
          [],
      status: json['status'] ?? false,
      code: json['code'] ?? 0,
    );
  }
}

class SpecializationData {
  final int id;
  final String name;
  final List<DoctorModel> doctors;

  SpecializationData({
    required this.id,
    required this.name,
    required this.doctors,
  });

  factory SpecializationData.fromJson(Map<String, dynamic> json) {
    return SpecializationData(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      doctors:
          (json['doctors'] as List?)
              ?.map((e) => DoctorModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}
