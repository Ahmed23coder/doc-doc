import 'package:docdoc/models/city_model.dart';
import 'package:docdoc/models/specialization_model.dart';


class DoctorSearchResponse {
  final String message;
  final List<DoctorModel> data;
  final bool status;
  final int code;

  DoctorSearchResponse({
    required this.message,
    required this.data,
    required this.status,
    required this.code,
  });
  factory DoctorSearchResponse.fromJson(Map<String, dynamic> json) {
    return DoctorSearchResponse(
      message: json['message'] ?? '',
      data:
      (json['data'] as List<dynamic>?)
          ?.map((e) => DoctorModel.fromJson(e))
          .toList() ??
          [],
      status: json['status'] ?? false,
      code: json['code'] ?? 0,
    );
  }
}




class DoctorModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String photo;
  final String gender;
  final String address;
  final String description;
  final String degree;
  final int appointPrice;
  final String startTime;
  final String endTime;

  final SpecializationModel? specialization;
  final CityModel? city;

  DoctorModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.photo,
    required this.gender,
    required this.address,
    required this.description,
    required this.degree,
    required this.appointPrice,
    required this.startTime,
    required this.endTime,
    this.specialization,
    this.city,
  });

  factory DoctorModel.fromJson(Map<String, dynamic>json){
    return DoctorModel(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        email: json['email'] ?? '',
        phone: json['phone'] ?? '',
        photo: json['photo'] ?? '',
        gender: json['gender'] ?? '',
        address: json['address'] ?? '',
        description: json['description'] ?? '',
        degree: json['degree'] ?? '',
        appointPrice: (json ['appoint_price'] is int)
      ? json ['appoint_price']
            :int.tryParse(json ['appoint_price'].toString()) ?? 0,
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',

      specialization:  json['specialization'] != null
        ? SpecializationModel.fromJson(json ['specialization'])
          : null,



      city: json['city'] != null
          ? CityModel.fromJson(json['city'])
          : null,
    );
  }
}
