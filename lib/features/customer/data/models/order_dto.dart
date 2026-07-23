/// DTO заказа из Backend.
final class OrderDto {
  const OrderDto({
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

  factory OrderDto.fromMap(Map<String, dynamic> map) {
    final id = map['id'];
    final customerId = map['customerId'];
    final categoryId = map['categoryId'];
    final status = map['status'];
    final description = map['description'];

    if (id is! String ||
        customerId is! String ||
        categoryId is! String ||
        status is! String ||
        description is! String) {
      throw const FormatException('Некорректные данные заказа');
    }

    return OrderDto(
      id: id,
      customerId: customerId,
      categoryId: categoryId,
      status: status,
      description: description,
      technicianId: map['technicianId'] as String?,
      assignedMasterId: map['assignedMasterId'] as String?,
      address: map['address'] as String?,
      price: _parsePrice(map['price']),
      preferredDate: _parseDate(map['preferredDate']),
    );
  }

  Map<String, dynamic> toCreateMap() {
    return {
      'customerId': customerId,
      'categoryId': categoryId,
      'description': description,
      'address': ?address,
      'preferredDate': ?preferredDate?.toIso8601String(),
    };
  }

  static double? _parsePrice(dynamic value) {
    return switch (value) {
      num value => value.toDouble(),
      String value => double.tryParse(value),
      _ => null,
    };
  }

  static DateTime? _parseDate(dynamic value) {
    return value is String ? DateTime.tryParse(value) : null;
  }
}
