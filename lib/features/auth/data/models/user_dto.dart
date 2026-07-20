/// DTO пользователя.
///
/// TODO: добавить fromJson / toJson после контракта Backend.
final class UserDto {
  const UserDto({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.phone,
  });

  final String id;
  final String email;
  final String name;
  final String role;
  final String? phone;
}
