/// Хранение JWT-токена.
///
/// TODO: подключить secure storage после появления Authentication.
abstract interface class TokenStorage {
  Future<void> saveToken(String token);

  Future<String?> getToken();

  Future<void> removeToken();
}

/// Временное in-memory хранилище до secure storage.
final class InMemoryTokenStorage implements TokenStorage {
  String? _token;

  @override
  Future<void> saveToken(String token) async {
    _token = token;
  }

  @override
  Future<String?> getToken() async => _token;

  @override
  Future<void> removeToken() async {
    _token = null;
  }
}
