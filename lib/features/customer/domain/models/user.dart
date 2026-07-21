final class User {
  const User({
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
}
