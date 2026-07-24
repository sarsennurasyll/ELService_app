import 'package:flutter/foundation.dart';

/// Логгер сетевого слоя без вывода чувствительных данных.
final class Logger {
  const Logger();

  void logRequest(String method, String endpoint, [Object? body]) {
    debugPrint('[HTTP] → $method $endpoint');
  }

  void logResponse(
    String method,
    String endpoint,
    int? statusCode, [
    Object? body,
  ]) {
    debugPrint('[HTTP] ← $method $endpoint status=${statusCode ?? '-'}');
  }

  void logError(
    String method,
    String endpoint,
    Object error, [
    StackTrace? stackTrace,
  ]) {
    debugPrint('[HTTP] ✕ $method $endpoint error=$error');
    if (stackTrace != null) {
      debugPrint(stackTrace.toString());
    }
  }
}
