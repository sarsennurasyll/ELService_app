/// Ошибка доменного уровня для передачи в presentation.
final class Failure {
  const Failure({required this.message, this.code});

  final String message;
  final String? code;
}
