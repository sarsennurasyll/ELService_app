import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../../../shared/widgets/cards/app_card.dart';
import '../../../../shared/widgets/inputs/app_text_field.dart';
import '../../../../shared/widgets/layout/app_top_bar.dart';
import '../../../../shared/widgets/layout/screen.dart';

final class CreateOrderPage extends StatefulWidget {
  const CreateOrderPage({super.key});

  @override
  State<CreateOrderPage> createState() => _CreateOrderPageState();
}

final class _CreateOrderPageState extends State<CreateOrderPage> {
  late final TextEditingController _descriptionController;
  late final TextEditingController _addressController;
  var _selectedCategoryIndex = 0;
  var _selectedTimeIndex = 1;
  var _photoCount = 2;

  static const _categories = [
    _CategoryOption(label: 'Fridge', icon: Icons.kitchen_outlined),
    _CategoryOption(label: 'Washer', icon: Icons.local_laundry_service_outlined),
    _CategoryOption(label: 'AC', icon: Icons.air_outlined),
    _CategoryOption(label: 'TV', icon: Icons.tv_outlined),
  ];

  static const _timeSlots = [
    'Today · 14:00 – 16:00',
    'Tomorrow · 10:00 – 12:00',
    'Tomorrow · 16:00 – 18:00',
    'Wed 16 · 10:00 – 12:00',
  ];

  static const _applianceModels = [
    'Samsung Refrigerator RB37',
    'LG Washer TwinWash',
    'Haier AC Split 12',
    'Sony Bravia XR',
  ];

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(
      text:
          'Water leaking from bottom of the fridge. Freezer is still cold but the main compartment is warm.',
    );
    _addressController = TextEditingController(
      text: 'Respublika Ave 14, Apt 42',
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Screen(
      padding: EdgeInsets.zero,
      appBar: AppTopBar(
        title: 'New Repair Request',
        subtitle: 'Fill in details step by step',
        onBack: () => context.pop(),
      ),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.space20),
              children: [
                const _StepIndicator(currentStep: 4, totalSteps: 4),
                const SizedBox(height: AppSpacing.space16),
                _CategorySection(
                  categories: _categories,
                  selectedIndex: _selectedCategoryIndex,
                  selectedModel: _applianceModels[_selectedCategoryIndex],
                  onCategorySelected: (index) {
                    setState(() => _selectedCategoryIndex = index);
                  },
                ),
                const SizedBox(height: AppSpacing.space16),
                Text(
                  'DESCRIBE THE PROBLEM',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.mutedForeground,
                  ),
                ),
                const SizedBox(height: AppSpacing.space8),
                SizedBox(
                  height: AppSpacing.space96,
                  child: AppTextField(
                    controller: _descriptionController,
                    isMultiline: true,
                    onChanged: (_) {
                      // TODO: сохранить описание проблемы.
                    },
                  ),
                ),
                const SizedBox(height: AppSpacing.space16),
                _PhotosSection(
                  photoCount: _photoCount,
                  onManage: () {
                    // TODO: открыть управление фотографиями.
                  },
                  onAdd: () {
                    // TODO: прикрепить фотографию.
                    setState(() {
                      if (_photoCount < 6) {
                        _photoCount += 1;
                      }
                    });
                  },
                ),
                const SizedBox(height: AppSpacing.space16),
                AppTextField(
                  controller: _addressController,
                  label: 'ADDRESS',
                  prefixIcon: const Icon(
                    Icons.location_on_outlined,
                    color: AppColors.primary,
                  ),
                  onChanged: (_) {
                    // TODO: сохранить адрес.
                  },
                ),
                const SizedBox(height: AppSpacing.space16),
                _TimeSection(
                  slots: _timeSlots,
                  selectedIndex: _selectedTimeIndex,
                  onSelected: (index) {
                    setState(() => _selectedTimeIndex = index);
                  },
                ),
                const SizedBox(height: AppSpacing.space16),
                const _EstimatedRangeCard(),
              ],
            ),
          ),
          DecoratedBox(
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.space20),
              child: PrimaryButton(
                label: 'Submit request',
                onPressed: () {
                  // TODO: отправить заказ.
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.currentStep, required this.totalSteps});

  final int currentStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var step = 1; step <= totalSteps; step++) ...[
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: step <= currentStep
                    ? AppColors.primary
                    : AppColors.border,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: const SizedBox(height: AppSpacing.space4),
            ),
          ),
          if (step < totalSteps) const SizedBox(width: AppSpacing.space8),
        ],
      ],
    );
  }
}

final class _CategorySection extends StatelessWidget {
  const _CategorySection({
    required this.categories,
    required this.selectedIndex,
    required this.selectedModel,
    required this.onCategorySelected,
  });

  final List<_CategoryOption> categories;
  final int selectedIndex;
  final String selectedModel;
  final ValueChanged<int> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'APPLIANCE',
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.mutedForeground,
          ),
        ),
        const SizedBox(height: AppSpacing.space8),
        Row(
          children: [
            for (var index = 0; index < categories.length; index++) ...[
              Expanded(
                child: _CategoryChip(
                  category: categories[index],
                  isSelected: index == selectedIndex,
                  onTap: () => onCategorySelected(index),
                ),
              ),
              if (index < categories.length - 1)
                const SizedBox(width: AppSpacing.space8),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.space12),
        AppCard(
          onTap: () {
            // TODO: выбрать модель техники.
          },
          child: Row(
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
                    categories[selectedIndex].icon,
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
                      'MODEL',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.mutedForeground,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.space4),
                    Text(
                      selectedModel,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.foreground,
                        fontWeight: FontWeight.w600,
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
        ),
      ],
    );
  }
}

final class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  final _CategoryOption category;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 1,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: isSelected ? null : Border.all(color: AppColors.border),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                category.icon,
                size: AppSpacing.space24,
                color: isSelected
                    ? AppColors.surface
                    : AppColors.mutedForeground,
              ),
              const SizedBox(height: AppSpacing.space4),
              Text(
                category.label,
                style: AppTextStyles.labelSmall.copyWith(
                  color: isSelected
                      ? AppColors.surface
                      : AppColors.mutedForeground,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _PhotosSection extends StatelessWidget {
  const _PhotosSection({
    required this.photoCount,
    required this.onManage,
    required this.onAdd,
  });

  final int photoCount;
  final VoidCallback onManage;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'PHOTOS (OPTIONAL)',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.mutedForeground,
              ),
            ),
            GestureDetector(
              onTap: onManage,
              child: Text(
                'Manage',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.space8),
        Row(
          children: [
            Expanded(
              child: _PhotoTile(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary20,
                    AppColors.secondary.withValues(alpha: AppColors.primary20.a),
                  ],
                ),
                child: photoCount > 0
                    ? const Icon(
                        Icons.camera_alt_outlined,
                        size: AppSpacing.space20,
                        color: AppColors.primary,
                      )
                    : null,
              ),
            ),
            const SizedBox(width: AppSpacing.space8),
            Expanded(
              child: _PhotoTile(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.warning.withValues(alpha: AppColors.primary20.a),
                    AppColors.error.withValues(alpha: AppColors.primary20.a),
                  ],
                ),
                child: photoCount > 1 ? null : const SizedBox.shrink(),
              ),
            ),
            const SizedBox(width: AppSpacing.space8),
            Expanded(
              child: GestureDetector(
                onTap: onAdd,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.large),
                      border: Border.all(color: AppColors.border, width: 2),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.add,
                        size: AppSpacing.space20,
                        color: AppColors.mutedForeground,
                      ),
                    ),
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

final class _PhotoTile extends StatelessWidget {
  const _PhotoTile({required this.gradient, this.child});

  final Gradient gradient;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(AppRadius.large),
        ),
        child: child == null ? null : Center(child: child),
      ),
    );
  }
}

final class _TimeSection extends StatelessWidget {
  const _TimeSection({
    required this.slots,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<String> slots;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'WHEN',
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.mutedForeground,
          ),
        ),
        const SizedBox(height: AppSpacing.space8),
        for (var index = 0; index < slots.length; index++) ...[
          AppCard(
            variant: AppCardVariant.selectable,
            isSelected: index == selectedIndex,
            onTap: () => onSelected(index),
            child: Row(
              children: [
                SizedBox(
                  width: AppSpacing.space40,
                  height: AppSpacing.space40,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.primary10,
                      borderRadius: BorderRadius.circular(AppRadius.large),
                    ),
                    child: const Icon(
                      Icons.calendar_today_outlined,
                      size: AppSpacing.space20,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.space12),
                Expanded(
                  child: Text(
                    slots[index],
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.foreground,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(
                  index == selectedIndex
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  size: AppSpacing.space20,
                  color: index == selectedIndex
                      ? AppColors.primary
                      : AppColors.mutedForeground,
                ),
              ],
            ),
          ),
          if (index < slots.length - 1)
            const SizedBox(height: AppSpacing.space8),
        ],
      ],
    );
  }
}

final class _EstimatedRangeCard extends StatelessWidget {
  const _EstimatedRangeCard();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.primary5,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.primary10),
        boxShadow: AppShadows.sm,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.space16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: AppSpacing.space32,
              height: AppSpacing.space32,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.primary10,
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                ),
                child: const Icon(
                  Icons.attach_money,
                  size: AppSpacing.space16,
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
                    'ESTIMATED RANGE',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.space4),
                  Text(
                    '15 000 – 25 000 ₸',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.foreground,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.space4),
                  Text(
                    "Final price set by the technician's offer",
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.mutedForeground,
                      letterSpacing: 0,
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

final class _CategoryOption {
  const _CategoryOption({required this.label, required this.icon});

  final String label;
  final IconData icon;
}
