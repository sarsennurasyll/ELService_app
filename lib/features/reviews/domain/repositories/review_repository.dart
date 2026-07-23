import '../../../../core/utils/result.dart';
import '../models/master_rating.dart';
import '../models/review.dart';

abstract interface class ReviewRepository {
  Future<Result<Review>> createReview({
    required String orderId,
    required int rating,
    String? comment,
  });

  Future<Result<List<Review>>> getMasterReviews(String masterId);

  Future<Result<MasterRating>> getMasterRating(String masterId);
}
