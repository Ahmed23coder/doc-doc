class AuthModel {
  final String message;
  final AuthData data;
  final bool status;
  final int code;

  AuthModel({
    required this.message,
    required this.data,
    required this.status,
    required this.code,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      message: json['message'] ?? '',
      data: json['data'] is Map
          ? AuthData.fromJson(json['data'])
          : AuthData.empty(),
      status: json['status'] ?? false,
      code: json['code'] ?? 0,
    );
  }
}

class AuthData {
  final String token;
  final String username;

  AuthData({required this.token, required this.username});


  factory AuthData.fromJson ( Map <String, dynamic> json){
    return AuthData(
    token: json['token'] ?? '',
    username: json['username'] ?? '',
  );
  }
  factory AuthData.empty(){
    return AuthData (token: '', username: '');
  }
}
