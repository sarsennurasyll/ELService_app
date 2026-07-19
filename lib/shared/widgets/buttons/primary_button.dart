import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_shadows.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';

enum PrimaryButtonVariant { primary, outline, ghost }

final class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.label,
    super.key,
    this.onPressed,
    this.variant = PrimaryButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.isEnabled = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final PrimaryButtonVariant variant;
  final Widget? icon;
  final bool isLoading;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final effectiveOnPressed = isEnabled && !isLoading ? onPressed : null;

    return SizedBox(
      width: double.infinity,
      height: AppSpacing.space48,
      child: switch (variant) {
        PrimaryButtonVariant.primary => ElevatedButton(
          onPressed: effectiveOnPressed,
          style: _primaryStyle,
          child: _content,
        ),
        PrimaryButtonVariant.outline => OutlinedButton(
          onPressed: effectiveOnPressed,
          style: _outlineStyle,
          child: _content,
        ),
        PrimaryButtonVariant.ghost => TextButton(
          onPressed: effectiveOnPressed,
          style: _ghostStyle,
          child: _content,
        ),
      },
    );
  }

  Widget get _content {
    final foregroundColor = variant == PrimaryButtonVariant.primary
        ? AppColors.surface
        : AppColors.primary;

    if (isLoading) {
      return SizedBox(
        width: AppSpacing.space20,
        height: AppSpacing.space20,
        child: CircularProgressIndicator(color: foregroundColor),
      );
    }

    if (icon == null) {
      return Text(label);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon!,
        const SizedBox(width: AppSpacing.space8),
        Text(label),
      ],
    );
  }

  static final _primaryStyle = ButtonStyle(
    backgroundColor: const WidgetStatePropertyAll(AppColors.primary),
    foregroundColor: const WidgetStatePropertyAll(AppColors.surface),
    textStyle: const WidgetStatePropertyAll(AppTextStyles.labelLarge),
    shadowColor: WidgetStatePropertyAll(AppShadows.primary.first.color),
    shape: WidgetStatePropertyAll(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
    ),
  );

  static final _outlineStyle = ButtonStyle(
    backgroundColor: const WidgetStatePropertyAll(AppColors.surface),
    foregroundColor: const WidgetStatePropertyAll(AppColors.foreground),
    textStyle: const WidgetStatePropertyAll(AppTextStyles.labelLarge),
    side: const WidgetStatePropertyAll(BorderSide(color: AppColors.border)),
    shape: WidgetStatePropertyAll(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
    ),
  );

  static final _ghostStyle = ButtonStyle(
    foregroundColor: const WidgetStatePropertyAll(AppColors.primary),
    textStyle: const WidgetStatePropertyAll(AppTextStyles.labelLarge),
    shape: WidgetStatePropertyAll(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
    ),
  );
}
