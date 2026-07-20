/// Хранение JWT access / refresh токенов.
///
/// TODO: подключить secure storage после появления Authentication.
abstract interface class TokenStorage {
  Future<void> saveAccessToken(String token);

  Future<void> saveRefreshToken(String token);

  Future<String?> getAccessToken();

  Future<String?> getRefreshToken();

  Future<void> clear();
}

/// Временное in-memory хранилище до secure storage.
final class InMemoryTokenStorage implements TokenStorage {
  String? _accessToken;
  String? _refreshToken;

  @override
  Future<void> saveAccessToken(String token) async {
    _accessToken = token;
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    _refreshToken = token;
  }

  @override
  Future<String?> getAccessToken() async => _accessToken;

  @override
  Future<String?> getRefreshToken() async => _refreshToken;

  @override
  Future<void> clear() async {
    _accessToken = null;
    _refreshToken = null;
  }
}
