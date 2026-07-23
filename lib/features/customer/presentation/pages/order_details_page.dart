import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/utils/result.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../../../shared/widgets/cards/app_card.dart';
import '../../../../shared/widgets/layout/app_top_bar.dart';
import '../../../../shared/widgets/layout/screen.dart';
import '../../domain/models/order.dart';
import '../../domain/repositories/order_repository.dart';

final class OrderDetailsPage extends StatefulWidget {
  const OrderDetailsPage({
    required this.orderId,
    required this.orderRepository,
    super.key,
  });

  final String orderId;
  final OrderRepository orderRepository;

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

final class _OrderDetailsPageState extends State<OrderDetailsPage> {
  late final Future<Result<Order>> _orderFuture = widget.orderRepository
      .getOrderById(widget.orderId);

  @override
  Widget build(BuildContext context) {
    return Screen(
      padding: EdgeInsets.zero,
      appBar: AppTopBar(
        title: 'Order details',
        subtitle: widget.orderId,
        onBack: () => context.pop(),
      ),
      child: FutureBuilder<Result<Order>>(
        future: _orderFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          final result = snapshot.data;
          if (result is ErrorResult<Order>) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.space64),
                child: Text(
                  result.failure.message,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.error,
                  ),
                ),
              ),
            );
          }
          if (result is Success<Order>) {
            return _OrderDetailsContent(
              order: _OrderDetails.fromOrder(result.value),
            );
          }

          return const Center(child: Text('Не удалось загрузить заказ'));
        },
      ),
    );
  }
}

final class _OrderDetailsContent extends StatelessWidget {
  const _OrderDetailsContent({required this.order});

  final _OrderDetails order;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.space20),
            children: [
              _StatusBanner(status: order.status),
              const SizedBox(height: AppSpacing.space16),
              _OrderInfoCard(order: order),
              const SizedBox(height: AppSpacing.space16),
              _DescriptionSection(description: order.description),
              const SizedBox(height: AppSpacing.space16),
              const _PhotosSection(),
              const SizedBox(height: AppSpacing.space16),
              _CostCard(price: order.price, isEstimate: order.isEstimate),
            ],
          ),
        ),
        DecoratedBox(
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: AppColors.border)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.space20),
            child: order.isCompleted
                ? PrimaryButton(
                    label: 'Rate technician',
                    onPressed: () {
                      // TODO: открыть оценку мастера.
                    },
                  )
                : Row(
                    children: [
                      Expanded(
                        child: PrimaryButton(
                          label: 'Offers',
                          variant: PrimaryButtonVariant.outline,
                          onPressed: () =>
                              context.push(AppRoutes.offers(order.id)),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.space8),
                      Expanded(
                        child: PrimaryButton(
                          label: 'Chat',
                          variant: PrimaryButtonVariant.outline,
                          onPressed: () {
                            // TODO: открыть чат.
                          },
                        ),
                      ),
                      const SizedBox(width: AppSpacing.space8),
                      Expanded(
                        child: PrimaryButton(
                          label: 'Complete',
                          onPressed: () {
                            // TODO: завершить заказ.
                          },
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}

final class _StatusBanner extends StatelessWidget {
  const _StatusBanner({required this.status});

  final _OrderStatus status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      _OrderStatus.pending => AppColors.warning,
      _OrderStatus.accepted => AppColors.primary,
      _OrderStatus.completed => AppColors.success,
      _OrderStatus.active => AppColors.primary,
      _OrderStatus.cancelled || _OrderStatus.disputed => AppColors.error,
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: AppColors.primary10.a),
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(
          color: color.withValues(alpha: AppColors.primary20.a),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.space16),
        child: Row(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: color.withValues(alpha: AppColors.primary20.a),
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.space8),
                child: Icon(
                  switch (status) {
                    _OrderStatus.pending => Icons.directions_car_outlined,
                    _OrderStatus.accepted => Icons.handshake_outlined,
                    _OrderStatus.completed => Icons.check_circle_outline,
                    _OrderStatus.active => Icons.build_outlined,
                    _OrderStatus.cancelled ||
                    _OrderStatus.disputed => Icons.error_outline,
                  },
                  size: AppSpacing.space16,
                  color: color,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.space12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'STATUS',
                    style: AppTextStyles.labelMedium.copyWith(color: color),
                  ),
                  const SizedBox(height: AppSpacing.space4),
                  Text(
                    status.label,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.foreground,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _OrderInfoCard extends StatelessWidget {
  const _OrderInfoCard({required this.order});

  final _OrderDetails order;

  @override
  Widget build(BuildContext context) {
    return AppCard(
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
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.space4),
                    Text(
                      order.subtitle,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space12),
          const Divider(),
          const SizedBox(height: AppSpacing.space12),
          _InfoRow(
            icon: Icons.location_on_outlined,
            label: 'Address',
            value: order.address,
          ),
          const SizedBox(height: AppSpacing.space12),
          _InfoRow(
            icon: Icons.schedule_outlined,
            label: 'Scheduled',
            value: order.schedule,
          ),
        ],
      ),
    );
  }
}

final class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: AppSpacing.space16, color: AppColors.mutedForeground),
        const SizedBox(width: AppSpacing.space12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label.toUpperCase(),
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.mutedForeground,
                ),
              ),
              const SizedBox(height: AppSpacing.space4),
              Text(
                value,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.foreground,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

final class _DescriptionSection extends StatelessWidget {
  const _DescriptionSection({required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'DESCRIPTION',
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.mutedForeground,
          ),
        ),
        const SizedBox(height: AppSpacing.space8),
        AppCard(
          child: Text(
            description,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.foreground,
            ),
          ),
        ),
      ],
    );
  }
}

final class _PhotosSection extends StatelessWidget {
  const _PhotosSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'ATTACHED PHOTOS',
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.mutedForeground,
          ),
        ),
        const SizedBox(height: AppSpacing.space8),
        Row(
          children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primary20,
                        AppColors.secondary.withValues(
                          alpha: AppColors.primary20.a,
                        ),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(AppRadius.large),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.space8),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.warning.withValues(
                          alpha: AppColors.primary20.a,
                        ),
                        AppColors.error.withValues(
                          alpha: AppColors.primary20.a,
                        ),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(AppRadius.large),
                  ),
                ),
              ),
            ),
            const Expanded(child: SizedBox()),
          ],
        ),
      ],
    );
  }
}

final class _CostCard extends StatelessWidget {
  const _CostCard({required this.price, required this.isEstimate});

  final String price;
  final bool isEstimate;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.primary5,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.primary10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEstimate ? 'ESTIMATED PRICE' : 'ORDER TOTAL',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.space4),
            Text(
              price,
              style: AppTextStyles.headlineMedium.copyWith(
                color: AppColors.foreground,
              ),
            ),
            if (isEstimate) ...[
              const SizedBox(height: AppSpacing.space4),
              Text(
                "Final price set by the technician's offer",
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.mutedForeground,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

enum _OrderStatus {
  pending('Pending'),
  accepted('Accepted'),
  active('Active'),
  completed('Completed'),
  cancelled('Cancelled'),
  disputed('Disputed');

  const _OrderStatus(this.label);

  final String label;
}

final class _OrderDetails {
  const _OrderDetails({
    required this.id,
    required this.idLabel,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.address,
    required this.schedule,
    required this.status,
    required this.price,
    required this.isEstimate,
    required this.isCompleted,
  });

  final String id;
  final String idLabel;
  final IconData icon;
  final String title;
  final String subtitle;
  final String description;
  final String address;
  final String schedule;
  final _OrderStatus status;
  final String price;
  final bool isEstimate;
  final bool isCompleted;
  factory _OrderDetails.fromOrder(Order order) {
    final preferredDate = order.preferredDate;
    return _OrderDetails(
      id: order.id,
      idLabel: '#${order.id}',
      icon: Icons.build_outlined,
      title: order.description,
      subtitle: order.status,
      description: order.description,
      address: order.address ?? 'Address not specified',
      schedule: preferredDate == null
          ? 'Not scheduled'
          : preferredDate.toLocal().toString().substring(0, 16),
      status: _orderStatusFromValue(order.status),
      price: order.price == null ? '—' : '${order.price!.toStringAsFixed(0)} ₸',
      isEstimate: order.price == null,
      isCompleted: order.status == 'COMPLETED',
    );
  }
}

_OrderStatus _orderStatusFromValue(String value) {
  return switch (value) {
    'ACCEPTED' => _OrderStatus.accepted,
    'ACTIVE' => _OrderStatus.active,
    'COMPLETED' => _OrderStatus.completed,
    'CANCELLED' => _OrderStatus.cancelled,
    'DISPUTED' => _OrderStatus.disputed,
    _ => _OrderStatus.pending,
  };
}
