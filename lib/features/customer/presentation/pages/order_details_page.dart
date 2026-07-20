import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../../../shared/widgets/cards/app_card.dart';
import '../../../../shared/widgets/layout/app_top_bar.dart';
import '../../../../shared/widgets/layout/screen.dart';

final class OrderDetailsPage extends StatelessWidget {
  const OrderDetailsPage({required this.orderId, super.key});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    final order = _mockOrderFor(orderId);

    return Screen(
      padding: EdgeInsets.zero,
      appBar: AppTopBar(
        title: 'Order details',
        subtitle: order.idLabel,
        onBack: () => context.pop(),
      ),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.space20),
              children: [
                _StatusBanner(status: order.status),
                const SizedBox(height: AppSpacing.space16),
                _OrderInfoCard(order: order),
                if (order.technician case final technician?) ...[
                  const SizedBox(height: AppSpacing.space16),
                  _TechnicianCard(technician: technician),
                ],
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
                            label: 'Call',
                            variant: PrimaryButtonVariant.outline,
                            onPressed: () {
                              // TODO: позвонить мастеру.
                            },
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
      ),
    );
  }
}

final class _StatusBanner extends StatelessWidget {
  const _StatusBanner({required this.status});

  final _OrderStatus status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      _OrderStatus.onTheWay => AppColors.warning,
      _OrderStatus.completed => AppColors.success,
      _OrderStatus.inProgress => AppColors.primary,
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: AppColors.primary10.a),
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: color.withValues(alpha: AppColors.primary20.a)),
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
                    _OrderStatus.onTheWay => Icons.directions_car_outlined,
                    _OrderStatus.completed => Icons.check_circle_outline,
                    _OrderStatus.inProgress => Icons.build_outlined,
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

final class _TechnicianCard extends StatelessWidget {
  const _TechnicianCard({required this.technician});

  final _TechnicianInfo technician;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () {
        // TODO: открыть профиль мастера.
      },
      child: Row(
        children: [
          SizedBox(
            width: AppSpacing.space56,
            height: AppSpacing.space56,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primary, AppColors.secondary],
                ),
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: Center(
                child: Text(
                  technician.initials,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.surface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.space12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TECHNICIAN',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.mutedForeground,
                  ),
                ),
                const SizedBox(height: AppSpacing.space4),
                Text(
                  technician.name,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.foreground,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.space4),
                Text(
                  technician.details,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.mutedForeground,
                  ),
                ),
              ],
            ),
          ),
          if (technician.eta case final eta?)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'ARRIVING',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.mutedForeground,
                  ),
                ),
                const SizedBox(height: AppSpacing.space4),
                Text(
                  eta,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
        ],
      ),
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
  onTheWay('On the way'),
  inProgress('In progress'),
  completed('Completed');

  const _OrderStatus(this.label);

  final String label;
}

final class _TechnicianInfo {
  const _TechnicianInfo({
    required this.name,
    required this.initials,
    required this.details,
    this.eta,
  });

  final String name;
  final String initials;
  final String details;
  final String? eta;
}

final class _OrderDetails {
  const _OrderDetails({
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
    this.technician,
  });

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
  final _TechnicianInfo? technician;
}

_OrderDetails _mockOrderFor(String orderId) {
  if (orderId == '2') {
    return const _OrderDetails(
      idLabel: '#ELS-7902',
      icon: Icons.local_laundry_service_outlined,
      title: 'LG TwinWash · Washing machine',
      subtitle: 'Does not spin · loud noise',
      description:
          'Machine fills with water but does not enter spin cycle. Loud knocking during wash.',
      address: 'Respublika Ave 14, Apt 42',
      schedule: 'Mar 12 · 11:00 – 13:00',
      status: _OrderStatus.completed,
      price: '22 000 ₸',
      isEstimate: false,
      isCompleted: true,
      technician: _TechnicianInfo(
        name: 'Arman Serikov',
        initials: 'AS',
        details: 'Kitchen Specialist · 4.9 ★',
      ),
    );
  }

  if (orderId == '3') {
    return const _OrderDetails(
      idLabel: '#ELS-7755',
      icon: Icons.air_outlined,
      title: 'Haier Split · AC installation',
      subtitle: 'New unit install · balcony',
      description:
          'Install new split AC on the balcony wall. Need bracket and vacuum check.',
      address: 'Nazarbayev Center, 7 fl',
      schedule: 'Feb 28 · 09:00 – 12:00',
      status: _OrderStatus.completed,
      price: '35 000 ₸',
      isEstimate: false,
      isCompleted: true,
      technician: _TechnicianInfo(
        name: 'Bauyrzhan K.',
        initials: 'BK',
        details: 'AC & Heating · 4.7 ★',
      ),
    );
  }

  return const _OrderDetails(
    idLabel: '#ELS-8241',
    icon: Icons.kitchen_outlined,
    title: 'Samsung RB37 · Refrigerator',
    subtitle: 'Water leak · warm compartment',
    description:
        'Water leaking from bottom of the fridge. Freezer is still cold but the main compartment is warm.',
    address: 'Respublika Ave 14, Apt 42',
    schedule: 'Today · 10:00 – 12:00',
    status: _OrderStatus.onTheWay,
    price: '15 000 – 25 000 ₸',
    isEstimate: true,
    isCompleted: false,
    technician: _TechnicianInfo(
      name: 'Dmitry Volkov',
      initials: 'DV',
      details: 'Toyota Corolla · 728 AWA 01',
      eta: '12 min',
    ),
  );
}
