import 'package:dio/dio.dart';

import '../../constants/api_constants.dart';
import '../../storage/token_storage.dart';
import '../api_endpoints.dart';

/// Добавляет JWT и один раз обновляет access token после 401.
final class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({
    required TokenStorage tokenStorage,
    required Dio refreshDio,
  }) : _tokenStorage = tokenStorage,
       _refreshDio = refreshDio;

  final TokenStorage _tokenStorage;
  final Dio _refreshDio;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _tokenStorage.getAccessToken();
    if (token != null && token.isNotEmpty && !_isAuthEndpoint(options.path)) {
      options.headers[ApiConstants.authorizationHeader] =
          '${ApiConstants.bearerPrefix} $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final request = err.requestOptions;
    if (!_shouldRefresh(err)) {
      handler.next(err);
      return;
    }

    final refreshToken = await _tokenStorage.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      await _tokenStorage.clear();
      handler.next(err);
      return;
    }

    try {
      final response = await _refreshDio.post<dynamic>(
        ApiEndpoints.authRefresh,
        data: {'refreshToken': refreshToken},
      );
      final accessToken = _tokenFromResponse(response.data, 'accessToken');
      final nextRefreshToken = _tokenFromResponse(response.data, 'refreshToken');
      if (accessToken == null || accessToken.isEmpty) {
        await _tokenStorage.clear();
        handler.next(err);
        return;
      }

      await _tokenStorage.saveAccessToken(accessToken);
      if (nextRefreshToken != null && nextRefreshToken.isNotEmpty) {
        await _tokenStorage.saveRefreshToken(nextRefreshToken);
      }

      final retryOptions = request.copyWith(
        headers: {
          ...request.headers,
          ApiConstants.authorizationHeader:
              '${ApiConstants.bearerPrefix} $accessToken',
        },
        extra: {...request.extra, _retryKey: true},
      );
      final retryResponse = await _refreshDio.fetch<dynamic>(retryOptions);
      handler.resolve(retryResponse);
    } on DioException {
      await _tokenStorage.clear();
      handler.next(err);
    }
  }

  bool _shouldRefresh(DioException err) {
    return err.response?.statusCode == 401 &&
        err.requestOptions.extra[_retryKey] != true &&
        !_isAuthEndpoint(err.requestOptions.path);
  }

  bool _isAuthEndpoint(String path) {
    return path == ApiEndpoints.authLogin ||
        path == ApiEndpoints.authRegister ||
        path == ApiEndpoints.authRefresh ||
        path == ApiEndpoints.authLogout;
  }

  String? _tokenFromResponse(dynamic response, String key) {
    if (response is! Map) {
      return null;
    }

    final data = response['data'];
    final value = data is Map ? data[key] : response[key];
    return value is String ? value : null;
  }

  static const _retryKey = 'auth_retry';
}
