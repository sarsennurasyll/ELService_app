import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_duration.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';

final class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

final class _SplashPageState extends State<SplashPage>
    with TickerProviderStateMixin {
  late final AnimationController _contentController;
  late final AnimationController _actionsController;

  @override
  void initState() {
    super.initState();
    _contentController = AnimationController(
      vsync: this,
      duration: AppDuration.reveal,
    )..forward();
    _actionsController = AnimationController(
      vsync: this,
      duration: AppDuration.reveal,
    );
    Future<void>.delayed(AppDuration.sheetClose, () {
      if (mounted) {
        _actionsController.forward();
      }
    });
  }

  @override
  void dispose() {
    _contentController.dispose();
    _actionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, AppColors.primary, AppColors.secondary],
          ),
        ),
        child: Stack(
          children: [
            _Glow(
              top: AppSpacing.space40,
              left: -AppSpacing.space80,
              size: AppSpacing.space64 * AppSpacing.space4,
            ),
            _Glow(
              right: -AppSpacing.space80,
              bottom: AppSpacing.space80,
              size: AppSpacing.space64 + AppSpacing.space8,
            ),
            Center(
              child: _Reveal(
                animation: _contentController,
                child: const _Brand(),
              ),
            ),
            Positioned(
              right: AppSpacing.space32,
              bottom: AppSpacing.space56,
              left: AppSpacing.space32,
              child: _Reveal(
                animation: _actionsController,
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _SplashAction(label: 'Get Started'),
                    SizedBox(height: AppSpacing.space12),
                    _SplashAction(
                      label: 'I already have an account',
                      isPrimary: false,
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

final class _Glow extends StatelessWidget {
  const _Glow({
    required this.size,
    this.top,
    this.right,
    this.bottom,
    this.left,
  });

  final double size;
  final double? top;
  final double? right;
  final double? bottom;
  final double? left;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      right: right,
      bottom: bottom,
      left: left,
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(
          sigmaX: AppSpacing.space24,
          sigmaY: AppSpacing.space24,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: AppColors.primary10.a),
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
          child: SizedBox(width: size, height: size),
        ),
      ),
    );
  }
}

final class _Brand extends StatelessWidget {
  const _Brand();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: AppSpacing.space96,
          height: AppSpacing.space96,
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(
              alpha: AppColors.primary10.a + AppColors.primary5.a,
            ),
            borderRadius: BorderRadius.circular(AppRadius.extraLarge),
            border: Border.all(
              color: AppColors.surface.withValues(alpha: AppColors.primary20.a),
            ),
            boxShadow: AppShadows.twoXl,
          ),
          child: const Center(
            child: Icon(
              Icons.build_outlined,
              size: AppSpacing.space40 + AppSpacing.space4,
              color: AppColors.surface,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.space20),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'ELService',
              style: AppTextStyles.displayLarge.copyWith(
                color: AppColors.surface,
              ),
            ),
            const SizedBox(height: AppSpacing.space4),
            Text(
              'Repair, simplified.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.surface.withValues(
                  alpha: AppColors.primary80.a,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

final class _SplashAction extends StatelessWidget {
  const _SplashAction({required this.label, this.isPrimary = true});

  final String label;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final foregroundColor = isPrimary ? AppColors.primary : AppColors.surface;
    return SizedBox(
      width: double.infinity,
      height: isPrimary
          ? AppSpacing.space48
          : AppSpacing.space32 + AppSpacing.space12,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: isPrimary ? AppColors.surface : null,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: isPrimary
              ? null
              : Border.all(
                  color: AppColors.surface.withValues(
                    alpha: AppColors.primary30.a,
                  ),
                ),
        ),
        child: Center(
          child: Text(
            label,
            style:
                (isPrimary
                        ? AppTextStyles.labelLarge
                        : AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ))
                    .copyWith(color: foregroundColor),
          ),
        ),
      ),
    );
  }
}

final class _Reveal extends StatelessWidget {
  const _Reveal({required this.animation, required this.child});

  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: const Cubic(0.16, 1, 0.3, 1),
    );

    return AnimatedBuilder(
      animation: curvedAnimation,
      child: child,
      builder: (context, child) {
        return Opacity(
          opacity: curvedAnimation.value,
          child: Transform.translate(
            offset: Offset(0, AppSpacing.space20 * (1 - curvedAnimation.value)),
            child: child,
          ),
        );
      },
    );
  }
}
