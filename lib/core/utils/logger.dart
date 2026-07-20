import 'package:flutter/foundation.dart';

/// Простой логгер сетевого слоя.
///
/// TODO: подключить полноценное логирование для debug/release.
final class Logger {
  const Logger();

  void logRequest(String method, String endpoint, [Object? body]) {
    debugPrint('[HTTP] → $method $endpoint${body == null ? '' : ' body=$body'}');
  }

  void logResponse(String method, String endpoint, int? statusCode, [Object? body]) {
    debugPrint(
      '[HTTP] ← $method $endpoint status=${statusCode ?? '-'}${body == null ? '' : ' body=$body'}',
    );
  }

  void logError(String method, String endpoint, Object error, [StackTrace? stackTrace]) {
    debugPrint('[HTTP] ✕ $method $endpoint error=$error');
    if (stackTrace != null) {
      debugPrint(stackTrace.toString());
    }
  }
}
