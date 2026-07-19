import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';

final class CustomerBottomNavigation extends StatelessWidget {
  const CustomerBottomNavigation({
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
                label: 'Home',
                icon: Icons.home_outlined,
                selectedIcon: Icons.home,
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
                label: 'Chat',
                icon: Icons.chat_bubble_outline,
                selectedIcon: Icons.chat_bubble,
                currentIndex: currentIndex,
                onDestinationSelected: onDestinationSelected,
              ),
              _NavigationItem(
                index: 3,
                label: 'Profile',
                icon: Icons.person_outline,
                selectedIcon: Icons.person,
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
