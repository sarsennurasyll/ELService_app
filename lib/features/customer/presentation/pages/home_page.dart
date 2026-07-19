import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../shared/widgets/cards/app_card.dart';

final class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _HomeHeader(),
          const SizedBox(height: AppSpacing.space20),
          const _SearchAction(),
          const SizedBox(height: AppSpacing.space20),
          const _SectionHeader(title: 'Categories', actionLabel: 'See all'),
          const SizedBox(height: AppSpacing.space12),
          const _CategoriesGrid(),
          const SizedBox(height: AppSpacing.space20),
          const _EmergencyBanner(),
          const SizedBox(height: AppSpacing.space20),
          const _SectionHeader(
            title: 'Top Rated Near You',
            actionLabel: 'See all',
          ),
          const SizedBox(height: AppSpacing.space12),
          const _TechniciansList(),
        ],
      ),
    );
  }
}

final class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: AppSpacing.space12,
                  color: AppColors.primary,
                ),
                const SizedBox(width: AppSpacing.space4),
                Text(
                  'Astana, Kazakhstan',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.mutedForeground,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.space4),
            Text(
              'Hi, Aigerim 👋',
              style: AppTextStyles.headlineMedium.copyWith(
                color: AppColors.foreground,
              ),
            ),
          ],
        ),
        Row(
          children: const [
            _NotificationButton(),
            SizedBox(width: AppSpacing.space8),
            _ProfileButton(),
          ],
        ),
      ],
    );
  }
}

final class _NotificationButton extends StatelessWidget {
  const _NotificationButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
    );
  }
}

final class _ProfileButton extends StatelessWidget {
  const _ProfileButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: открыть профиль.
      },
      child: SizedBox(
        width: AppSpacing.space40,
        height: AppSpacing.space40,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
          child: Center(
            child: Text(
              'AB',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.surface,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

final class _SearchAction extends StatelessWidget {
  const _SearchAction();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: открыть поиск.
      },
      child: SizedBox(
        height: AppSpacing.space48,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: AppColors.border),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space16),
            child: Row(
              children: [
                const Icon(
                  Icons.search,
                  size: AppSpacing.space16,
                  color: AppColors.mutedForeground,
                ),
                const SizedBox(width: AppSpacing.space12),
                Text(
                  'What needs fixing?',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.mutedForeground,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

final class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.actionLabel});

  final String title;
  final String actionLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title.toUpperCase(),
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.mutedForeground,
          ),
        ),
        GestureDetector(
          onTap: () {
            // TODO: открыть полный список.
          },
          child: Text(
            actionLabel,
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

final class _CategoriesGrid extends StatelessWidget {
  const _CategoriesGrid();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _CategoryItem(category: _categories[0])),
            Expanded(child: _CategoryItem(category: _categories[1])),
            Expanded(child: _CategoryItem(category: _categories[2])),
            Expanded(child: _CategoryItem(category: _categories[3])),
          ],
        ),
        SizedBox(height: AppSpacing.space12),
        Row(
          children: [
            Expanded(child: _CategoryItem(category: _categories[4])),
            Expanded(child: _CategoryItem(category: _categories[5])),
            Expanded(child: _CategoryItem(category: _categories[6])),
            Expanded(child: _CategoryItem(category: _categories[7])),
          ],
        ),
      ],
    );
  }
}

final class _CategoryItem extends StatelessWidget {
  const _CategoryItem({required this.category});

  final _Category category;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: открыть создание заказа.
      },
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
              child: Icon(
                category.icon,
                size: AppSpacing.space24,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.space8),
          Text(
            category.label,
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.mutedForeground,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

final class _EmergencyBanner extends StatelessWidget {
  const _EmergencyBanner();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: открыть срочный заказ.
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(AppRadius.card),
          boxShadow: AppShadows.primary,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.space16),
          child: Row(
            children: [
              SizedBox(
                width: AppSpacing.space40,
                height: AppSpacing.space40,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.surface.withValues(
                      alpha: AppColors.primary10.a + AppColors.primary5.a,
                    ),
                    borderRadius: BorderRadius.circular(AppRadius.large),
                  ),
                  child: const Icon(
                    Icons.bolt_outlined,
                    size: AppSpacing.space20,
                    color: AppColors.surface,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.space12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Emergency Repair',
                      style: AppTextStyles.labelLarge.copyWith(
                        color: AppColors.surface,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.space4),
                    Text(
                      'Technician within 15 minutes',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.surface.withValues(
                          alpha: AppColors.primary80.a,
                        ),
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.surface.withValues(
                    alpha: AppColors.primary20.a,
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.space12,
                    vertical: AppSpacing.space4,
                  ),
                  child: Text(
                    'CALL',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.surface,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _TechniciansList extends StatelessWidget {
  const _TechniciansList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final technician in _technicians) ...[
          AppCard(
            padding: const EdgeInsets.all(AppSpacing.space12),
            onTap: () {
              // TODO: открыть профиль мастера.
            },
            child: _TechnicianCardContent(technician: technician),
          ),
          if (technician != _technicians.last)
            const SizedBox(height: AppSpacing.space8),
        ],
      ],
    );
  }
}

final class _TechnicianCardContent extends StatelessWidget {
  const _TechnicianCardContent({required this.technician});

  final _Technician technician;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: AppSpacing.space48,
          height: AppSpacing.space48,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary20,
                  AppColors.secondary.withValues(alpha: AppColors.primary20.a),
                ],
              ),
              borderRadius: BorderRadius.circular(AppRadius.large),
            ),
            child: Center(
              child: Text(
                technician.initials,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.primary,
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
              Row(
                children: [
                  Expanded(
                    child: Text(
                      technician.name,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.foreground,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.space4),
                  const Icon(
                    Icons.star,
                    size: AppSpacing.space12,
                    color: AppColors.primary,
                  ),
                  Text(
                    technician.rating,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.space4),
              Text(
                '${technician.role} · ${technician.distance} · ${technician.eta}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.mutedForeground,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.space8),
        const Icon(
          Icons.chevron_right,
          size: AppSpacing.space16,
          color: AppColors.mutedForeground,
        ),
      ],
    );
  }
}

final class _Category {
  const _Category({required this.label, required this.icon});

  final String label;
  final IconData icon;
}

final class _Technician {
  const _Technician({
    required this.name,
    required this.initials,
    required this.role,
    required this.distance,
    required this.rating,
    required this.eta,
  });

  final String name;
  final String initials;
  final String role;
  final String distance;
  final String rating;
  final String eta;
}

const _categories = [
  _Category(label: 'Fridge', icon: Icons.kitchen_outlined),
  _Category(label: 'Washer', icon: Icons.local_laundry_service_outlined),
  _Category(label: 'AC', icon: Icons.air_outlined),
  _Category(label: 'TV', icon: Icons.tv_outlined),
  _Category(label: 'Micro', icon: Icons.microwave_outlined),
  _Category(label: 'Oven', icon: Icons.local_fire_department_outlined),
  _Category(label: 'Heater', icon: Icons.bolt_outlined),
  _Category(label: 'More', icon: Icons.more_horiz),
];

const _technicians = [
  _Technician(
    name: 'Arman Serikov',
    initials: 'AS',
    role: 'Kitchen Specialist',
    distance: '1.2 km',
    rating: '4.9',
    eta: '20 min',
  ),
  _Technician(
    name: 'Dmitry Volkov',
    initials: 'DV',
    role: 'Electronics Master',
    distance: '2.4 km',
    rating: '4.8',
    eta: '35 min',
  ),
  _Technician(
    name: 'Bauyrzhan Khan',
    initials: 'BK',
    role: 'AC & Heating',
    distance: '3.1 km',
    rating: '4.7',
    eta: '45 min',
  ),
];
