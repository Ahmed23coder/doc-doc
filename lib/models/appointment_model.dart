import 'doctor_model.dart';

class AppointmentModel {
  final String message;
  final List<AppointmentData> data;
  final bool status;
  final int code;

  AppointmentModel({
    required this.message,
    required this.data,
    required this.status,
    required this.code,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      message: json['message'] ?? '',
      data:
          (json['data'] as List?)
              ?.map((e) => AppointmentData.fromJson(e))
              .toList() ??
          [],
      status: json['status'] ?? false,
      code: json['code'] ?? 0,
    );
  }
}

class AppointmentData {
  final int id;
  final DoctorModel? doctor;
  final String appointmentTime;
  final String appointmentEndTime;
  final String status;
  final int appointmentPrice;

  AppointmentData({
    required this.id,
    this.doctor,
    required this.appointmentTime,
    required this.appointmentEndTime,
    required this.status,
    required this.appointmentPrice,
  });

  factory AppointmentData.fromJson(Map<String, dynamic> json) {
    return AppointmentData(
      id: json['id'] ?? 0,
      doctor: json['doctor'] is Map
          ? DoctorModel.fromJson(json['doctor'])
          : null,
      appointmentTime: json['appointment_time'] ?? '',
      appointmentEndTime: json['appointment_end_time'] ?? '',
      status: json['status'] ?? '',
      appointmentPrice: (json['appointment_price'] is int)
          ? json['appointment_price']
          : int.tryParse(json['appointment_price'].toString()) ?? 0,
    );
  }
}
