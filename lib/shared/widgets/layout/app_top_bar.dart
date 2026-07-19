import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';

final class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({
    required this.title,
    super.key,
    this.subtitle,
    this.onBack,
    this.rightAction,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onBack;
  final Widget? rightAction;

  @override
  Size get preferredSize =>
      Size.fromHeight(AppSpacing.space36 + AppSpacing.space24);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.foreground,
      toolbarHeight: AppSpacing.space36 + AppSpacing.space24,
      titleSpacing: AppSpacing.space20,
      leadingWidth: AppSpacing.space56,
      leading: onBack == null
          ? null
          : Padding(
              padding: const EdgeInsets.only(left: AppSpacing.space20),
              child: GestureDetector(
                onTap: onBack,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.large),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Center(child: Icon(Icons.arrow_back)),
                ),
              ),
            ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.foreground,
            ),
          ),
          if (subtitle case final subtitle?)
            Text(
              subtitle,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.mutedForeground,
                fontSize: AppTextStyles.labelMedium.fontSize,
              ),
            ),
        ],
      ),
      actions: rightAction == null
          ? null
          : [
              Padding(
                padding: const EdgeInsets.only(right: AppSpacing.space20),
                child: rightAction,
              ),
            ],
    );
  }
}
