/// Доменная модель заказа.
final class Order {
  const Order({
    required this.id,
    required this.customerId,
    required this.categoryId,
    required this.status,
    required this.description,
    this.technicianId,
    this.assignedMasterId,
    this.address,
    this.price,
    this.preferredDate,
  });

  final String id;
  final String customerId;
  final String categoryId;
  final String status;
  final String description;
  final String? technicianId;
  final String? assignedMasterId;
  final String? address;
  final double? price;
  final DateTime? preferredDate;
}
