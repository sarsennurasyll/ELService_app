import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../shared/widgets/cards/app_card.dart';

final class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

final class _CalendarPageState extends State<CalendarPage> {
  var _selectedDay = 15;

  static const _busyDays = {14, 15, 17, 22};
  static const _weeks = [
    [null, null, 1, 2, 3, 4, 5],
    [6, 7, 8, 9, 10, 11, 12],
    [13, 14, 15, 16, 17, 18, 19],
    [20, 21, 22, 23, 24, 25, 26],
    [27, 28, 29, 30, 31, null, null],
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _CalendarHeader(
          onPrevious: () {
            // TODO: переключить месяц назад.
          },
          onNext: () {
            // TODO: переключить месяц вперёд.
          },
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.space20),
            children: [
              const _WeekdayLabels(),
              const SizedBox(height: AppSpacing.space8),
              _CalendarGrid(
                weeks: _weeks,
                busyDays: _busyDays,
                selectedDay: _selectedDay,
                onDaySelected: (day) {
                  setState(() => _selectedDay = day);
                },
              ),
              const SizedBox(height: AppSpacing.space24),
              Text(
                'TUE, MAR $_selectedDay',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.mutedForeground,
                ),
              ),
              const SizedBox(height: AppSpacing.space8),
              ..._buildScheduleSection(_selectedDay),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildScheduleSection(int day) {
    final events = _eventsForDay(day);
    if (events.isEmpty) {
      return [
        Text(
          'No scheduled jobs for this day.',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.mutedForeground,
          ),
        ),
      ];
    }

    return [
      for (var index = 0; index < events.length; index++) ...[
        _ScheduleEventCard(event: events[index]),
        if (index < events.length - 1) const SizedBox(height: AppSpacing.space8),
      ],
    ];
  }
}

final class _CalendarHeader extends StatelessWidget {
  const _CalendarHeader({required this.onPrevious, required this.onNext});

  final VoidCallback onPrevious;
  final VoidCallback onNext;

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
              'Calendar',
              style: AppTextStyles.headlineLarge.copyWith(
                color: AppColors.foreground,
              ),
            ),
            const SizedBox(height: AppSpacing.space16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _MonthNavButton(icon: Icons.chevron_left, onTap: onPrevious),
                Text(
                  'March 2026',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.foreground,
                  ),
                ),
                _MonthNavButton(icon: Icons.chevron_right, onTap: onNext),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

final class _MonthNavButton extends StatelessWidget {
  const _MonthNavButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: AppSpacing.space32,
        height: AppSpacing.space32,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.muted,
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
          child: Icon(icon, size: AppSpacing.space16),
        ),
      ),
    );
  }
}

final class _WeekdayLabels extends StatelessWidget {
  const _WeekdayLabels();

  static const _labels = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final label in _labels)
          Expanded(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.mutedForeground,
              ),
            ),
          ),
      ],
    );
  }
}

final class _CalendarGrid extends StatelessWidget {
  const _CalendarGrid({
    required this.weeks,
    required this.busyDays,
    required this.selectedDay,
    required this.onDaySelected,
  });

  final List<List<int?>> weeks;
  final Set<int> busyDays;
  final int selectedDay;
  final ValueChanged<int> onDaySelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final week in weeks) ...[
          Row(
            children: [
              for (final day in week)
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: day == null
                        ? const SizedBox.shrink()
                        : GestureDetector(
                            onTap: () => onDaySelected(day),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: day == selectedDay
                                    ? AppColors.primary
                                    : null,
                                borderRadius: BorderRadius.circular(
                                  AppRadius.large,
                                ),
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Text(
                                    '$day',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: day == selectedDay
                                          ? AppColors.surface
                                          : AppColors.foreground,
                                      fontWeight: day == selectedDay
                                          ? FontWeight.w700
                                          : FontWeight.w400,
                                    ),
                                  ),
                                  if (busyDays.contains(day) &&
                                      day != selectedDay)
                                    Positioned(
                                      bottom: AppSpacing.space4,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          color: AppColors.primary,
                                          borderRadius: BorderRadius.circular(
                                            AppRadius.full,
                                          ),
                                        ),
                                        child: const SizedBox(
                                          width: AppSpacing.space4,
                                          height: AppSpacing.space4,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

final class _ScheduleEventCard extends StatelessWidget {
  const _ScheduleEventCard({required this.event});

  final _ScheduleEvent event;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.space12),
      onTap: () {
        // TODO: открыть событие расписания.
      },
      child: Row(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: event.accent,
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: const SizedBox(width: AppSpacing.space4, height: AppSpacing.space40),
          ),
          const SizedBox(width: AppSpacing.space12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.time,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.mutedForeground,
                  ),
                ),
                const SizedBox(height: AppSpacing.space4),
                Text(
                  event.title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.foreground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

final class _ScheduleEvent {
  const _ScheduleEvent({
    required this.time,
    required this.title,
    required this.accent,
  });

  final String time;
  final String title;
  final Color accent;
}

List<_ScheduleEvent> _eventsForDay(int day) {
  if (day == 15) {
    return const [
      _ScheduleEvent(
        time: '10:00 – 12:00',
        title: 'Refrigerator · Aigerim B.',
        accent: AppColors.primary,
      ),
      _ScheduleEvent(
        time: '14:00 – 15:00',
        title: 'AC diagnostic · Nurlan T.',
        accent: AppColors.secondary,
      ),
      _ScheduleEvent(
        time: '16:30 – 18:00',
        title: 'Washer install · Aida M.',
        accent: AppColors.success,
      ),
    ];
  }

  if (day == 14 || day == 17 || day == 22) {
    return const [
      _ScheduleEvent(
        time: '11:00 – 13:00',
        title: 'Service visit scheduled',
        accent: AppColors.primary,
      ),
    ];
  }

  return const [];
}
