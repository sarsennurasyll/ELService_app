/// DTO заказа.
///
/// TODO: добавить fromJson / toJson после контракта Backend.
final class OrderDto {
  const OrderDto({
    required this.id,
    required this.customerId,
    required this.categoryId,
    required this.status,
    required this.description,
    this.technicianId,
    this.address,
    this.price,
  });

  final String id;
  final String customerId;
  final String categoryId;
  final String status;
  final String description;
  final String? technicianId;
  final String? address;
  final double? price;
}
