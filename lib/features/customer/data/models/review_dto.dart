/// DTO отзыва.
///
/// TODO: добавить fromJson / toJson после контракта Backend.
final class ReviewDto {
  const ReviewDto({
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
