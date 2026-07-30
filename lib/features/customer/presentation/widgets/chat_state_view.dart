import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';

final class ChatStateView extends StatelessWidget {
  const ChatStateView({
    required this.icon,
    required this.title,
    required this.message,
    super.key,
    this.onRetry,
  });

  const ChatStateView.loading({super.key})
    : icon = Icons.forum_outlined,
      title = 'Загружаем сообщения',
      message = 'Подождите немного',
      onRetry = null;

  final IconData icon;
  final String title;
  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.space40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: AppSpacing.space64,
              height: AppSpacing.space64,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.primary10,
                  borderRadius: BorderRadius.circular(AppRadius.card),
                ),
                child: Icon(icon, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: AppSpacing.space16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.foreground,
              ),
            ),
            const SizedBox(height: AppSpacing.space8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.mutedForeground,
              ),
            ),
            if (onRetry case final retry?) ...[
              const SizedBox(height: AppSpacing.space20),
              SizedBox(
                width: AppSpacing.space96 + AppSpacing.space32,
                child: PrimaryButton(
                  label: 'Повторить',
                  variant: PrimaryButtonVariant.outline,
                  onPressed: retry,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
