import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../shared/widgets/cards/app_card.dart';

final class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.space20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Settings',
            style: AppTextStyles.headlineLarge.copyWith(
              color: AppColors.foreground,
            ),
          ),
          const SizedBox(height: AppSpacing.space16),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (var index = 0; index < _settingsItems.length; index++) ...[
                  _SettingsRow(item: _settingsItems[index]),
                  if (index < _settingsItems.length - 1)
                    const Divider(height: 1),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.space8),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (var index = 0; index < _supportItems.length; index++) ...[
                  _SettingsRow(item: _supportItems[index]),
                  if (index < _supportItems.length - 1)
                    const Divider(height: 1),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.space8),
          const _LogOutItem(),
        ],
      ),
    );
  }
}

final class _SettingsRow extends StatelessWidget {
  const _SettingsRow({required this.item});

  final _SettingsItem item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: открыть настройку.
      },
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.space16),
        child: Row(
          children: [
            SizedBox(
              width: AppSpacing.space40,
              height: AppSpacing.space40,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.primary10,
                  borderRadius: BorderRadius.circular(AppRadius.large),
                ),
                child: Icon(
                  item.icon,
                  size: AppSpacing.space20,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.space12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.label,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.foreground,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (item.subtitle case final subtitle?) ...[
                    const SizedBox(height: AppSpacing.space4),
                    Text(
                      subtitle,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.mutedForeground,
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: AppSpacing.space16,
              color: AppColors.mutedForeground,
            ),
          ],
        ),
      ),
    );
  }
}

final class _LogOutItem extends StatelessWidget {
  const _LogOutItem();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () {
        // TODO: подключить выход из аккаунта.
      },
      child: Row(
        children: [
          SizedBox(
            width: AppSpacing.space40,
            height: AppSpacing.space40,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: AppColors.primary10.a),
                borderRadius: BorderRadius.circular(AppRadius.large),
              ),
              child: const Icon(
                Icons.logout,
                size: AppSpacing.space20,
                color: AppColors.error,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.space12),
          Expanded(
            child: Text(
              'Log out',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final class _SettingsItem {
  const _SettingsItem({
    required this.icon,
    required this.label,
    this.subtitle,
  });

  final IconData icon;
  final String label;
  final String? subtitle;
}

const _settingsItems = [
  _SettingsItem(
    icon: Icons.percent,
    label: 'Commission rate',
    subtitle: '15% platform fee',
  ),
  _SettingsItem(
    icon: Icons.shield_outlined,
    label: 'Verification rules',
    subtitle: '3 documents required',
  ),
  _SettingsItem(
    icon: Icons.public,
    label: 'Regions',
    subtitle: '4 cities active',
  ),
  _SettingsItem(
    icon: Icons.notifications_none_outlined,
    label: 'Notification templates',
  ),
  _SettingsItem(
    icon: Icons.groups_outlined,
    label: 'Team & permissions',
  ),
  _SettingsItem(
    icon: Icons.lock_outline,
    label: 'Security audit log',
  ),
];

const _supportItems = [
  _SettingsItem(
    icon: Icons.tune,
    label: 'App management',
    subtitle: 'Maintenance mode & versions',
  ),
  _SettingsItem(
    icon: Icons.campaign_outlined,
    label: 'Notifications',
    subtitle: 'Broadcasts & alerts',
  ),
  _SettingsItem(
    icon: Icons.help_outline,
    label: 'Support',
    subtitle: 'Help center & tickets',
  ),
];
