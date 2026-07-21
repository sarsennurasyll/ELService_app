final class UserDto {
  const UserDto({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    this.phone,
    this.avatar,
    this.city,
  });

  final String id;
  final String fullName;
  final String email;
  final String role;
  final String? phone;
  final String? avatar;
  final String? city;

  factory UserDto.fromMap(Map<String, dynamic> map) {
    final id = map['id'];
    final fullName = map['fullName'];
    final email = map['email'];
    final role = map['role'];

    if (id is! String ||
        fullName is! String ||
        email is! String ||
        role is! String) {
      throw const FormatException('Некорректные данные профиля');
    }

    return UserDto(
      id: id,
      fullName: fullName,
      email: email,
      role: role,
      phone: map['phone'] as String?,
      avatar: map['avatar'] as String?,
      city: map['city'] as String?,
    );
  }

  static Map<String, dynamic> toUpdateMap({
    String? fullName,
    String? phone,
    String? avatar,
    String? city,
  }) {
    return {
      'fullName': ?fullName,
      'phone': ?phone,
      'avatar': ?avatar,
      'city': ?city,
    };
  }
}
