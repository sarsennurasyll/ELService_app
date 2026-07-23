import '../../../../core/errors/api_exception.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/network_exception.dart';
import '../../../../core/utils/result.dart';
import '../../domain/models/master_rating.dart';
import '../../domain/models/review.dart';
import '../../domain/repositories/review_repository.dart';
import '../datasources/review_remote_datasource.dart';
import '../mappers/master_rating_mapper.dart';
import '../mappers/review_mapper.dart';

final class ReviewRepositoryImpl implements ReviewRepository {
  const ReviewRepositoryImpl({
    required ReviewRemoteDataSource remoteDataSource,
    this.reviewMapper = const ReviewMapper(),
    this.ratingMapper = const MasterRatingMapper(),
  }) : _remoteDataSource = remoteDataSource;

  final ReviewRemoteDataSource _remoteDataSource;
  final ReviewMapper reviewMapper;
  final MasterRatingMapper ratingMapper;

  @override
  Future<Result<Review>> createReview({
    required String orderId,
    required int rating,
    String? comment,
  }) async {
    try {
      final review = await _remoteDataSource.createReview(
        orderId: orderId,
        rating: rating,
        comment: comment,
      );
      return Success(reviewMapper.fromDto(review));
    } on Exception catch (error) {
      return ErrorResult(_mapFailure(error));
    }
  }

  @override
  Future<Result<List<Review>>> getMasterReviews(String masterId) async {
    try {
      final reviews = await _remoteDataSource.getMasterReviews(masterId);
      return Success(reviews.map(reviewMapper.fromDto).toList());
    } on Exception catch (error) {
      return ErrorResult(_mapFailure(error));
    }
  }

  @override
  Future<Result<MasterRating>> getMasterRating(String masterId) async {
    try {
      final rating = await _remoteDataSource.getMasterRating(masterId);
      return Success(ratingMapper.fromDto(rating));
    } on Exception catch (error) {
      return ErrorResult(_mapFailure(error));
    }
  }

  Failure _mapFailure(Exception error) {
    if (error is ApiException) {
      return Failure(
        message: error.message,
        code: error.code,
        statusCode: error.statusCode,
      );
    }
    if (error is NetworkException) {
      return Failure(message: error.message);
    }
    return Failure(message: error.toString());
  }
}
