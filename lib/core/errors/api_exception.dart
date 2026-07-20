/// Ошибка ответа Backend.
///
/// TODO: маппить статусы Node.js REST API в Failure.
final class ApiException implements Exception {
  const ApiException({
    required this.message,
    this.statusCode,
    this.code,
  });

  final String message;
  final int? statusCode;
  final String? code;

  @override
  String toString() => 'ApiException($statusCode): $message';
}
