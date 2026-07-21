/// DTO пользователя.
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

  factory UserDto.fromMap(Map<String, dynamic> map) {
    return UserDto(
      id: map['id'] as String? ?? '',
      email: map['email'] as String? ?? '',
      name: map['fullName'] as String? ?? '',
      role: map['role'] as String? ?? '',
      phone: map['phone'] as String?,
    );
  }
}
