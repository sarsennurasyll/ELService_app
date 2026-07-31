import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/utils/result.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../../../shared/widgets/cards/app_card.dart';
import '../../domain/models/order.dart';
import '../../domain/repositories/order_repository.dart';

final class OrdersPage extends StatefulWidget {
  const OrdersPage({
    required this.orderRepository,
    required this.ordersRefreshNotifier,
    super.key,
  });

  final OrderRepository orderRepository;
  final ValueNotifier<int> ordersRefreshNotifier;

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

final class _OrdersPageState extends State<OrdersPage> {
  late Future<_CustomerOrdersState> _ordersFuture;
  var _isActiveTab = true;

  @override
  void initState() {
    super.initState();
    _ordersFuture = _loadOrders();
    widget.ordersRefreshNotifier.addListener(_reloadOrders);
  }

  @override
  void dispose() {
    widget.ordersRefreshNotifier.removeListener(_reloadOrders);
    super.dispose();
  }

  void _reloadOrders() {
    setState(() {
      _isActiveTab = true;
      _ordersFuture = _loadOrders();
    });
  }

  Future<_CustomerOrdersState> _loadOrders() async {
    final activeOrders = await widget.orderRepository.getOrders(
      scope: 'active',
    );
    final pastOrders = await widget.orderRepository.getOrders(scope: 'past');
    return _CustomerOrdersState(active: activeOrders, past: pastOrders);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_CustomerOrdersState>(
      future: _ordersFuture,
      builder: (context, snapshot) {
        final state = snapshot.data;
        final selectedResult = _isActiveTab ? state?.active : state?.past;
        final activeCount = state?.activeOrders.length ?? 0;
        final selectedOrders = selectedResult is Success<List<Order>>
            ? selectedResult.value
            : const <Order>[];

        return Column(
          children: [
            _OrdersHeader(
              isActiveTab: _isActiveTab,
              activeCount: activeCount,
              onActiveSelected: () => setState(() => _isActiveTab = true),
              onPastSelected: () => setState(() => _isActiveTab = false),
            ),
            Expanded(
              child: switch (snapshot.connectionState) {
                ConnectionState.waiting => const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
                _ when selectedResult is ErrorResult<List<Order>> =>
                  _OrdersError(
                  message: selectedResult.failure.message,
                  onRetry: _reloadOrders,
                ),
                _
                    when selectedResult is Success<List<Order>> &&
                        selectedOrders.isEmpty =>
                  _EmptyOrders(isActiveTab: _isActiveTab),
                _ when selectedResult is Success<List<Order>> =>
                  ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.space20),
                  itemCount: selectedOrders.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: AppSpacing.space12),
                  itemBuilder: (context, index) =>
                      _OrderCard(order: selectedOrders[index]),
                ),
                _ => _OrdersError(
                  message: AppLocalizations.of(context)!.unableToLoadOrders,
                  onRetry: _reloadOrders,
                ),
              },
            ),
          ],
        );
      },
    );
  }
}

final class _CustomerOrdersState {
  const _CustomerOrdersState({required this.active, required this.past});

  final Result<List<Order>> active;
  final Result<List<Order>> past;

  List<Order> get activeOrders {
    final result = active;
    return result is Success<List<Order>> ? result.value : const <Order>[];
  }
}

final class _OrdersHeader extends StatelessWidget {
  const _OrdersHeader({
    required this.isActiveTab,
    required this.activeCount,
    required this.onActiveSelected,
    required this.onPastSelected,
  });

  final bool isActiveTab;
  final int activeCount;
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
                      label: 'ACTIVE ($activeCount)',
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

  final Order order;

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
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.space4),
                    Text(
                      '${order.assignedMasterId ?? order.technicianId ?? 'Awaiting technician'} · ${_orderTime(order)}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.mutedForeground,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (order.price case final price?)
                Text(
                  '${price.toStringAsFixed(0)} ₸',
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

  final Order order;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(order.status);
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
            if (order.status == 'COMPLETED') ...[
              const Icon(
                Icons.check_circle_outline,
                size: AppSpacing.space12,
                color: AppColors.success,
              ),
              const SizedBox(width: AppSpacing.space4),
            ],
            Text(
              order.status,
              style: AppTextStyles.labelSmall.copyWith(color: color),
            ),
          ],
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
              label: AppLocalizations.of(context)!.retry,
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
  const _EmptyOrders({required this.isActiveTab});

  final bool isActiveTab;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
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
              isActiveTab
                  ? localizations.noActiveOrders
                  : localizations.noPastOrders,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.foreground,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.space4),
            Text(
              localizations.ordersWillAppearHere,
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
