import '../../domain/models/review.dart';
import '../models/review_dto.dart';

/// Маппер ReviewDto ↔ Review.
final class ReviewMapper {
  const ReviewMapper();

  Review fromDto(ReviewDto dto) {
    return Review(
      id: dto.id,
      orderId: dto.orderId,
      customerId: dto.customerId,
      technicianId: dto.technicianId,
      rating: dto.rating,
      comment: dto.comment,
    );
  }

  ReviewDto toDto(Review entity) {
    return ReviewDto(
      id: entity.id,
      orderId: entity.orderId,
      customerId: entity.customerId,
      technicianId: entity.technicianId,
      rating: entity.rating,
      comment: entity.comment,
    );
  }
}
