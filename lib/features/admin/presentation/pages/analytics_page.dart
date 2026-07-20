import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../shared/widgets/cards/app_card.dart';

final class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.space20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Analytics',
            style: AppTextStyles.headlineLarge.copyWith(
              color: AppColors.foreground,
            ),
          ),
          const SizedBox(height: AppSpacing.space4),
          Text(
            'Mar 1 – Mar 15',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.mutedForeground,
            ),
          ),
          const SizedBox(height: AppSpacing.space16),
          const _KpiGrid(),
          const SizedBox(height: AppSpacing.space16),
          const _RevenueTrendCard(),
          const SizedBox(height: AppSpacing.space16),
          const _TopCitiesCard(),
          const SizedBox(height: AppSpacing.space16),
          const _ServiceMetricsCard(),
        ],
      ),
    );
  }
}

final class _KpiGrid extends StatelessWidget {
  const _KpiGrid();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _KpiCard(kpi: _kpis[0])),
            const SizedBox(width: AppSpacing.space12),
            Expanded(child: _KpiCard(kpi: _kpis[1])),
          ],
        ),
        const SizedBox(height: AppSpacing.space12),
        Row(
          children: [
            Expanded(child: _KpiCard(kpi: _kpis[2])),
            const SizedBox(width: AppSpacing.space12),
            Expanded(child: _KpiCard(kpi: _kpis[3])),
          ],
        ),
      ],
    );
  }
}

final class _KpiCard extends StatelessWidget {
  const _KpiCard({required this.kpi});

  final _KpiItem kpi;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            kpi.label.toUpperCase(),
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.mutedForeground,
            ),
          ),
          const SizedBox(height: AppSpacing.space4),
          Text(
            kpi.value,
            style: AppTextStyles.headlineMedium.copyWith(
              color: AppColors.foreground,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: AppSpacing.space4),
          Row(
            children: [
              const Icon(
                Icons.trending_up,
                size: AppSpacing.space12,
                color: AppColors.success,
              ),
              const SizedBox(width: AppSpacing.space4),
              Text(
                kpi.delta,
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

final class _RevenueTrendCard extends StatelessWidget {
  const _RevenueTrendCard();

  static const _points = [
    Offset(0, 100),
    Offset(30, 90),
    Offset(60, 70),
    Offset(90, 75),
    Offset(120, 55),
    Offset(150, 60),
    Offset(180, 40),
    Offset(210, 50),
    Offset(240, 30),
    Offset(270, 25),
    Offset(300, 15),
  ];

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'REVENUE TREND',
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.mutedForeground,
            ),
          ),
          const SizedBox(height: AppSpacing.space12),
          SizedBox(
            height: AppSpacing.space96 + AppSpacing.space32,
            child: CustomPaint(
              painter: _RevenueTrendPainter(points: _points),
              child: const SizedBox.expand(),
            ),
          ),
        ],
      ),
    );
  }
}

final class _RevenueTrendPainter extends CustomPainter {
  const _RevenueTrendPainter({required this.points});

  final List<Offset> points;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    for (var index = 0; index < points.length; index++) {
      final point = Offset(
        points[index].dx / 300 * size.width,
        points[index].dy / 120 * size.height,
      );
      if (index == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }

    final paint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _RevenueTrendPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

final class _TopCitiesCard extends StatelessWidget {
  const _TopCitiesCard();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'TOP CITIES',
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.mutedForeground,
            ),
          ),
          const SizedBox(height: AppSpacing.space12),
          for (final city in _cities) ...[
            _CityProgress(city: city),
            if (city != _cities.last) const SizedBox(height: AppSpacing.space8),
          ],
        ],
      ),
    );
  }
}

final class _CityProgress extends StatelessWidget {
  const _CityProgress({required this.city});

  final _CityShare city;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              city.name,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.foreground,
              ),
            ),
            Text(
              '${city.percent}%',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.foreground,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.space4),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.full),
          child: SizedBox(
            height: AppSpacing.space8,
            child: LinearProgressIndicator(
              value: city.percent / 100,
              backgroundColor: AppColors.muted,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}

final class _ServiceMetricsCard extends StatelessWidget {
  const _ServiceMetricsCard();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'SERVICE METRICS',
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.mutedForeground,
            ),
          ),
          const SizedBox(height: AppSpacing.space12),
          for (final metric in _serviceMetrics) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  metric.label,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.mutedForeground,
                  ),
                ),
                Text(
                  metric.value,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.foreground,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            if (metric != _serviceMetrics.last)
              const SizedBox(height: AppSpacing.space12),
          ],
        ],
      ),
    );
  }
}

final class _KpiItem {
  const _KpiItem({
    required this.label,
    required this.value,
    required this.delta,
  });

  final String label;
  final String value;
  final String delta;
}

final class _CityShare {
  const _CityShare({required this.name, required this.percent});

  final String name;
  final int percent;
}

final class _ServiceMetric {
  const _ServiceMetric({required this.label, required this.value});

  final String label;
  final String value;
}

const _kpis = [
  _KpiItem(label: 'GMV', value: '42.3M ₸', delta: '+22%'),
  _KpiItem(label: 'Net revenue', value: '6.4M ₸', delta: '+18%'),
  _KpiItem(label: 'New users', value: '1,240', delta: '+12%'),
  _KpiItem(label: 'Conversion', value: '68%', delta: '+3%'),
];

const _cities = [
  _CityShare(name: 'Astana', percent: 48),
  _CityShare(name: 'Almaty', percent: 32),
  _CityShare(name: 'Shymkent', percent: 12),
  _CityShare(name: 'Karaganda', percent: 8),
];

const _serviceMetrics = [
  _ServiceMetric(label: 'Orders completed', value: '4,812'),
  _ServiceMetric(label: 'Avg order value', value: '17 400 ₸'),
  _ServiceMetric(label: 'Technician utilization', value: '76%'),
  _ServiceMetric(label: 'Customer satisfaction', value: '4.8 ★'),
];
