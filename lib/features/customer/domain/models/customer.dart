/// Доменная модель клиента.
final class Customer {
  const Customer({
    required this.id,
    required this.userId,
    required this.name,
    this.phone,
    this.city,
  });

  final String id;
  final String userId;
  final String name;
  final String? phone;
  final String? city;
}
