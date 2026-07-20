import '../errors/failure.dart';

/// Обёртка результата операции без исключений в UI-слое.
sealed class Result<T> {
  const Result();
}

final class Success<T> extends Result<T> {
  const Success(this.value);

  final T value;
}

final class ErrorResult<T> extends Result<T> {
  const ErrorResult(this.failure);

  final Failure failure;
}
