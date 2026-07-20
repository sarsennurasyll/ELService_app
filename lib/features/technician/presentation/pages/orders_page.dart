import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../shared/widgets/cards/app_card.dart';

enum _OrdersTab { incoming, accepted, completed }

final class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

final class _OrdersPageState extends State<OrdersPage> {
  var _selectedTab = _OrdersTab.incoming;

  List<_TechOrder> get _orders => switch (_selectedTab) {
    _OrdersTab.incoming => _incomingOrders,
    _OrdersTab.accepted => _acceptedOrders,
    _OrdersTab.completed => _completedOrders,
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _OrdersHeader(
          selectedTab: _selectedTab,
          onTabSelected: (tab) => setState(() => _selectedTab = tab),
        ),
        Expanded(
          child: _orders.isEmpty
              ? const _EmptyOrders()
              : ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.space20),
                  itemCount: _orders.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: AppSpacing.space12),
                  itemBuilder: (context, index) =>
                      _OrderCard(order: _orders[index]),
                ),
        ),
      ],
    );
  }
}

final class _OrdersHeader extends StatelessWidget {
  const _OrdersHeader({
    required this.selectedTab,
    required this.onTabSelected,
  });

  final _OrdersTab selectedTab;
  final ValueChanged<_OrdersTab> onTabSelected;

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
              'Orders',
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
                    _OrdersTabButton(
                      label: 'NEW (${_incomingOrders.length})',
                      isSelected: selectedTab == _OrdersTab.incoming,
                      onTap: () => onTabSelected(_OrdersTab.incoming),
                    ),
                    _OrdersTabButton(
                      label: 'ACCEPTED',
                      isSelected: selectedTab == _OrdersTab.accepted,
                      onTap: () => onTabSelected(_OrdersTab.accepted),
                    ),
                    _OrdersTabButton(
                      label: 'DONE',
                      isSelected: selectedTab == _OrdersTab.completed,
                      onTap: () => onTabSelected(_OrdersTab.completed),
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

final class _OrdersTabButton extends StatelessWidget {
  const _OrdersTabButton({
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

  final _TechOrder order;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () {
        // TODO: открыть детали заказа.
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        order.title,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.foreground,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      order.timeLabel,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.mutedForeground,
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.space4),
                Text(
                  order.description,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.mutedForeground,
                  ),
                ),
                const SizedBox(height: AppSpacing.space8),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: AppSpacing.space12,
                      color: AppColors.mutedForeground,
                    ),
                    const SizedBox(width: AppSpacing.space4),
                    Text(
                      order.distance,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.mutedForeground,
                        letterSpacing: 0,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.space12),
                    Text(
                      order.price,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
                if (order.statusLabel case final status?) ...[
                  const SizedBox(height: AppSpacing.space8),
                  _OrderStatusChip(
                    label: status,
                    isCompleted: order.isCompleted,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

final class _OrderStatusChip extends StatelessWidget {
  const _OrderStatusChip({
    required this.label,
    required this.isCompleted,
  });

  final String label;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    final color = isCompleted ? AppColors.success : AppColors.warning;
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
        child: Text(
          label.toUpperCase(),
          style: AppTextStyles.labelSmall.copyWith(color: color),
        ),
      ),
    );
  }
}

final class _EmptyOrders extends StatelessWidget {
  const _EmptyOrders();

  @override
  Widget build(BuildContext context) {
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
                  Icons.inbox_outlined,
                  size: AppSpacing.space32,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.space16),
            Text(
              'No orders here',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.foreground,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.space4),
            Text(
              'New requests will appear in this list.',
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

final class _TechOrder {
  const _TechOrder({
    required this.icon,
    required this.title,
    required this.description,
    required this.distance,
    required this.price,
    required this.timeLabel,
    this.statusLabel,
    this.isCompleted = false,
  });

  final IconData icon;
  final String title;
  final String description;
  final String distance;
  final String price;
  final String timeLabel;
  final String? statusLabel;
  final bool isCompleted;
}

const _incomingOrders = [
  _TechOrder(
    icon: Icons.local_laundry_service_outlined,
    title: 'Washer · Bosch WAT28',
    description: 'Not spinning, water stays',
    distance: '1.4 km',
    price: '16 000 – 22 000 ₸',
    timeLabel: '3 min ago',
  ),
  _TechOrder(
    icon: Icons.air_outlined,
    title: 'AC · LG Dualcool',
    description: 'Not cooling',
    distance: '3.2 km',
    price: '12 000 – 18 000 ₸',
    timeLabel: '8 min ago',
  ),
  _TechOrder(
    icon: Icons.kitchen_outlined,
    title: 'Fridge · Haier',
    description: 'Freezer frost buildup',
    distance: '4.1 km',
    price: '10 000 – 15 000 ₸',
    timeLabel: '15 min ago',
  ),
];

const _acceptedOrders = [
  _TechOrder(
    icon: Icons.kitchen_outlined,
    title: 'Refrigerator · Samsung RB37',
    description: 'Water leak · warm compartment',
    distance: '1.4 km',
    price: '18 500 ₸',
    timeLabel: 'Today',
    statusLabel: 'En route',
  ),
  _TechOrder(
    icon: Icons.air_outlined,
    title: 'AC diagnostic · Nurlan T.',
    description: 'Unit not cooling properly',
    distance: '2.1 km',
    price: '8 000 ₸',
    timeLabel: 'Today',
    statusLabel: 'Scheduled',
  ),
];

const _completedOrders = [
  _TechOrder(
    icon: Icons.local_laundry_service_outlined,
    title: 'Washer install · Aida M.',
    description: 'New unit installation',
    distance: '3.0 km',
    price: '35 000 ₸',
    timeLabel: 'Mon',
    statusLabel: 'Completed',
    isCompleted: true,
  ),
  _TechOrder(
    icon: Icons.kitchen_outlined,
    title: 'Fridge repair · Bakhyt K.',
    description: 'Compressor check',
    distance: '2.4 km',
    price: '22 000 ₸',
    timeLabel: 'Feb 28',
    statusLabel: 'Completed',
    isCompleted: true,
  ),
];
