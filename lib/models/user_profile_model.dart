class UserProfileModel {
  final String message;
  final UserData? data;
  final bool status;
  final int code;

  UserProfileModel({
    required this.message,
    required this.data,
    required this.status,
    required this.code,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    UserData? parsedData;

    if (json['data'] != null) {
      // 1. Check if 'data' is a List (usually from GET requests)
      if (json['data'] is List) {
        final list = json['data'] as List;
        if (list.isNotEmpty) {
          // Take the first item from the list
          parsedData = UserData.fromJson(list.first as Map<String, dynamic>);
        }
      }
      // 2. Check if 'data' is a Map (usually from POST/PUT requests)
      else if (json['data'] is Map<String, dynamic>) {
        parsedData = UserData.fromJson(json['data']);
      }
    }

    return UserProfileModel(
      message: json['message'] ?? '',
      data: parsedData,
      status: json['status'] ?? false,
      code: json['code'] ?? 0,
    );
  }
}

class UserData {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String gender;
  final String? token;

  UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.gender,
    this.token,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      gender: json['gender'] ?? '',
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'gender': gender,
    };
  }
}