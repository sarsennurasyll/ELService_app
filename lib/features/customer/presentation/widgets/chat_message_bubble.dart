import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_duration.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../domain/models/message.dart';

final class ChatMessageBubble extends StatelessWidget {
  const ChatMessageBubble({
    required this.message,
    required this.isMine,
    required this.isGroupedWithPrevious,
    required this.showAvatar,
    super.key,
  });

  final Message message;
  final bool isMine;
  final bool isGroupedWithPrevious;
  final bool showAvatar;

  @override
  Widget build(BuildContext context) {
    final bubble = ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.sizeOf(context).width * 0.76,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: isMine ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(AppRadius.card),
            topRight: const Radius.circular(AppRadius.card),
            bottomLeft: Radius.circular(
              isMine || isGroupedWithPrevious ? AppRadius.card : AppRadius.small,
            ),
            bottomRight: Radius.circular(
              isMine && !isGroupedWithPrevious ? AppRadius.small : AppRadius.card,
            ),
          ),
          border: isMine ? null : Border.all(color: AppColors.border),
          boxShadow: isMine ? AppShadows.primary : AppShadows.sm,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.space12,
            AppSpacing.space8,
            AppSpacing.space8,
            AppSpacing.space8,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                message.text,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isMine ? AppColors.surface : AppColors.foreground,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: AppSpacing.space4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _timeLabel(message.createdAt),
                    style: AppTextStyles.labelSmall.copyWith(
                      color: isMine
                          ? AppColors.surface.withValues(alpha: AppColors.primary80.a)
                          : AppColors.mutedForeground,
                      letterSpacing: 0,
                    ),
                  ),
                  if (isMine) ...[
                    const SizedBox(width: AppSpacing.space4),
                    _DeliveryStatusIcon(status: message.deliveryStatus),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );

    return AnimatedSlide(
      offset: const Offset(0, 0.04),
      duration: AppDuration.dialog,
      curve: Curves.easeOut,
      child: AnimatedOpacity(
        opacity: 1,
        duration: AppDuration.dialog,
        child: Padding(
          padding: EdgeInsets.only(
            top: isGroupedWithPrevious ? AppSpacing.space4 : AppSpacing.space12,
            bottom: showAvatar ? AppSpacing.space4 : 0,
          ),
          child: Row(
            mainAxisAlignment: isMine
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isMine)
                SizedBox(
                  width: AppSpacing.space32,
                  child: showAvatar
                      ? const _ChatAvatar()
                      : const SizedBox.shrink(),
                ),
              if (!isMine) const SizedBox(width: AppSpacing.space8),
              bubble,
            ],
          ),
        ),
      ),
    );
  }

  String _timeLabel(DateTime value) {
    final local = value.toLocal();
    return '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
  }
}

final class _ChatAvatar extends StatelessWidget {
  const _ChatAvatar();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSpacing.space32,
      height: AppSpacing.space32,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.primary10,
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        child: const Icon(
          Icons.person_outline,
          color: AppColors.primary,
          size: AppSpacing.space16,
        ),
      ),
    );
  }
}

final class _DeliveryStatusIcon extends StatelessWidget {
  const _DeliveryStatusIcon({required this.status});

  final MessageDeliveryStatus status;

  @override
  Widget build(BuildContext context) {
    final color = status == MessageDeliveryStatus.read
        ? AppColors.secondary
        : AppColors.surface.withValues(alpha: AppColors.primary80.a);

    return switch (status) {
      MessageDeliveryStatus.sending => SizedBox(
        width: AppSpacing.space12,
        height: AppSpacing.space12,
        child: CircularProgressIndicator(strokeWidth: 1.5, color: color),
      ),
      MessageDeliveryStatus.sent => Icon(Icons.check, size: AppSpacing.space16, color: color),
      MessageDeliveryStatus.delivered || MessageDeliveryStatus.read => Icon(
        Icons.done_all,
        size: AppSpacing.space16,
        color: color,
      ),
    };
  }
}
