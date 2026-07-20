import 'package:dio/dio.dart';

import '../config/api_config.dart';
import '../constants/api_constants.dart';
import '../errors/api_exception.dart';
import '../errors/network_exception.dart';
import '../storage/token_storage.dart';
import '../utils/logger.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

/// HTTP-клиент на базе Dio для будущего Node.js Backend.
final class ApiClient {
  ApiClient({
    required ApiConfig config,
    required TokenStorage tokenStorage,
    Logger logger = const Logger(),
    Dio? dio,
  }) : _dio =
           dio ??
           Dio(
             BaseOptions(
               baseUrl: config.baseUrl,
               connectTimeout: config.connectTimeout,
               receiveTimeout: config.receiveTimeout,
               sendTimeout: config.sendTimeout,
               contentType: ApiConstants.jsonContentType,
               responseType: ResponseType.json,
               headers: const {
                 ApiConstants.contentTypeHeader: ApiConstants.jsonContentType,
                 Headers.acceptHeader: ApiConstants.jsonContentType,
               },
             ),
           ) {
    _dio.interceptors.addAll([
      AuthInterceptor(tokenStorage: tokenStorage),
      LoggingInterceptor(logger: logger),
    ]);
  }

  final Dio _dio;

  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) {
    return _request(
      () => _dio.get<dynamic>(endpoint, queryParameters: queryParameters),
    );
  }

  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
  }) {
    return _request(() => _dio.post<dynamic>(endpoint, data: body));
  }

  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? body,
  }) {
    return _request(() => _dio.put<dynamic>(endpoint, data: body));
  }

  Future<Map<String, dynamic>> patch(
    String endpoint, {
    Map<String, dynamic>? body,
  }) {
    return _request(() => _dio.patch<dynamic>(endpoint, data: body));
  }

  Future<Map<String, dynamic>> delete(String endpoint) {
    return _request(() => _dio.delete<dynamic>(endpoint));
  }

  Future<Map<String, dynamic>> _request(
    Future<Response<dynamic>> Function() call,
  ) async {
    try {
      final response = await call();
      return _asJsonMap(response.data);
    } on DioException catch (error) {
      throw _mapDioException(error);
    }
  }

  Map<String, dynamic> _asJsonMap(dynamic data) {
    if (data == null) {
      return const {};
    }
    if (data is Map<String, dynamic>) {
      return data;
    }
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    return {'data': data};
  }

  Exception _mapDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
      case DioExceptionType.connectionError:
        return NetworkException(
          message: error.message ?? 'Нет соединения с сервером',
        );
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final data = error.response?.data;
        final message = _extractErrorMessage(data) ??
            error.message ??
            'Ошибка ответа сервера';
        return ApiException(message: message, statusCode: statusCode);
      case DioExceptionType.cancel:
        return const NetworkException(message: 'Запрос отменён');
      case DioExceptionType.badCertificate:
        return const NetworkException(message: 'Ошибка SSL-сертификата');
      case DioExceptionType.unknown:
        return NetworkException(
          message: error.message ?? 'Неизвестная сетевая ошибка',
        );
    }
  }

  String? _extractErrorMessage(dynamic data) {
    if (data is Map) {
      final message = data['message'] ?? data['error'];
      if (message is String && message.isNotEmpty) {
        return message;
      }
    }
    if (data is String && data.isNotEmpty) {
      return data;
    }
    return null;
  }
}
