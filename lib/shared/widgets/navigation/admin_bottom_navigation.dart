import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';

final class AdminBottomNavigation extends StatelessWidget {
  const AdminBottomNavigation({
    required this.currentIndex,
    required this.onDestinationSelected,
    super.key,
  });

  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            top: AppSpacing.space8,
            bottom: AppSpacing.space16,
            left: AppSpacing.space8,
            right: AppSpacing.space8,
          ),
          child: Row(
            children: [
              _NavigationItem(
                index: 0,
                label: 'Dashboard',
                icon: Icons.dashboard_outlined,
                selectedIcon: Icons.dashboard,
                currentIndex: currentIndex,
                onDestinationSelected: onDestinationSelected,
              ),
              _NavigationItem(
                index: 1,
                label: 'Orders',
                icon: Icons.list_alt_outlined,
                selectedIcon: Icons.list_alt,
                currentIndex: currentIndex,
                onDestinationSelected: onDestinationSelected,
              ),
              _NavigationItem(
                index: 2,
                label: 'Users',
                icon: Icons.group_outlined,
                selectedIcon: Icons.group,
                currentIndex: currentIndex,
                onDestinationSelected: onDestinationSelected,
              ),
              _NavigationItem(
                index: 3,
                label: 'Analytics',
                icon: Icons.bar_chart_outlined,
                selectedIcon: Icons.bar_chart,
                currentIndex: currentIndex,
                onDestinationSelected: onDestinationSelected,
              ),
              _NavigationItem(
                index: 4,
                label: 'Settings',
                icon: Icons.settings_outlined,
                selectedIcon: Icons.settings,
                currentIndex: currentIndex,
                onDestinationSelected: onDestinationSelected,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _NavigationItem extends StatelessWidget {
  const _NavigationItem({
    required this.index,
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.currentIndex,
    required this.onDestinationSelected,
  });

  final int index;
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final isSelected = currentIndex == index;
    final color = isSelected ? AppColors.primary : AppColors.mutedForeground;

    return Expanded(
      child: GestureDetector(
        onTap: () => onDestinationSelected(index),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.space4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSelected ? selectedIcon : icon,
                size: AppSpacing.space20,
                color: color,
              ),
              const SizedBox(height: AppSpacing.space4),
              Text(
                label,
                style: AppTextStyles.labelSmall.copyWith(color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
