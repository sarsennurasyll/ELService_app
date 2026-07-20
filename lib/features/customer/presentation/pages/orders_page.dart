import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../shared/widgets/cards/app_card.dart';

final class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

final class _OrdersPageState extends State<OrdersPage> {
  var _isActiveTab = true;

  @override
  Widget build(BuildContext context) {
    final orders = _isActiveTab ? _activeOrders : _pastOrders;

    return Column(
      children: [
        _OrdersHeader(
          isActiveTab: _isActiveTab,
          onActiveSelected: () => setState(() => _isActiveTab = true),
          onPastSelected: () => setState(() => _isActiveTab = false),
        ),
        Expanded(
          child: orders.isEmpty
              ? _EmptyOrders(isActiveTab: _isActiveTab)
              : ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.space20),
                  itemCount: orders.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: AppSpacing.space12),
                  itemBuilder: (context, index) =>
                      _OrderCard(order: orders[index]),
                ),
        ),
      ],
    );
  }
}

final class _OrdersHeader extends StatelessWidget {
  const _OrdersHeader({
    required this.isActiveTab,
    required this.onActiveSelected,
    required this.onPastSelected,
  });

  final bool isActiveTab;
  final VoidCallback onActiveSelected;
  final VoidCallback onPastSelected;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.space20,
          AppSpacing.space20,
          AppSpacing.space20,
          AppSpacing.space16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'My orders',
              style: AppTextStyles.headlineLarge.copyWith(
                color: AppColors.foreground,
              ),
            ),
            const SizedBox(height: AppSpacing.space16),
            DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.muted,
                borderRadius: BorderRadius.circular(AppRadius.card),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.space4),
                child: Row(
                  children: [
                    _OrdersTab(
                      label: 'ACTIVE (1)',
                      isSelected: isActiveTab,
                      onTap: onActiveSelected,
                    ),
                    _OrdersTab(
                      label: 'PAST',
                      isSelected: !isActiveTab,
                      onTap: onPastSelected,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _OrdersTab extends StatelessWidget {
  const _OrdersTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: isSelected ? AppColors.surface : null,
            borderRadius: BorderRadius.circular(AppRadius.large),
            boxShadow: isSelected ? AppShadows.sm : const <BoxShadow>[],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.space8),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall.copyWith(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.mutedForeground,
                fontWeight: FontWeight.w700,
                letterSpacing: AppTextStyles.labelSmall.letterSpacing,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

final class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order});

  final _Order order;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () => context.push(AppRoutes.orderDetails(order.id)),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: AppSpacing.space48,
                height: AppSpacing.space48,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.primary10,
                    borderRadius: BorderRadius.circular(AppRadius.large),
                  ),
                  child: Icon(
                    order.icon,
                    size: AppSpacing.space24,
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
                      order.title,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.foreground,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.space4),
                    Text(
                      '${order.technician} · ${order.time}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),
              if (order.price case final price?)
                Text(
                  price,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.foreground,
                    fontWeight: FontWeight.w700,
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
              _OrderStatus(order: order),
              Text(
                'Details →',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

final class _OrderStatus extends StatelessWidget {
  const _OrderStatus({required this.order});

  final _Order order;

  @override
  Widget build(BuildContext context) {
    final color = order.isCompleted ? AppColors.success : AppColors.warning;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: AppColors.primary10.a),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space8,
          vertical: AppSpacing.space4,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (order.isCompleted) ...[
              const Icon(
                Icons.check_circle_outline,
                size: AppSpacing.space12,
                color: AppColors.success,
              ),
              const SizedBox(width: AppSpacing.space4),
            ],
            Text(
              order.status.toUpperCase(),
              style: AppTextStyles.labelSmall.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}

final class _EmptyOrders extends StatelessWidget {
  const _EmptyOrders({required this.isActiveTab});

  final bool isActiveTab;

  @override
  Widget build(BuildContext context) {
    final tabLabel = isActiveTab ? 'active' : 'past';
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.space64),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: AppSpacing.space64,
              height: AppSpacing.space64,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.primary10,
                  borderRadius: BorderRadius.circular(AppRadius.card),
                ),
                child: const Icon(
                  Icons.schedule_outlined,
                  size: AppSpacing.space32,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.space16),
            Text(
              'No $tabLabel orders',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.foreground,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.space4),
            Text(
              'New orders will appear here.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.mutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _Order {
  const _Order({
    required this.id,
    required this.icon,
    required this.title,
    required this.technician,
    required this.status,
    required this.time,
    required this.isCompleted,
    this.price,
  });

  final String id;
  final IconData icon;
  final String title;
  final String technician;
  final String status;
  final String time;
  final bool isCompleted;
  final String? price;
}

const _activeOrders = [
  _Order(
    id: '1',
    icon: Icons.kitchen_outlined,
    title: 'Refrigerator repair',
    technician: 'Dmitry Volkov',
    status: 'On the way',
    time: 'Today · 10:00',
    isCompleted: false,
  ),
];

const _pastOrders = [
  _Order(
    id: '2',
    icon: Icons.local_laundry_service_outlined,
    title: 'Washing machine',
    technician: 'Arman Serikov',
    status: 'Completed',
    time: 'Mar 12',
    isCompleted: true,
    price: '22 000 ₸',
  ),
  _Order(
    id: '3',
    icon: Icons.air_outlined,
    title: 'AC installation',
    technician: 'Bauyrzhan K.',
    status: 'Completed',
    time: 'Feb 28',
    isCompleted: true,
    price: '35 000 ₸',
  ),
];
