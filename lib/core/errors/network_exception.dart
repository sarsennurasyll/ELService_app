/// Сетевая ошибка без ответа сервера.
///
/// TODO: обрабатывать таймауты и отсутствие соединения в ApiClient.
final class NetworkException implements Exception {
  const NetworkException({required this.message});

  final String message;

  @override
  String toString() => 'NetworkException: $message';
}
