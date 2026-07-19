import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_shadows.dart';
import '../../../app/theme/app_spacing.dart';

enum AppCardVariant { standard, selectable, status }

enum AppCardStatus { info, success, warning, error }

final class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    super.key,
    this.variant = AppCardVariant.standard,
    this.status = AppCardStatus.info,
    this.isSelected = false,
    this.onTap,
    this.padding = const EdgeInsets.all(AppSpacing.space16),
  });

  final Widget child;
  final AppCardVariant variant;
  final AppCardStatus status;
  final bool isSelected;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final card = DecoratedBox(
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: _borderColor),
        boxShadow: _boxShadow,
      ),
      child: Padding(padding: padding, child: child),
    );

    if (onTap == null) {
      return card;
    }

    return GestureDetector(onTap: onTap, child: card);
  }

  Color get _backgroundColor {
    if (variant == AppCardVariant.selectable && isSelected) {
      return AppColors.primary5;
    }

    if (variant == AppCardVariant.status) {
      return AppColors.muted;
    }

    return AppColors.surface;
  }

  Color get _borderColor {
    if (variant == AppCardVariant.selectable && isSelected) {
      return AppColors.primary;
    }

    if (variant == AppCardVariant.status) {
      return switch (status) {
        AppCardStatus.info => AppColors.info,
        AppCardStatus.success => AppColors.success,
        AppCardStatus.warning => AppColors.warning,
        AppCardStatus.error => AppColors.error,
      };
    }

    return AppColors.border;
  }

  List<BoxShadow> get _boxShadow {
    if (variant == AppCardVariant.selectable && isSelected) {
      return AppShadows.selectedCard;
    }

    return const <BoxShadow>[];
  }
}
