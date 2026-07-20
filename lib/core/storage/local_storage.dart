/// Локальное хранилище простых значений.
///
/// TODO: подключить реализацию (например SharedPreferences).
abstract interface class LocalStorage {
  Future<String?> readString(String key);

  Future<void> writeString(String key, String value);

  Future<void> remove(String key);

  Future<void> clear();
}

/// Заглушка до выбора пакета хранения.
final class InMemoryLocalStorage implements LocalStorage {
  final Map<String, String> _values = {};

  @override
  Future<String?> readString(String key) async => _values[key];

  @override
  Future<void> writeString(String key, String value) async {
    _values[key] = value;
  }

  @override
  Future<void> remove(String key) async {
    _values.remove(key);
  }

  @override
  Future<void> clear() async {
    _values.clear();
  }
}
