import 'package:dio/dio.dart';
import 'package:docdoc/core/services/global_auth_service.dart';
import 'package:docdoc/core/services/secure_storage_service.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioFactory {
  static Dio? _dio;

  static const String _baseUrl = 'https://vcare.integration25.com/api/';

  DioFactory._();

  static Dio getDio() {
    if (_dio == null) {
      const int timeout = 60 * 1000;

      BaseOptions options = BaseOptions(
        baseUrl: _baseUrl,
        receiveTimeout: const Duration(milliseconds: timeout),
        sendTimeout: const Duration(milliseconds: timeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Accept-Language': 'en',
        },
      );
      final dioInstance = Dio(options);
      _dio = dioInstance;

      dioInstance.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: true,
        ),
      );
      dioInstance.interceptors.add(AuthInterceptor());
    }
    return _dio!;
  }
}

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    final publicEndpoints = [
      'auth/login',
      'auth/register',
      '/auth/login',
      '/auth/register',
    ];

    if (publicEndpoints.contains(options.path)) {
      return handler.next(options);
    }
    final secureStorage = SecureStorageService();
    final storedToken = await secureStorage.getToken();
    if (storedToken != null && storedToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $storedToken';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      GlobalAuthService.instance.forceLogout();
    }

    handler.next(err);
  }
}
