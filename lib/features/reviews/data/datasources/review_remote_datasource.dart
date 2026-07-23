import '../../../../core/errors/api_exception.dart';
import '../../../../core/network/api_client.dart';
import '../models/master_rating_dto.dart';
import '../models/review_dto.dart';

abstract interface class ReviewRemoteDataSource {
  Future<ReviewDto> createReview({
    required String orderId,
    required int rating,
    String? comment,
  });

  Future<List<ReviewDto>> getMasterReviews(String masterId);

  Future<MasterRatingDto> getMasterRating(String masterId);
}

final class ReviewRemoteDataSourceImpl implements ReviewRemoteDataSource {
  const ReviewRemoteDataSourceImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<ReviewDto> createReview({
    required String orderId,
    required int rating,
    String? comment,
  }) async {
    final response = await _apiClient.post(
      '/reviews',
      body: ReviewDto.toCreateMap(
        orderId: orderId,
        rating: rating,
        comment: comment,
      ),
    );
    return _reviewFromJson(response['data']);
  }

  @override
  Future<List<ReviewDto>> getMasterReviews(String masterId) async {
    final response = await _apiClient.get('/masters/$masterId/reviews');
    final data = response['data'];

    if (data is! List) {
      throw const ApiException(message: 'Некорректный ответ сервера');
    }

    return data.map(_reviewFromJson).toList();
  }

  @override
  Future<MasterRatingDto> getMasterRating(String masterId) async {
    final response = await _apiClient.get('/masters/$masterId/rating');
    final data = response['data'];

    if (data is! Map) {
      throw const ApiException(message: 'Некорректный ответ сервера');
    }

    return MasterRatingDto.fromMap(Map<String, dynamic>.from(data));
  }

  ReviewDto _reviewFromJson(dynamic json) {
    if (json is! Map) {
      throw const ApiException(message: 'Некорректный ответ сервера');
    }

    return ReviewDto.fromMap(Map<String, dynamic>.from(json));
  }
}
