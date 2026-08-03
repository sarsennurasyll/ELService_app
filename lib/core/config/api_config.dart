import 'package:flutter/foundation.dart';

/// Конфигурация доступа к Backend.
final class ApiConfig {
  const ApiConfig({
    required this.baseUrl,
    this.connectTimeout = const Duration(seconds: 15),
    this.receiveTimeout = const Duration(seconds: 15),
    this.sendTimeout = const Duration(seconds: 15),
  });

  static const productionBaseUrl = 'https://api.elservice.dev';

  final String baseUrl;
  final Duration connectTimeout;
  final Duration receiveTimeout;
  final Duration sendTimeout;

  String get releaseSafeBaseUrl =>
      kReleaseMode && _isLocalUrl(baseUrl) ? productionBaseUrl : baseUrl;

  static bool _isLocalUrl(String value) =>
      value.contains('://localhost') || value.contains('://127.0.0.1');
}
