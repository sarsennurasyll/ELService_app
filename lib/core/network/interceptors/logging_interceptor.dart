import 'package:dio/dio.dart';

import '../../utils/logger.dart';

/// Логирует HTTP request / response / error через [Logger].
final class LoggingInterceptor extends Interceptor {
  LoggingInterceptor({required Logger logger}) : _logger = logger;

  final Logger _logger;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logger.logRequest(options.method, options.uri.toString(), options.data);
    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    _logger.logResponse(
      response.requestOptions.method,
      response.requestOptions.uri.toString(),
      response.statusCode,
      response.data,
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.logError(
      err.requestOptions.method,
      err.requestOptions.uri.toString(),
      err,
      err.stackTrace,
    );
    handler.next(err);
  }
}
