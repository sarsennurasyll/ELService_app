import '../../domain/models/review.dart';
import '../models/review_dto.dart';

final class ReviewMapper {
  const ReviewMapper();

  Review fromDto(ReviewDto dto) {
    return Review(
      id: dto.id,
      orderId: dto.orderId,
      customerId: dto.customerId,
      masterId: dto.masterId,
      rating: dto.rating,
      createdAt: dto.createdAt,
      comment: dto.comment,
      customerName: dto.customerName,
    );
  }
}
