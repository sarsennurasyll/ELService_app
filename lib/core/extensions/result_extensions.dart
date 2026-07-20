import '../errors/failure.dart';
import '../utils/result.dart';

/// Удобные проверки для [Result].
extension ResultExtensions<T> on Result<T> {
  bool get isSuccess => this is Success<T>;

  bool get isError => this is ErrorResult<T>;

  T? get valueOrNull => switch (this) {
    Success(:final value) => value,
    ErrorResult() => null,
  };

  Failure? get failureOrNull => switch (this) {
    Success() => null,
    ErrorResult(:final failure) => failure,
  };
}
