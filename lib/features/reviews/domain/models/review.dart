final class Review {
  const Review({
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
}
