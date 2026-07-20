/// Тело запроса входа.
///
/// TODO: добавить toJson после контракта Backend.
final class LoginRequestDto {
  const LoginRequestDto({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
    };
  }
}
