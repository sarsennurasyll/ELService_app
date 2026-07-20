import '../models/user_dto.dart';

/// Удалённый источник данных авторизации.
///
/// TODO: подключить RemoteDataSource к Node.js REST API.
abstract interface class AuthRemoteDataSource {
  Future<UserDto> login({
    required String email,
    required String password,
  });

  Future<UserDto> register({
    required String email,
    required String password,
    required String name,
  });

  Future<void> logout();

  Future<UserDto?> getCurrentUser();
}

final class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl();

  @override
  Future<UserDto> login({
    required String email,
    required String password,
  }) {
    // TODO: JWT login через ApiClient.
    throw UnimplementedError('TODO: RemoteDataSource.login');
  }

  @override
  Future<UserDto> register({
    required String email,
    required String password,
    required String name,
  }) {
    // TODO: регистрация через ApiClient.
    throw UnimplementedError('TODO: RemoteDataSource.register');
  }

  @override
  Future<void> logout() {
    // TODO: logout и очистка JWT.
    throw UnimplementedError('TODO: RemoteDataSource.logout');
  }

  @override
  Future<UserDto?> getCurrentUser() {
    // TODO: текущий пользователь через ApiClient.
    throw UnimplementedError('TODO: RemoteDataSource.getCurrentUser');
  }
}
