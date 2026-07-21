import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/utils/result.dart';
import '../../../../shared/widgets/cards/app_card.dart';
import '../../domain/models/category.dart';
import '../../domain/repositories/category_repository.dart';

final class HomePage extends StatefulWidget {
  const HomePage({required this.categoryRepository, super.key});

  final CategoryRepository categoryRepository;

  @override
  State<HomePage> createState() => _HomePageState();
}

final class _HomePageState extends State<HomePage> {
  late final Future<Result<List<Category>>> _categoriesFuture =
      widget.categoryRepository.getCategories();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.space20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _HomeHeader(),
          const SizedBox(height: AppSpacing.space20),
          const _SearchAction(),
          const SizedBox(height: AppSpacing.space20),
          const _SectionHeader(title: 'Categories', actionLabel: 'See all'),
          const SizedBox(height: AppSpacing.space12),
          FutureBuilder<Result<List<Category>>>(
            future: _categoriesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const _CategoriesLoading();
              }

              final result = snapshot.data;
              if (result is ErrorResult<List<Category>>) {
                return _CategoriesError(message: result.failure.message);
              }
              if (result is Success<List<Category>>) {
                if (result.value.isEmpty) {
                  return const _CategoriesEmpty();
                }
                return _CategoriesGrid(categories: result.value);
              }

              return const _CategoriesError(
                message: 'Не удалось загрузить категории',
              );
            },
          ),
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
  const _CategoriesGrid({required this.categories});

  final List<Category> categories;

  @override
  Widget build(BuildContext context) {
    final rowCount = (categories.length + 3) ~/ 4;

    return Column(
      children: [
        for (var row = 0; row < rowCount; row++) ...[
          Row(
            children: [
              for (var column = 0; column < 4; column++)
                Expanded(
                  child: _buildCategoryItem(row * 4 + column),
                ),
            ],
          ),
          if (row < rowCount - 1) const SizedBox(height: AppSpacing.space12),
        ],
      ],
    );
  }

  Widget _buildCategoryItem(int index) {
    if (index >= categories.length) {
      return const SizedBox.shrink();
    }
    return _CategoryItem(category: categories[index]);
  }
}

final class _CategoryItem extends StatelessWidget {
  const _CategoryItem({required this.category});

  final Category category;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.customerCreateOrder),
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
                _categoryIcon(category),
                size: AppSpacing.space24,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.space8),
          Text(
            category.name,
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

final class _CategoriesLoading extends StatelessWidget {
  const _CategoriesLoading();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: AppSpacing.space64,
      child: Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }
}

final class _CategoriesEmpty extends StatelessWidget {
  const _CategoriesEmpty();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: AppSpacing.space64,
      child: Center(
        child: Text(
          'Категории пока не добавлены',
          style: AppTextStyles.bodySmall,
        ),
      ),
    );
  }
}

final class _CategoriesError extends StatelessWidget {
  const _CategoriesError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.space64,
      child: Center(
        child: Text(
          message,
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

final class _EmergencyBanner extends StatelessWidget {
  const _EmergencyBanner();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.customerCreateOrder),
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

IconData _categoryIcon(Category category) {
  return switch ((category.icon ?? category.name).toLowerCase()) {
    'refrigerator' || 'fridge' => Icons.kitchen_outlined,
    'washing machine' || 'washer' => Icons.local_laundry_service_outlined,
    'air conditioner' || 'ac' => Icons.air_outlined,
    'tv' || 'television' => Icons.tv_outlined,
    'microwave' || 'micro' => Icons.microwave_outlined,
    'oven' => Icons.local_fire_department_outlined,
    'water heater' || 'heater' => Icons.bolt_outlined,
    _ => Icons.build_outlined,
  };
}

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
