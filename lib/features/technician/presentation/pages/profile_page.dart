import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/storage/token_storage.dart';
import '../../../../core/utils/result.dart';
import '../../../../features/reviews/domain/models/master_rating.dart';
import '../../../../features/reviews/domain/models/review.dart';
import '../../../../features/reviews/domain/repositories/review_repository.dart';
import '../../../../shared/widgets/cards/app_card.dart';

final class ProfilePage extends StatefulWidget {
  const ProfilePage({
    required this.reviewRepository,
    required this.tokenStorage,
    super.key,
  });

  final ReviewRepository reviewRepository;
  final TokenStorage tokenStorage;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

final class _ProfilePageState extends State<ProfilePage> {
  late Future<_ProfileReviewsState> _reviewsFuture;

  @override
  void initState() {
    super.initState();
    _reviewsFuture = _loadReviews();
  }

  Future<_ProfileReviewsState> _loadReviews() async {
    final masterId = await _currentMasterId();
    if (masterId == null) {
      return const _ProfileReviewsState(
        rating: ErrorResult(Failure(message: 'Не удалось определить мастера')),
        reviews: ErrorResult(Failure(message: 'Не удалось определить мастера')),
      );
    }

    final rating = await widget.reviewRepository.getMasterRating(masterId);
    final reviews = await widget.reviewRepository.getMasterReviews(masterId);
    return _ProfileReviewsState(rating: rating, reviews: reviews);
  }

  Future<String?> _currentMasterId() async {
    final session = await widget.tokenStorage.getSession();
    if (session == null) {
      return null;
    }

    try {
      final json = jsonDecode(session);
      final user = json is Map ? json['user'] : null;
      final id = user is Map ? user['id'] : null;
      return id is String && id.isNotEmpty ? id : null;
    } on FormatException {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_ProfileReviewsState>(
      future: _reviewsFuture,
      builder: (context, snapshot) {
        final state = snapshot.data;
        final rating = state?.rating;
        final reviews = state?.reviews;
        final ratingValue = rating is Success<MasterRating>
            ? rating.value.averageRating
            : 0.0;
        final reviewsCount = rating is Success<MasterRating>
            ? rating.value.reviewsCount
            : 0;
        final reviewItems = reviews is Success<List<Review>>
            ? reviews.value
            : const <Review>[];

        return SingleChildScrollView(
          child: Column(
            children: [
              _ProfileHeader(
                rating: ratingValue,
                reviewsCount: reviewsCount,
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.space20),
                child: Column(
                  children: [
                    _ReviewsPreview(
                      isLoading:
                          snapshot.connectionState == ConnectionState.waiting,
                      rating: ratingValue,
                      reviewsCount: reviewsCount,
                      reviews: reviewItems,
                    ),
                    const SizedBox(height: AppSpacing.space16),
                    for (final item in _profileMenuItems) ...[
                      _ProfileMenuItem(item: item),
                      if (item != _profileMenuItems.last)
                        const SizedBox(height: AppSpacing.space8),
                    ],
                    const SizedBox(height: AppSpacing.space8),
                    const _LogOutItem(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

final class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.rating,
    required this.reviewsCount,
  });

  final double rating;
  final int reviewsCount;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.primary, AppColors.primary80],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.space20,
          AppSpacing.space32,
          AppSpacing.space20,
          AppSpacing.space32,
        ),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: AppSpacing.space64,
                  height: AppSpacing.space64,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.surface.withValues(
                        alpha: AppColors.primary20.a,
                      ),
                      borderRadius: BorderRadius.circular(AppRadius.card),
                      border: Border.all(
                        color: AppColors.surface.withValues(
                          alpha: AppColors.primary30.a,
                        ),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'DV',
                        style: AppTextStyles.titleLarge.copyWith(
                          color: AppColors.surface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.space16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dmitry Volkov',
                        style: AppTextStyles.headlineMedium.copyWith(
                          color: AppColors.surface,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.space4),
                      Text(
                        'Electronics Master · Verified',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.surface.withValues(
                            alpha: AppColors.primary80.a,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.space20),
            _ProfileStatistics(rating: rating, reviewsCount: reviewsCount),
          ],
        ),
      ),
    );
  }
}

final class _ProfileStatistics extends StatelessWidget {
  const _ProfileStatistics({
    required this.rating,
    required this.reviewsCount,
  });

  final double rating;
  final int reviewsCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatisticCard(label: 'RATING', value: _ratingText(rating)),
        ),
        const SizedBox(width: AppSpacing.space8),
        Expanded(
          child: _StatisticCard(label: 'REVIEWS', value: '$reviewsCount'),
        ),
        const SizedBox(width: AppSpacing.space8),
        const Expanded(child: _StatisticCard(label: 'ACCEPT', value: '98%')),
      ],
    );
  }
}

final class _StatisticCard extends StatelessWidget {
  const _StatisticCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: AppColors.primary10.a),
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.space12),
        child: Column(
          children: [
            Text(
              value,
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.surface,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: AppSpacing.space4),
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.surface.withValues(
                  alpha: AppColors.primary80.a,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _ReviewsPreview extends StatelessWidget {
  const _ReviewsPreview({
    required this.isLoading,
    required this.rating,
    required this.reviewsCount,
    required this.reviews,
  });

  final bool isLoading;
  final double rating;
  final int reviewsCount;
  final List<Review> reviews;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                _ratingText(rating),
                style: AppTextStyles.displayMedium.copyWith(
                  color: AppColors.foreground,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(width: AppSpacing.space12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        for (var index = 1; index <= 5; index++)
                          Icon(
                            index <= rating.round()
                                ? Icons.star
                                : Icons.star_border,
                            size: AppSpacing.space12,
                            color: AppColors.warning,
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.space4),
                    Text(
                      '$reviewsCount reviews',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.mutedForeground,
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space16),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          else if (reviews.isEmpty)
            Text(
              'Reviews will appear here after completed orders.',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.mutedForeground,
              ),
            )
          else
            for (final review in reviews.take(3)) ...[
              _ReviewSnippet(review: review),
              if (review != reviews.take(3).last)
                const SizedBox(height: AppSpacing.space12),
            ],
        ],
      ),
    );
  }
}

final class _ReviewSnippet extends StatelessWidget {
  const _ReviewSnippet({required this.review});

  final Review review;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: AppSpacing.space36,
          height: AppSpacing.space36,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.primary10,
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: Center(
              child: Text(
                _initials(review.customerName),
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.space12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      review.customerName ?? 'Customer',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.foreground,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    '${review.rating}/5',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.warning,
                      letterSpacing: 0,
                    ),
                  ),
                ],
              ),
              if (review.comment case final comment?) ...[
                const SizedBox(height: AppSpacing.space4),
                Text(
                  comment,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.mutedForeground,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

final class _ProfileMenuItem extends StatelessWidget {
  const _ProfileMenuItem({required this.item});

  final _ProfileMenuItemData item;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () {
        // TODO: открыть раздел профиля.
      },
      child: Row(
        children: [
          SizedBox(
            width: AppSpacing.space40,
            height: AppSpacing.space40,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.primary10,
                borderRadius: BorderRadius.circular(AppRadius.large),
              ),
              child: Icon(
                item.icon,
                size: AppSpacing.space20,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.space12),
          Expanded(
            child: Text(
              item.label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.foreground,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Icon(
            Icons.chevron_right,
            size: AppSpacing.space16,
            color: AppColors.mutedForeground,
          ),
        ],
      ),
    );
  }
}

final class _LogOutItem extends StatelessWidget {
  const _LogOutItem();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () {
        // TODO: подключить выход из аккаунта.
      },
      child: Row(
        children: [
          SizedBox(
            width: AppSpacing.space40,
            height: AppSpacing.space40,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: AppColors.primary10.a),
                borderRadius: BorderRadius.circular(AppRadius.large),
              ),
              child: const Icon(
                Icons.logout,
                size: AppSpacing.space20,
                color: AppColors.error,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.space12),
          Expanded(
            child: Text(
              'Log out',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final class _ProfileReviewsState {
  const _ProfileReviewsState({
    required this.rating,
    required this.reviews,
  });

  final Result<MasterRating> rating;
  final Result<List<Review>> reviews;
}

final class _ProfileMenuItemData {
  const _ProfileMenuItemData({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

const _profileMenuItems = [
  _ProfileMenuItemData(icon: Icons.star_outline, label: 'Reviews'),
  _ProfileMenuItemData(icon: Icons.bar_chart_outlined, label: 'Statistics'),
  _ProfileMenuItemData(icon: Icons.calendar_today_outlined, label: 'Schedule'),
  _ProfileMenuItemData(icon: Icons.location_on_outlined, label: 'Service area'),
  _ProfileMenuItemData(icon: Icons.workspace_premium_outlined, label: 'Certifications'),
  _ProfileMenuItemData(icon: Icons.settings_outlined, label: 'Settings'),
  _ProfileMenuItemData(icon: Icons.help_outline, label: 'Help'),
];

String _ratingText(double rating) {
  return rating == 0 ? '0.0' : rating.toStringAsFixed(1);
}

String _initials(String? name) {
  final parts = name?.trim().split(RegExp(r'\s+')) ?? const <String>[];
  if (parts.isEmpty || parts.first.isEmpty) {
    return 'CU';
  }
  if (parts.length == 1) {
    return parts.first.substring(0, 1).toUpperCase();
  }
  return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
}
