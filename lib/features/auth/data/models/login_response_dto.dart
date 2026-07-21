import 'user_dto.dart';

/// Ответ успешного входа / регистрации.
///
/// TODO: добавить fromJson после контракта Backend.
final class LoginResponseDto {
  const LoginResponseDto({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  final String accessToken;
  final String refreshToken;
  final UserDto user;

  factory LoginResponseDto.fromMap(Map<String, dynamic> map) {
    final userMap = Map<String, dynamic>.from(map['user'] as Map? ?? const {});
    return LoginResponseDto(
      accessToken: map['accessToken'] as String? ?? '',
      refreshToken: map['refreshToken'] as String? ?? '',
      user: UserDto.fromMap(userMap),
    );
  }
}
