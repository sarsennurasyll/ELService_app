/// Тело запроса регистрации.
///
/// TODO: добавить toJson после контракта Backend.
final class RegisterRequestDto {
  const RegisterRequestDto({
    required this.email,
    required this.password,
    required this.fullName,
    required this.phone,
    required this.role,
  });

  final String email;
  final String password;
  final String fullName;
  final String phone;
  final String role;

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
      'fullName': fullName,
      'phone': phone,
      'role': role,
    };
  }
}
