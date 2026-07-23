final class MasterRatingDto {
  const MasterRatingDto({
    required this.masterId,
    required this.averageRating,
    required this.reviewsCount,
  });

  final String masterId;
  final double averageRating;
  final int reviewsCount;

  factory MasterRatingDto.fromMap(Map<String, dynamic> map) {
    final masterId = map['masterId'];
    final averageRating = map['averageRating'];
    final reviewsCount = map['reviewsCount'];

    if (masterId is! String || reviewsCount is! int) {
      throw const FormatException('Некорректные данные рейтинга');
    }

    return MasterRatingDto(
      masterId: masterId,
      averageRating: switch (averageRating) {
        num value => value.toDouble(),
        _ => 0,
      },
      reviewsCount: reviewsCount,
    );
  }
}
