import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';

final class CustomerBottomNavigation extends StatelessWidget {
  const CustomerBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final currentPath = GoRouterState.of(context).uri.path;

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
                path: AppRoutes.customerHome,
                label: 'Home',
                icon: Icons.home_outlined,
                selectedIcon: Icons.home,
                currentPath: currentPath,
              ),
              _NavigationItem(
                path: AppRoutes.customerOrders,
                label: 'Orders',
                icon: Icons.list_alt_outlined,
                selectedIcon: Icons.list_alt,
                currentPath: currentPath,
              ),
              _NavigationItem(
                path: AppRoutes.customerMessages,
                label: 'Chat',
                icon: Icons.chat_bubble_outline,
                selectedIcon: Icons.chat_bubble,
                currentPath: currentPath,
              ),
              _NavigationItem(
                path: AppRoutes.customerProfile,
                label: 'Profile',
                icon: Icons.person_outline,
                selectedIcon: Icons.person,
                currentPath: currentPath,
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
    required this.path,
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.currentPath,
  });

  final String path;
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final String currentPath;

  @override
  Widget build(BuildContext context) {
    final isSelected = currentPath == path;
    final color = isSelected ? AppColors.primary : AppColors.mutedForeground;

    return Expanded(
      child: GestureDetector(
        onTap: () => context.go(path),
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
