import '../../domain/models/master_rating.dart';
import '../models/master_rating_dto.dart';

final class MasterRatingMapper {
  const MasterRatingMapper();

  MasterRating fromDto(MasterRatingDto dto) {
    return MasterRating(
      masterId: dto.masterId,
      averageRating: dto.averageRating,
      reviewsCount: dto.reviewsCount,
    );
  }
}
