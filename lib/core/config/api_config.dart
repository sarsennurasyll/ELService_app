/// Конфигурация доступа к Backend.
///
/// TODO: подставить реальный baseUrl Node.js REST API.
final class ApiConfig {
  const ApiConfig({
    required this.baseUrl,
    this.connectTimeout = const Duration(seconds: 15),
    this.receiveTimeout = const Duration(seconds: 15),
    this.sendTimeout = const Duration(seconds: 15),
  });

  /// Placeholder до появления Backend.
  final String baseUrl;
  final Duration connectTimeout;
  final Duration receiveTimeout;
  final Duration sendTimeout;

  static const placeholder = ApiConfig(
    baseUrl: 'BASE_URL_PLACEHOLDER',
  );
}
