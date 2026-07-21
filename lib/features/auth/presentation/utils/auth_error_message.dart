import '../../../../core/errors/failure.dart';

String authErrorMessage(Failure failure) {
  return switch (failure.statusCode) {
    400 => 'Проверьте корректность введённых данных.',
    401 => 'Неверный email или пароль.',
    409 => 'Пользователь с такими данными уже существует.',
    500 => 'Сервис временно недоступен. Попробуйте позже.',
    _ => failure.message,
  };
}
