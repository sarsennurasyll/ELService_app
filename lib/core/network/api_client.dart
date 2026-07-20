/// HTTP-клиент приложения.
///
/// TODO: подключить Dio и Node.js REST API.
/// TODO: добавить интерцептор JWT.
final class ApiClient {
  const ApiClient({required this.baseUrl});

  final String baseUrl;

  /// TODO: реализовать GET через Dio.
  Future<Map<String, dynamic>> get(String endpoint) {
    throw UnimplementedError(
      'TODO: RemoteDataSource — GET $baseUrl$endpoint',
    );
  }

  /// TODO: реализовать POST через Dio.
  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
  }) {
    throw UnimplementedError(
      'TODO: RemoteDataSource — POST $baseUrl$endpoint',
    );
  }

  /// TODO: реализовать PUT через Dio.
  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? body,
  }) {
    throw UnimplementedError(
      'TODO: RemoteDataSource — PUT $baseUrl$endpoint',
    );
  }

  /// TODO: реализовать DELETE через Dio.
  Future<Map<String, dynamic>> delete(String endpoint) {
    throw UnimplementedError(
      'TODO: RemoteDataSource — DELETE $baseUrl$endpoint',
    );
  }
}
