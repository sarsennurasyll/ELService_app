/// Конфигурация доступа к Backend.
///
/// TODO: подключить Node.js REST API и окружения.
final class ApiConfig {
  const ApiConfig({
    required this.baseUrl,
    this.connectTimeout = const Duration(seconds: 15),
    this.receiveTimeout = const Duration(seconds: 15),
  });

  final String baseUrl;
  final Duration connectTimeout;
  final Duration receiveTimeout;

  /// Временный адрес до появления Backend.
  static const development = ApiConfig(
    baseUrl: 'http://localhost:3000/api/v1',
  );
}
