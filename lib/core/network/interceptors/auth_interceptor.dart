import 'package:dio/dio.dart';

import '../../constants/api_constants.dart';
import '../../storage/token_storage.dart';

/// Добавляет JWT в заголовок Authorization, если токен есть.
final class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({required TokenStorage tokenStorage})
    : _tokenStorage = tokenStorage;

  final TokenStorage _tokenStorage;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _tokenStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers[ApiConstants.authorizationHeader] =
          '${ApiConstants.bearerPrefix} $token';
    }
    handler.next(options);
  }
}
