/// DTO клиента.
///
/// TODO: добавить fromJson / toJson после контракта Backend.
final class CustomerDto {
  const CustomerDto({
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
