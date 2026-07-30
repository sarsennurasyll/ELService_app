import 'dart:async';

import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../l10n/app_localizations.dart';
import '../../../l10n/locale_controller.dart';

Future<void> showLanguageSettingsSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    builder: (context) => const _LanguageSettingsSheet(),
  );
}

final class _LanguageSettingsSheet extends StatelessWidget {
  const _LanguageSettingsSheet();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final controller = LocaleScope.of(context);
    final selectedCode = controller.value?.languageCode ??
        Localizations.localeOf(context).languageCode;

    return RadioGroup<String>(
      groupValue: selectedCode,
      onChanged: (localeCode) {
        if (localeCode == null) {
          return;
        }
        unawaited(_selectLocale(context, controller, localeCode));
      },
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.space20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizations.language,
                style: AppTextStyles.titleLarge.copyWith(
                  color: AppColors.foreground,
                ),
              ),
              const SizedBox(height: AppSpacing.space12),
              _LanguageOption(
                locale: const Locale('ru'),
                label: localizations.russian,
              ),
              _LanguageOption(
                locale: const Locale('kk'),
                label: localizations.kazakh,
              ),
              _LanguageOption(
                locale: const Locale('en'),
                label: localizations.english,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.locale,
    required this.label,
  });

  final Locale locale;
  final String label;

  @override
  Widget build(BuildContext context) {
    return RadioListTile<String>(
      value: locale.languageCode,
      title: Text(label),
      activeColor: AppColors.primary,
      contentPadding: EdgeInsets.zero,
    );
  }
}

Future<void> _selectLocale(
  BuildContext context,
  LocaleController controller,
  String localeCode,
) async {
  await controller.setLocale(Locale(localeCode));
  if (context.mounted) {
    Navigator.of(context).pop();
  }
}
