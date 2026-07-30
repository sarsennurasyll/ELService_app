import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract interface class LocaleStorage {
  Future<String?> readLocaleCode();

  Future<void> saveLocaleCode(String localeCode);
}

final class SecureLocaleStorage implements LocaleStorage {
  SecureLocaleStorage({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  static const _localeKey = 'app_locale';

  final FlutterSecureStorage _storage;

  @override
  Future<String?> readLocaleCode() {
    return _storage.read(key: _localeKey);
  }

  @override
  Future<void> saveLocaleCode(String localeCode) {
    return _storage.write(key: _localeKey, value: localeCode);
  }
}
