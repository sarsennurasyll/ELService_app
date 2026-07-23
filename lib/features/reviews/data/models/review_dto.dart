final class ReviewDto {
  const ReviewDto({
    required this.id,
    required this.orderId,
    required this.customerId,
    required this.masterId,
    required this.rating,
    required this.createdAt,
    this.comment,
    this.customerName,
  });

  final String id;
  final String orderId;
  final String customerId;
  final String masterId;
  final int rating;
  final DateTime createdAt;
  final String? comment;
  final String? customerName;

  factory ReviewDto.fromMap(Map<String, dynamic> map) {
    final id = map['id'];
    final orderId = map['orderId'];
    final customerId = map['customerId'];
    final masterId = map['masterId'] ?? map['technicianId'];
    final rating = map['rating'];
    final createdAt = map['createdAt'];

    if (id is! String ||
        orderId is! String ||
        customerId is! String ||
        masterId is! String ||
        rating is! int ||
        createdAt is! String) {
      throw const FormatException('Некорректные данные отзыва');
    }

    final customer = map['customer'];

    return ReviewDto(
      id: id,
      orderId: orderId,
      customerId: customerId,
      masterId: masterId,
      rating: rating,
      createdAt: DateTime.parse(createdAt),
      comment: map['comment'] as String?,
      customerName: customer is Map ? customer['fullName'] as String? : null,
    );
  }

  static Map<String, dynamic> toCreateMap({
    required String orderId,
    required int rating,
    String? comment,
  }) {
    return {
      'orderId': orderId,
      'rating': rating,
      'comment': ?comment,
    };
  }
}
