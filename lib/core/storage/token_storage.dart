/// Хранение JWT-токена.
///
/// TODO: подключить JWT и secure storage.
abstract interface class TokenStorage {
  /// TODO: сохранить access token.
  Future<void> saveToken(String token);

  /// TODO: прочитать access token.
  Future<String?> getToken();

  /// TODO: удалить access token.
  Future<void> removeToken();
}

/// Заглушка до интеграции с Backend.
final class UnimplementedTokenStorage implements TokenStorage {
  const UnimplementedTokenStorage();

  @override
  Future<void> saveToken(String token) {
    throw UnimplementedError('TODO: TokenStorage.saveToken');
  }

  @override
  Future<String?> getToken() {
    throw UnimplementedError('TODO: TokenStorage.getToken');
  }

  @override
  Future<void> removeToken() {
    throw UnimplementedError('TODO: TokenStorage.removeToken');
  }
}
