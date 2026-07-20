import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../shared/widgets/cards/app_card.dart';

enum _OrderFilter { all, active, completed, cancelled, disputed }

final class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

final class _OrdersPageState extends State<OrdersPage> {
  var _selectedFilter = _OrderFilter.all;
  var _searchQuery = '';
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_AdminOrder> get _filteredOrders {
    final byFilter = switch (_selectedFilter) {
      _OrderFilter.all => _orders,
      _OrderFilter.active =>
        _orders.where((order) => order.status == _OrderStatus.active).toList(),
      _OrderFilter.completed => _orders
          .where((order) => order.status == _OrderStatus.completed)
          .toList(),
      _OrderFilter.cancelled => _orders
          .where((order) => order.status == _OrderStatus.cancelled)
          .toList(),
      _OrderFilter.disputed => _orders
          .where((order) => order.status == _OrderStatus.disputed)
          .toList(),
    };

    if (_searchQuery.trim().isEmpty) {
      return byFilter;
    }

    final query = _searchQuery.trim().toLowerCase();
    return byFilter
        .where(
          (order) =>
              order.id.toLowerCase().contains(query) ||
              order.customer.toLowerCase().contains(query) ||
              order.technician.toLowerCase().contains(query),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final orders = _filteredOrders;

    return Column(
      children: [
        _OrdersHeader(
          selectedFilter: _selectedFilter,
          searchController: _searchController,
          onFilterSelected: (filter) {
            setState(() => _selectedFilter = filter);
          },
          onSearchChanged: (value) {
            setState(() => _searchQuery = value);
          },
          onFilterTap: () {
            // TODO: открыть расширенные фильтры.
          },
        ),
        Expanded(
          child: orders.isEmpty
              ? const _EmptyOrders()
              : ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.space20),
                  itemCount: orders.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: AppSpacing.space8),
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
    required this.selectedFilter,
    required this.searchController,
    required this.onFilterSelected,
    required this.onSearchChanged,
    required this.onFilterTap,
  });

  final _OrderFilter selectedFilter;
  final TextEditingController searchController;
  final ValueChanged<_OrderFilter> onFilterSelected;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onFilterTap;

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Orders',
                  style: AppTextStyles.headlineLarge.copyWith(
                    color: AppColors.foreground,
                  ),
                ),
                Text(
                  '342 today',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.mutedForeground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.space12),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: AppSpacing.space40,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.muted,
                        borderRadius: BorderRadius.circular(AppRadius.large),
                      ),
                      child: TextField(
                        controller: searchController,
                        onChanged: onSearchChanged,
                        style: AppTextStyles.bodyMedium,
                        decoration: InputDecoration(
                          hintText: 'Search #ID or customer',
                          hintStyle: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.mutedForeground,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            size: AppSpacing.space16,
                            color: AppColors.mutedForeground,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.space8,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.space8),
                GestureDetector(
                  onTap: onFilterTap,
                  child: SizedBox(
                    width: AppSpacing.space40,
                    height: AppSpacing.space40,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.muted,
                        borderRadius: BorderRadius.circular(AppRadius.large),
                      ),
                      child: const Icon(Icons.tune, size: AppSpacing.space16),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.space12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final filter in _OrderFilter.values) ...[
                    _FilterChip(
                      label: switch (filter) {
                        _OrderFilter.all => 'All',
                        _OrderFilter.active => 'Active',
                        _OrderFilter.completed => 'Completed',
                        _OrderFilter.cancelled => 'Cancelled',
                        _OrderFilter.disputed => 'Disputed',
                      },
                      isSelected: selectedFilter == filter,
                      onTap: () => onFilterSelected(filter),
                    ),
                    if (filter != _OrderFilter.values.last)
                      const SizedBox(width: AppSpacing.space8),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.muted,
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.space12,
            vertical: AppSpacing.space8,
          ),
          child: Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: isSelected ? AppColors.surface : AppColors.foreground,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

final class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order});

  final _AdminOrder order;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () {
        // TODO: открыть детали заказа.
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
          const SizedBox(height: AppSpacing.space8),
          _StatusChip(status: order.status),
        ],
      ),
    );
  }
}

final class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final _OrderStatus status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      _OrderStatus.active => AppColors.warning,
      _OrderStatus.completed => AppColors.success,
      _OrderStatus.cancelled || _OrderStatus.disputed => AppColors.error,
    };

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
          status.label.toUpperCase(),
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
      child: Text(
        'No orders found',
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.mutedForeground,
        ),
      ),
    );
  }
}

enum _OrderStatus {
  active('Active'),
  completed('Completed'),
  cancelled('Cancelled'),
  disputed('Disputed');

  const _OrderStatus(this.label);

  final String label;
}

final class _AdminOrder {
  const _AdminOrder({
    required this.id,
    required this.customer,
    required this.technician,
    required this.status,
    required this.price,
  });

  final String id;
  final String customer;
  final String technician;
  final _OrderStatus status;
  final String price;
}

const _orders = [
  _AdminOrder(
    id: 'ELS-8241',
    customer: 'Aigerim B.',
    technician: 'Dmitry V.',
    status: _OrderStatus.active,
    price: '18 500 ₸',
  ),
  _AdminOrder(
    id: 'ELS-8240',
    customer: 'Nurlan T.',
    technician: 'Arman S.',
    status: _OrderStatus.completed,
    price: '22 000 ₸',
  ),
  _AdminOrder(
    id: 'ELS-8239',
    customer: 'Aida M.',
    technician: 'Bauyrzhan K.',
    status: _OrderStatus.completed,
    price: '35 000 ₸',
  ),
  _AdminOrder(
    id: 'ELS-8238',
    customer: 'Bakhyt K.',
    technician: '—',
    status: _OrderStatus.cancelled,
    price: '—',
  ),
  _AdminOrder(
    id: 'ELS-8237',
    customer: 'Yerlan D.',
    technician: 'Dmitry V.',
    status: _OrderStatus.disputed,
    price: '12 000 ₸',
  ),
];
