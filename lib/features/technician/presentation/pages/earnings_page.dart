import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../shared/widgets/cards/app_card.dart';

final class EarningsPage extends StatelessWidget {
  const EarningsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.space20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Earnings',
            style: AppTextStyles.headlineLarge.copyWith(
              color: AppColors.foreground,
            ),
          ),
          const SizedBox(height: AppSpacing.space16),
          const _BalanceBanner(),
          const SizedBox(height: AppSpacing.space16),
          const _PeriodStatsRow(),
          const SizedBox(height: AppSpacing.space24),
          const _WeeklyChartCard(),
          const SizedBox(height: AppSpacing.space24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'RECENT ACTIVITY',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.mutedForeground,
                ),
              ),
              const Icon(
                Icons.trending_up,
                size: AppSpacing.space16,
                color: AppColors.success,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space8),
          const _TransactionsList(),
        ],
      ),
    );
  }
}

final class _BalanceBanner extends StatelessWidget {
  const _BalanceBanner();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.secondary],
        ),
        borderRadius: BorderRadius.circular(AppRadius.extraLarge),
        boxShadow: AppShadows.xl,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.space20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AVAILABLE BALANCE',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.surface.withValues(
                            alpha: AppColors.primary80.a,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.space4),
                      Text(
                        '128 400 ₸',
                        style: AppTextStyles.displayMedium.copyWith(
                          color: AppColors.surface,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.account_balance_wallet_outlined,
                  size: AppSpacing.space24,
                  color: AppColors.surface.withValues(
                    alpha: AppColors.primary80.a,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.space16),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      // TODO: открыть вывод средств.
                    },
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppRadius.large),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.space12,
                        ),
                        child: Text(
                          'Withdraw',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.labelLarge.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.space8),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      // TODO: открыть детали кошелька.
                    },
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.surface.withValues(
                          alpha: AppColors.primary20.a,
                        ),
                        borderRadius: BorderRadius.circular(AppRadius.large),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.space12,
                        ),
                        child: Text(
                          'Details',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.labelLarge.copyWith(
                            color: AppColors.surface,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

final class _PeriodStatsRow extends StatelessWidget {
  const _PeriodStatsRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: _PeriodStatCard(value: '84 200 ₸', label: 'This week'),
        ),
        SizedBox(width: AppSpacing.space8),
        Expanded(
          child: _PeriodStatCard(value: '348 900 ₸', label: 'This month'),
        ),
        SizedBox(width: AppSpacing.space8),
        Expanded(
          child: _PeriodStatCard(value: '17 400 ₸', label: 'Avg / job'),
        ),
      ],
    );
  }
}

final class _PeriodStatCard extends StatelessWidget {
  const _PeriodStatCard({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.space12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.foreground,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: AppSpacing.space4),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.mutedForeground,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }
}

final class _WeeklyChartCard extends StatelessWidget {
  const _WeeklyChartCard();

  static const _heights = [0.40, 0.60, 0.30, 0.85, 0.50, 0.70, 0.95];
  static const _labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'THIS WEEK',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.mutedForeground,
                ),
              ),
              const Icon(
                Icons.bar_chart,
                size: AppSpacing.space16,
                color: AppColors.primary,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space12),
          SizedBox(
            height: AppSpacing.space96 + AppSpacing.space32,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var index = 0; index < _heights.length; index++) ...[
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: FractionallySizedBox(
                              heightFactor: _heights[index],
                              widthFactor: 1,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      AppColors.primary,
                                      AppColors.secondary,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(AppRadius.medium),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.space4),
                        Text(
                          _labels[index],
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.mutedForeground,
                            fontSize: 9,
                            letterSpacing: 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (index < _heights.length - 1)
                    const SizedBox(width: AppSpacing.space8),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

final class _TransactionsList extends StatelessWidget {
  const _TransactionsList();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (var index = 0; index < _transactions.length; index++) ...[
            _TransactionRow(transaction: _transactions[index]),
            if (index < _transactions.length - 1) const Divider(height: 1),
          ],
        ],
      ),
    );
  }
}

final class _TransactionRow extends StatelessWidget {
  const _TransactionRow({required this.transaction});

  final _Transaction transaction;

  @override
  Widget build(BuildContext context) {
    final accent = transaction.isPositive ? AppColors.success : AppColors.error;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.space16),
      child: Row(
        children: [
          SizedBox(
            width: AppSpacing.space36,
            height: AppSpacing.space36,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: accent.withValues(alpha: AppColors.primary10.a),
                borderRadius: BorderRadius.circular(AppRadius.large),
              ),
              child: Icon(
                transaction.isPositive
                    ? Icons.south_west
                    : Icons.north_east,
                size: AppSpacing.space16,
                color: accent,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.space12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.foreground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.space4),
                Text(
                  '${transaction.subtitle} · ${transaction.time}',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.mutedForeground,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
          ),
          Text(
            transaction.amount,
            style: AppTextStyles.bodyMedium.copyWith(
              color: transaction.isPositive
                  ? AppColors.success
                  : AppColors.foreground,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

final class _Transaction {
  const _Transaction({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.time,
    required this.isPositive,
  });

  final String title;
  final String subtitle;
  final String amount;
  final String time;
  final bool isPositive;
}

const _transactions = [
  _Transaction(
    title: 'Refrigerator repair',
    subtitle: 'Aigerim B.',
    amount: '+18 500 ₸',
    time: 'Today',
    isPositive: true,
  ),
  _Transaction(
    title: 'Washer diagnostic',
    subtitle: 'Nurlan T.',
    amount: '+8 000 ₸',
    time: 'Today',
    isPositive: true,
  ),
  _Transaction(
    title: 'Withdraw to Kaspi',
    subtitle: '•• 4218',
    amount: '-40 000 ₸',
    time: 'Yesterday',
    isPositive: false,
  ),
  _Transaction(
    title: 'AC install',
    subtitle: 'Aida M.',
    amount: '+35 000 ₸',
    time: 'Mon',
    isPositive: true,
  ),
];
