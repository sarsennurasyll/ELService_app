import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../shared/widgets/cards/app_card.dart';

final class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.space20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'ADMIN CONSOLE',
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.mutedForeground,
            ),
          ),
          const SizedBox(height: AppSpacing.space4),
          Text(
            'Overview',
            style: AppTextStyles.headlineLarge.copyWith(
              color: AppColors.foreground,
            ),
          ),
          const SizedBox(height: AppSpacing.space16),
          const _StatsGrid(),
          const SizedBox(height: AppSpacing.space16),
          const _WeeklyOrdersChart(),
          const SizedBox(height: AppSpacing.space16),
          const _SectionTitle(title: 'Active Orders'),
          const SizedBox(height: AppSpacing.space8),
          for (final order in _activeOrders) ...[
            _ActiveOrderCard(order: order),
            if (order != _activeOrders.last)
              const SizedBox(height: AppSpacing.space8),
          ],
          const SizedBox(height: AppSpacing.space16),
          const _SectionTitle(title: 'Quick Actions'),
          const SizedBox(height: AppSpacing.space8),
          for (final action in _quickActions) ...[
            _QuickActionCard(action: action),
            if (action != _quickActions.last)
              const SizedBox(height: AppSpacing.space8),
          ],
          const SizedBox(height: AppSpacing.space16),
          const _SectionTitle(title: 'Recent Events'),
          const SizedBox(height: AppSpacing.space8),
          for (final event in _recentEvents) ...[
            _RecentEventCard(event: event),
            if (event != _recentEvents.last)
              const SizedBox(height: AppSpacing.space8),
          ],
        ],
      ),
    );
  }
}

final class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: AppTextStyles.labelMedium.copyWith(
        color: AppColors.mutedForeground,
      ),
    );
  }
}

final class _StatsGrid extends StatelessWidget {
  const _StatsGrid();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _StatCard(stat: _stats[0])),
            const SizedBox(width: AppSpacing.space12),
            Expanded(child: _StatCard(stat: _stats[1])),
          ],
        ),
        const SizedBox(height: AppSpacing.space12),
        Row(
          children: [
            Expanded(child: _StatCard(stat: _stats[2])),
            const SizedBox(width: AppSpacing.space12),
            Expanded(child: _StatCard(stat: _stats[3])),
          ],
        ),
      ],
    );
  }
}

final class _StatCard extends StatelessWidget {
  const _StatCard({required this.stat});

  final _StatItem stat;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(stat.icon, size: AppSpacing.space20, color: AppColors.primary),
              Text(
                stat.delta,
                style: AppTextStyles.labelSmall.copyWith(color: stat.deltaColor),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space8),
          Text(
            stat.value,
            style: AppTextStyles.headlineLarge.copyWith(
              color: AppColors.foreground,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: AppSpacing.space4),
          Text(
            stat.label.toUpperCase(),
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}

final class _WeeklyOrdersChart extends StatelessWidget {
  const _WeeklyOrdersChart();

  static const _heights = [0.40, 0.55, 0.30, 0.75, 0.60, 0.90, 0.82];
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
                'ORDERS THIS WEEK',
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
          const SizedBox(height: AppSpacing.space12),
          SizedBox(
            height: AppSpacing.space96 + AppSpacing.space16,
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

final class _ActiveOrderCard extends StatelessWidget {
  const _ActiveOrderCard({required this.order});

  final _ActiveOrder order;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () {
        // TODO: открыть заказ.
      },
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '#${order.id}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.foreground,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.space4),
                Text(
                  '${order.customer} → ${order.technician}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.mutedForeground,
                  ),
                ),
              ],
            ),
          ),
          Text(
            order.price,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.foreground,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

final class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({required this.action});

  final _QuickAction action;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () {
        // TODO: открыть раздел.
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
                action.icon,
                size: AppSpacing.space20,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.space12),
          Expanded(
            child: Text(
              action.label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.foreground,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (action.count case final count?)
            Text(
              count,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.mutedForeground,
                fontWeight: FontWeight.w700,
              ),
            ),
          const SizedBox(width: AppSpacing.space8),
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

final class _RecentEventCard extends StatelessWidget {
  const _RecentEventCard({required this.event});

  final _RecentEvent event;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.space12),
      onTap: () {
        // TODO: открыть событие.
      },
      child: Row(
        children: [
          SizedBox(
            width: AppSpacing.space36,
            height: AppSpacing.space36,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: event.color.withValues(alpha: AppColors.primary10.a),
                borderRadius: BorderRadius.circular(AppRadius.large),
              ),
              child: Icon(
                event.icon,
                size: AppSpacing.space16,
                color: event.color,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.space12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.foreground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.space4),
                Text(
                  event.subtitle,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.mutedForeground,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
          ),
          Text(
            event.time,
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

final class _StatItem {
  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.delta,
    required this.deltaColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final String delta;
  final Color deltaColor;
}

final class _ActiveOrder {
  const _ActiveOrder({
    required this.id,
    required this.customer,
    required this.technician,
    required this.price,
  });

  final String id;
  final String customer;
  final String technician;
  final String price;
}

final class _QuickAction {
  const _QuickAction({
    required this.icon,
    required this.label,
    this.count,
  });

  final IconData icon;
  final String label;
  final String? count;
}

final class _RecentEvent {
  const _RecentEvent({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.time,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final String time;
}

const _stats = [
  _StatItem(
    icon: Icons.attach_money,
    label: 'Revenue',
    value: '8.4M ₸',
    delta: '+18%',
    deltaColor: AppColors.success,
  ),
  _StatItem(
    icon: Icons.build_outlined,
    label: 'Orders today',
    value: '342',
    delta: '+12%',
    deltaColor: AppColors.success,
  ),
  _StatItem(
    icon: Icons.people_outline,
    label: 'Active users',
    value: '12.8k',
    delta: '+4%',
    deltaColor: AppColors.success,
  ),
  _StatItem(
    icon: Icons.warning_amber_outlined,
    label: 'Open disputes',
    value: '7',
    delta: '-2',
    deltaColor: AppColors.error,
  ),
];

const _activeOrders = [
  _ActiveOrder(
    id: 'ELS-8241',
    customer: 'Aigerim B.',
    technician: 'Dmitry V.',
    price: '18 500 ₸',
  ),
  _ActiveOrder(
    id: 'ELS-8237',
    customer: 'Yerlan D.',
    technician: 'Dmitry V.',
    price: '12 000 ₸',
  ),
];

const _quickActions = [
  _QuickAction(icon: Icons.build_outlined, label: 'Orders', count: '342'),
  _QuickAction(icon: Icons.people_outline, label: 'Customers', count: '12,800'),
  _QuickAction(icon: Icons.engineering_outlined, label: 'Technicians', count: '486'),
  _QuickAction(icon: Icons.warning_amber_outlined, label: 'Disputes', count: '7'),
  _QuickAction(icon: Icons.category_outlined, label: 'Categories', count: '12'),
  _QuickAction(icon: Icons.payments_outlined, label: 'Payments'),
  _QuickAction(icon: Icons.assessment_outlined, label: 'Reports'),
  _QuickAction(icon: Icons.analytics_outlined, label: 'Analytics'),
];

const _recentEvents = [
  _RecentEvent(
    icon: Icons.warning_amber_outlined,
    color: AppColors.error,
    title: 'New dispute opened',
    subtitle: '#ELS-8237 · Yerlan D. vs Dmitry V.',
    time: '2m',
  ),
  _RecentEvent(
    icon: Icons.check_circle_outline,
    color: AppColors.success,
    title: 'Order completed',
    subtitle: '#ELS-8240 · 22 000 ₸',
    time: '14m',
  ),
  _RecentEvent(
    icon: Icons.person_add_alt_1_outlined,
    color: AppColors.primary,
    title: 'Technician verified',
    subtitle: 'Bauyrzhan Khan · Almaty',
    time: '1h',
  ),
];
