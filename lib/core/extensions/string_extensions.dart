/// Вспомогательные расширения для строк.
extension StringExtensions on String {
  bool get isBlank => trim().isEmpty;

  bool get isNotBlank => !isBlank;
}
