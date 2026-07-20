/// Доменная модель отзыва.
final class Review {
  const Review({
    required this.id,
    required this.orderId,
    required this.customerId,
    required this.technicianId,
    required this.rating,
    this.comment,
  });

  final String id;
  final String orderId;
  final String customerId;
  final String technicianId;
  final int rating;
  final String? comment;
}
