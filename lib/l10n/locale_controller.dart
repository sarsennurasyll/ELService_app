import 'package:flutter/material.dart';

import '../core/storage/locale_storage.dart';

final class LocaleController extends ValueNotifier<Locale?> {
  LocaleController({required LocaleStorage storage}) : _storage = storage, super(null);

  final LocaleStorage _storage;

  Future<void> restore() async {
    final localeCode = await _storage.readLocaleCode();
    if (_supportedLanguageCodes.contains(localeCode)) {
      value = Locale(localeCode!);
    }
  }

  Future<void> setLocale(Locale locale) async {
    if (!_supportedLanguageCodes.contains(locale.languageCode)) {
      return;
    }

    value = locale;
    await _storage.saveLocaleCode(locale.languageCode);
  }
}

final class LocaleScope extends InheritedNotifier<LocaleController> {
  const LocaleScope({
    required LocaleController controller,
    required super.child,
    super.key,
  }) : super(notifier: controller);

  static LocaleController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<LocaleScope>();
    assert(scope != null, 'LocaleScope is missing above this context.');
    return scope!.notifier!;
  }
}

const _supportedLanguageCodes = <String>{'ru', 'kk', 'en'};
