import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../shared/widgets/cards/app_card.dart';

final class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const _ProfileHeader(),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.space20),
            child: Column(
              children: [
                for (final item in _profileMenuItems) ...[
                  _ProfileMenuItem(item: item),
                  if (item != _profileMenuItems.last)
                    const SizedBox(height: AppSpacing.space8),
                ],
                const SizedBox(height: AppSpacing.space8),
                const _LogOutItem(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

final class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.primary, AppColors.primary80],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.space20,
          AppSpacing.space32,
          AppSpacing.space20,
          AppSpacing.space32,
        ),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: AppSpacing.space64,
                  height: AppSpacing.space64,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.surface.withValues(
                        alpha: AppColors.primary20.a,
                      ),
                      borderRadius: BorderRadius.circular(AppRadius.card),
                      border: Border.all(
                        color: AppColors.surface.withValues(
                          alpha: AppColors.primary30.a,
                        ),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'AB',
                        style: AppTextStyles.titleLarge.copyWith(
                          color: AppColors.surface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.space16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Aigerim Bekova',
                        style: AppTextStyles.headlineMedium.copyWith(
                          color: AppColors.surface,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.space4),
                      Text(
                        'aigerim@example.com',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.surface.withValues(
                            alpha: AppColors.primary80.a,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // TODO: открыть редактирование профиля.
                  },
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.surface.withValues(
                        alpha: AppColors.primary20.a,
                      ),
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.space12,
                        vertical: AppSpacing.space4,
                      ),
                      child: Text(
                        'Edit',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.surface,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.space20),
            const _ProfileStatistics(),
          ],
        ),
      ),
    );
  }
}

final class _ProfileStatistics extends StatelessWidget {
  const _ProfileStatistics();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: _StatisticCard(label: 'ORDERS', value: '12'),
        ),
        SizedBox(width: AppSpacing.space8),
        Expanded(
          child: _StatisticCard(label: 'RATING', value: '4.9'),
        ),
        SizedBox(width: AppSpacing.space8),
        Expanded(
          child: _StatisticCard(label: 'BONUS', value: '₸5k'),
        ),
      ],
    );
  }
}

final class _StatisticCard extends StatelessWidget {
  const _StatisticCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: AppColors.primary10.a),
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.space12),
        child: Column(
          children: [
            Text(
              value,
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.surface,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: AppSpacing.space4),
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.surface.withValues(
                  alpha: AppColors.primary80.a,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _ProfileMenuItem extends StatelessWidget {
  const _ProfileMenuItem({required this.item});

  final _ProfileMenuItemData item;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () {
        // TODO: открыть раздел профиля.
      },
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
            child: Text(
              item.label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.foreground,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Icon(
            Icons.chevron_right,
            size: AppSpacing.space16,
            color: AppColors.mutedForeground,
          ),
        ],
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

final class _ProfileMenuItemData {
  const _ProfileMenuItemData({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

const _profileMenuItems = [
  _ProfileMenuItemData(icon: Icons.favorite_border, label: 'Favorites'),
  _ProfileMenuItemData(
    icon: Icons.location_on_outlined,
    label: 'Saved addresses',
  ),
  _ProfileMenuItemData(
    icon: Icons.credit_card_outlined,
    label: 'Payment methods',
  ),
  _ProfileMenuItemData(
    icon: Icons.account_balance_wallet_outlined,
    label: 'Promo codes',
  ),
  _ProfileMenuItemData(icon: Icons.settings_outlined, label: 'Settings'),
  _ProfileMenuItemData(icon: Icons.help_outline, label: 'Help center'),
];
