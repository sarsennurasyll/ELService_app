import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/utils/result.dart';
import '../../../../shared/widgets/cards/app_card.dart';
import '../../../customer/domain/models/order.dart';
import '../../../customer/domain/models/user.dart';
import '../../../customer/domain/repositories/order_repository.dart';
import '../../../customer/domain/repositories/user_repository.dart';

final class DashboardPage extends StatefulWidget {
  const DashboardPage({
    required this.orderRepository,
    required this.userRepository,
    super.key,
  });

  final OrderRepository orderRepository;
  final UserRepository userRepository;

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

final class _DashboardPageState extends State<DashboardPage> {
  late final Future<Result<List<Order>>> _acceptedOrdersFuture;
  late final Future<Result<List<Order>>> _incomingOrdersFuture;
  late final Future<Result<User>> _userFuture;

  @override
  void initState() {
    super.initState();
    _acceptedOrdersFuture = widget.orderRepository.getOrders(scope: 'accepted');
    _incomingOrdersFuture = widget.orderRepository.getOrders(scope: 'incoming');
    _userFuture = widget.userRepository.getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.space20,
        AppSpacing.space20,
        AppSpacing.space20,
        AppSpacing.space20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _DashboardHeader(userFuture: _userFuture),
          const SizedBox(height: AppSpacing.space20),
          const _EarningsBanner(),
          const SizedBox(height: AppSpacing.space20),
          const _SectionTitle(title: 'Active Order'),
          const SizedBox(height: AppSpacing.space8),
          _ActiveOrderSection(ordersFuture: _acceptedOrdersFuture),
          const SizedBox(height: AppSpacing.space20),
          const _IncomingHeader(),
          const SizedBox(height: AppSpacing.space8),
          _IncomingRequestsSection(ordersFuture: _incomingOrdersFuture),
          const SizedBox(height: AppSpacing.space20),
          const _QuickActionsRow(),
        ],
      ),
    );
  }
}

final class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader({required this.userFuture});

  final Future<Result<User>> userFuture;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'GOOD MORNING',
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.mutedForeground,
              ),
            ),
            const SizedBox(height: AppSpacing.space4),
            FutureBuilder<Result<User>>(
              future: userFuture,
              builder: (context, snapshot) {
                final name = switch (snapshot.data) {
                  Success<User>(:final value) => value.fullName,
                  _ => 'Technician',
                };

                return Text(
                  name,
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: AppColors.foreground,
                  ),
                );
              },
            ),
          ],
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                // TODO: открыть уведомления.
              },
              child: SizedBox(
                width: AppSpacing.space40,
                height: AppSpacing.space40,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Stack(
                    children: [
                      const Center(
                        child: Icon(
                          Icons.notifications_none_outlined,
                          size: AppSpacing.space16,
                        ),
                      ),
                      Positioned(
                        top: AppSpacing.space8,
                        right: AppSpacing.space8,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: AppColors.error,
                            borderRadius: BorderRadius.circular(AppRadius.full),
                          ),
                          child: const SizedBox(
                            width: AppSpacing.space8,
                            height: AppSpacing.space8,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.space8),
            GestureDetector(
              onTap: () {
                // TODO: переключить доступность.
              },
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(
                    alpha: AppColors.primary10.a,
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.space12,
                    vertical: AppSpacing.space8,
                  ),
                  child: Row(
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          borderRadius: BorderRadius.circular(AppRadius.full),
                        ),
                        child: const SizedBox(
                          width: AppSpacing.space8,
                          height: AppSpacing.space8,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.space8),
                      Text(
                        'Online',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

final class _EarningsBanner extends StatelessWidget {
  const _EarningsBanner();

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "TODAY'S EARNINGS",
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.surface.withValues(alpha: AppColors.primary80.a),
              ),
            ),
            const SizedBox(height: AppSpacing.space4),
            Text(
              '42 800 ₸',
              style: AppTextStyles.displayMedium.copyWith(
                color: AppColors.surface,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: AppSpacing.space16),
            Divider(
              color: AppColors.surface.withValues(alpha: AppColors.primary20.a),
            ),
            const SizedBox(height: AppSpacing.space16),
            const Row(
              children: [
                Expanded(child: _BannerStat(value: '4', label: 'Jobs')),
                Expanded(child: _BannerStat(value: '1', label: 'Active')),
                Expanded(child: _BannerStat(value: '4.9', label: 'Rating')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

final class _BannerStat extends StatelessWidget {
  const _BannerStat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.titleLarge.copyWith(color: AppColors.surface),
        ),
        const SizedBox(height: AppSpacing.space4),
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.surface.withValues(alpha: AppColors.primary80.a),
          ),
        ),
      ],
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

final class _IncomingHeader extends StatelessWidget {
  const _IncomingHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'INCOMING REQUESTS',
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.mutedForeground,
          ),
        ),
        GestureDetector(
          onTap: () {
            // TODO: открыть все заявки.
          },
          child: Text(
            'See all',
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
              letterSpacing: 0,
            ),
          ),
        ),
      ],
    );
  }
}

final class _ActiveOrderSection extends StatelessWidget {
  const _ActiveOrderSection({required this.ordersFuture});

  final Future<Result<List<Order>>> ordersFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Result<List<Order>>>(
      future: ordersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _DashboardLoading();
        }

        final orders = switch (snapshot.data) {
          Success<List<Order>>(:final value) => value,
          _ => const <Order>[],
        };
        if (orders.isEmpty) {
          return const SizedBox.shrink();
        }

        return _ActiveOrderCard(order: orders.first);
      },
    );
  }
}

final class _ActiveOrderCard extends StatelessWidget {
  const _ActiveOrderCard({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      isSelected: true,
      variant: AppCardVariant.selectable,
      onTap: () {
        // TODO: открыть активный заказ.
      },
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.description,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.foreground,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.space4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: AppSpacing.space12,
                          color: AppColors.mutedForeground,
                        ),
                        const SizedBox(width: AppSpacing.space4),
                        Text(
                          order.address ?? 'Address not specified',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.primary10,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.space8,
                    vertical: AppSpacing.space4,
                  ),
                  child: Text(
                    order.status,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space12),
          const Divider(),
          const SizedBox(height: AppSpacing.space12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.schedule_outlined,
                    size: AppSpacing.space12,
                    color: AppColors.mutedForeground,
                  ),
                  const SizedBox(width: AppSpacing.space4),
                  Text(
                    _orderTime(order),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.mutedForeground,
                    ),
                  ),
                ],
              ),
              Text(
                _orderPrice(order),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.foreground,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

final class _IncomingRequestsSection extends StatelessWidget {
  const _IncomingRequestsSection({required this.ordersFuture});

  final Future<Result<List<Order>>> ordersFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Result<List<Order>>>(
      future: ordersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _DashboardLoading();
        }

        final orders = switch (snapshot.data) {
          Success<List<Order>>(:final value) => value,
          _ => const <Order>[],
        };
        if (orders.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          children: [
            for (final order in orders) ...[
              _IncomingRequestCard(order: order),
              if (order != orders.last)
                const SizedBox(height: AppSpacing.space8),
            ],
          ],
        );
      },
    );
  }
}

final class _IncomingRequestCard extends StatelessWidget {
  const _IncomingRequestCard({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.space12),
      onTap: () {
        // TODO: открыть заявку.
      },
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.description,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.foreground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.space4),
                Text(
                  '${order.address ?? 'Address not specified'} · Est. ${_orderPrice(order)}',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.mutedForeground,
                    letterSpacing: 0,
                  ),
                ),
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
    );
  }
}

final class _QuickActionsRow extends StatelessWidget {
  const _QuickActionsRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: _QuickActionCard(
            icon: Icons.trending_up,
            iconColor: AppColors.success,
            value: '+18%',
            label: 'VS LAST WEEK',
          ),
        ),
        SizedBox(width: AppSpacing.space8),
        Expanded(
          child: _QuickActionCard(
            icon: Icons.star,
            iconColor: AppColors.warning,
            value: '4.9',
            label: '154 REVIEWS',
          ),
        ),
      ],
    );
  }
}

final class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () {
        // TODO: открыть детали статистики.
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: AppSpacing.space20, color: iconColor),
          const SizedBox(height: AppSpacing.space8),
          Text(
            value,
            style: AppTextStyles.titleLarge.copyWith(
              color: AppColors.foreground,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: AppSpacing.space4),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}

final class _DashboardLoading extends StatelessWidget {
  const _DashboardLoading();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.space20),
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }
}

String _orderPrice(Order order) {
  final price = order.price;
  if (price == null) {
    return '—';
  }
  return '${price.toStringAsFixed(0)} ₸';
}

String _orderTime(Order order) {
  final preferredDate = order.preferredDate;
  if (preferredDate == null) {
    return 'Not scheduled';
  }
  return preferredDate.toLocal().toString().substring(0, 16);
}
