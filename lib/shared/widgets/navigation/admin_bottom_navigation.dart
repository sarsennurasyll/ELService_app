import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';

final class AdminBottomNavigation extends StatelessWidget {
  const AdminBottomNavigation({super.key});

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
                path: AppRoutes.adminDashboard,
                label: 'Overview',
                icon: Icons.dashboard_outlined,
                selectedIcon: Icons.dashboard,
                currentPath: currentPath,
              ),
              _NavigationItem(
                path: AppRoutes.adminOrders,
                label: 'Orders',
                icon: Icons.list_alt_outlined,
                selectedIcon: Icons.list_alt,
                currentPath: currentPath,
              ),
              _NavigationItem(
                path: AppRoutes.adminUsers,
                label: 'People',
                icon: Icons.group_outlined,
                selectedIcon: Icons.group,
                currentPath: currentPath,
              ),
              _NavigationItem(
                path: AppRoutes.adminAnalytics,
                label: 'Analytics',
                icon: Icons.bar_chart_outlined,
                selectedIcon: Icons.bar_chart,
                currentPath: currentPath,
              ),
              _NavigationItem(
                path: AppRoutes.adminSettings,
                label: 'Settings',
                icon: Icons.settings_outlined,
                selectedIcon: Icons.settings,
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
