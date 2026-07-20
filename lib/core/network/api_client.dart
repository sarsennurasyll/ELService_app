import '../config/api_config.dart';

/// HTTP-клиент приложения.
///
/// TODO: подключить Dio и Node.js REST API.
/// TODO: добавить интерцептор JWT.
final class ApiClient {
  const ApiClient({required this.config});

  final ApiConfig config;

  /// TODO: реализовать GET.
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) {
    throw UnimplementedError('TODO: ApiClient.get($endpoint)');
  }

  /// TODO: реализовать POST.
  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
  }) {
    throw UnimplementedError('TODO: ApiClient.post($endpoint)');
  }

  /// TODO: реализовать PUT.
  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? body,
  }) {
    throw UnimplementedError('TODO: ApiClient.put($endpoint)');
  }

  /// TODO: реализовать PATCH.
  Future<Map<String, dynamic>> patch(
    String endpoint, {
    Map<String, dynamic>? body,
  }) {
    throw UnimplementedError('TODO: ApiClient.patch($endpoint)');
  }

  /// TODO: реализовать DELETE.
  Future<Map<String, dynamic>> delete(String endpoint) {
    throw UnimplementedError('TODO: ApiClient.delete($endpoint)');
  }
}
