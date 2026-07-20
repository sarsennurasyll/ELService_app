/// Тело запроса регистрации.
///
/// TODO: добавить toJson после контракта Backend.
final class RegisterRequestDto {
  const RegisterRequestDto({
    required this.email,
    required this.password,
    required this.name,
  });

  final String email;
  final String password;
  final String name;

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
      'name': name,
    };
  }
}
