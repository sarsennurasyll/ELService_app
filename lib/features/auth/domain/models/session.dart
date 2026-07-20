import 'user.dart';

/// Активная сессия пользователя.
final class Session {
  const Session({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  final User user;
  final String accessToken;
  final String refreshToken;
}
