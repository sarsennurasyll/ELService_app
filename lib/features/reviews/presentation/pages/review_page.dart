import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/utils/result.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../../../shared/widgets/inputs/app_text_field.dart';
import '../../../../shared/widgets/layout/app_top_bar.dart';
import '../../../../shared/widgets/layout/screen.dart';
import '../../domain/models/review.dart';
import '../../domain/repositories/review_repository.dart';

final class ReviewPage extends StatefulWidget {
  const ReviewPage({
    required this.orderId,
    required this.reviewRepository,
    super.key,
  });

  final String orderId;
  final ReviewRepository reviewRepository;

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

final class _ReviewPageState extends State<ReviewPage> {
  final _commentController = TextEditingController();
  var _rating = 5;
  var _isSubmitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitReview() async {
    setState(() {
      _isSubmitting = true;
    });

    final comment = _commentController.text.trim();
    final result = await widget.reviewRepository.createReview(
      orderId: widget.orderId,
      rating: _rating,
      comment: comment.isEmpty ? null : comment,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _isSubmitting = false;
    });

    switch (result) {
      case Success<Review>():
        context.pop();
      case ErrorResult<Review>():
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result.failure.message)),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Screen(
      appBar: AppTopBar(
        title: 'Rate technician',
        subtitle: widget.orderId,
        onBack: () => context.pop(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'How was the repair?',
            style: AppTextStyles.headlineMedium.copyWith(
              color: AppColors.foreground,
            ),
          ),
          const SizedBox(height: AppSpacing.space8),
          Text(
            'Your review helps other customers choose a technician.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.mutedForeground,
            ),
          ),
          const SizedBox(height: AppSpacing.space24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var index = 1; index <= 5; index++)
                IconButton(
                  onPressed: () => setState(() => _rating = index),
                  icon: Icon(
                    index <= _rating ? Icons.star : Icons.star_border,
                    color: AppColors.warning,
                    size: AppSpacing.space32,
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.space24),
          AppTextField(
            controller: _commentController,
            label: 'COMMENT',
            hint: 'Describe your experience',
            isMultiline: true,
          ),
          const Spacer(),
          PrimaryButton(
            label: 'Send review',
            isLoading: _isSubmitting,
            onPressed: _submitReview,
          ),
        ],
      ),
    );
  }
}
