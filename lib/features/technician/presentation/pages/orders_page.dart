import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/storage/token_storage.dart';
import '../../../../core/utils/result.dart';
import '../../../../features/customer/domain/models/order.dart';
import '../../../../features/customer/domain/repositories/order_repository.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../../../shared/widgets/cards/app_card.dart';

enum _OrdersTab { incoming, accepted, completed }

final class OrdersPage extends StatefulWidget {
  const OrdersPage({
    required this.orderRepository,
    required this.tokenStorage,
    super.key,
  });

  final OrderRepository orderRepository;
  final TokenStorage tokenStorage;

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

final class _OrdersPageState extends State<OrdersPage> {
  late Future<_TechnicianOrdersState> _ordersFuture;
  var _selectedTab = _OrdersTab.incoming;

  @override
  void initState() {
    super.initState();
    _ordersFuture = _loadOrders();
  }

  Future<_TechnicianOrdersState> _loadOrders() async {
    final technicianId = await _currentTechnicianId();
    final result = await widget.orderRepository.getOrders();
    return _TechnicianOrdersState(result: result, technicianId: technicianId);
  }

  Future<String?> _currentTechnicianId() async {
    final session = await widget.tokenStorage.getSession();
    if (session == null) {
      return null;
    }

    try {
      final json = jsonDecode(session);
      final user = json is Map ? json['user'] : null;
      final id = user is Map ? user['id'] : null;
      return id is String && id.isNotEmpty ? id : null;
    } on FormatException {
      return null;
    }
  }

  void _reloadOrders() {
    setState(() {
      _ordersFuture = _loadOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_TechnicianOrdersState>(
      future: _ordersFuture,
      builder: (context, snapshot) {
        final state = snapshot.data;
        final orders = state?.orders ?? const <Order>[];
        final technicianId = state?.technicianId;
        final incomingOrders = orders.where(_isIncomingOrder).toList();
        final acceptedOrders = orders
            .where((order) => _isTechnicianAcceptedOrder(order, technicianId))
            .toList();
        final completedOrders = orders
            .where((order) => _isTechnicianCompletedOrder(order, technicianId))
            .toList();
        final selectedOrders = switch (_selectedTab) {
          _OrdersTab.incoming => incomingOrders,
          _OrdersTab.accepted => acceptedOrders,
          _OrdersTab.completed => completedOrders,
        };

        return Column(
          children: [
            _OrdersHeader(
              selectedTab: _selectedTab,
              incomingCount: incomingOrders.length,
              onTabSelected: (tab) => setState(() => _selectedTab = tab),
            ),
            Expanded(
              child: switch (snapshot.connectionState) {
                ConnectionState.waiting => const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
                _ when state?.result is ErrorResult<List<Order>> =>
                  _OrdersError(
                    message: (state!.result as ErrorResult<List<Order>>)
                        .failure
                        .message,
                    onRetry: _reloadOrders,
                  ),
                _ when selectedOrders.isEmpty => const _EmptyOrders(),
                _ => RefreshIndicator(
                  onRefresh: () async => _reloadOrders(),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(AppSpacing.space20),
                    itemCount: selectedOrders.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: AppSpacing.space12),
                    itemBuilder: (context, index) =>
                        _OrderCard(order: selectedOrders[index]),
                  ),
                ),
              },
            ),
          ],
        );
      },
    );
  }
}

final class _OrdersHeader extends StatelessWidget {
  const _OrdersHeader({
    required this.selectedTab,
    required this.incomingCount,
    required this.onTabSelected,
  });

  final _OrdersTab selectedTab;
  final int incomingCount;
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
                      label: 'NEW ($incomingCount)',
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

  final Order order;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () => context.push(AppRoutes.orderDetails(order.id)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
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
                  child: const Icon(
                    Icons.build_outlined,
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
                      order.description,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.foreground,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.space4),
                    Text(
                      order.address ?? 'Address not specified',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.mutedForeground,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Text(
                _orderTime(order),
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.mutedForeground,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space12),
          Row(
            children: [
              _OrderStatusChip(status: order.status),
              const Spacer(),
              if (_isIncomingOrder(order))
                SizedBox(
                  width: AppSpacing.space96,
                  child: PrimaryButton(
                    label: 'Offer',
                    onPressed: () =>
                        context.push(AppRoutes.sendOffer(order.id)),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

final class _OrderStatusChip extends StatelessWidget {
  const _OrderStatusChip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(status);
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
          status,
          style: AppTextStyles.labelSmall.copyWith(color: color),
        ),
      ),
    );
  }
}

final class _OrdersError extends StatelessWidget {
  const _OrdersError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.space64),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
            ),
            const SizedBox(height: AppSpacing.space16),
            PrimaryButton(
              label: 'Retry',
              variant: PrimaryButtonVariant.outline,
              onPressed: onRetry,
            ),
          ],
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

final class _TechnicianOrdersState {
  const _TechnicianOrdersState({
    required this.result,
    required this.technicianId,
  });

  final Result<List<Order>> result;
  final String? technicianId;

  List<Order> get orders {
    final result = this.result;
    return result is Success<List<Order>> ? result.value : const <Order>[];
  }
}

bool _isIncomingOrder(Order order) {
  return order.status == 'PENDING' && order.assignedMasterId == null;
}

bool _isTechnicianAcceptedOrder(Order order, String? technicianId) {
  if (technicianId == null) {
    return false;
  }
  return order.assignedMasterId == technicianId &&
      order.status != 'COMPLETED' &&
      order.status != 'CANCELLED';
}

bool _isTechnicianCompletedOrder(Order order, String? technicianId) {
  if (technicianId == null) {
    return false;
  }
  return order.assignedMasterId == technicianId && order.status == 'COMPLETED';
}

Color _statusColor(String status) {
  return switch (status) {
    'COMPLETED' => AppColors.success,
    'CANCELLED' || 'DISPUTED' => AppColors.error,
    'ACCEPTED' || 'IN_PROGRESS' || 'ACTIVE' => AppColors.primary,
    _ => AppColors.warning,
  };
}

String _orderTime(Order order) {
  final preferredDate = order.preferredDate;
  if (preferredDate == null) {
    return 'Not scheduled';
  }
  return preferredDate.toLocal().toString().substring(0, 16);
}
