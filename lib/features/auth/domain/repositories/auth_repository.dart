import '../../../../core/utils/result.dart';
import '../models/user.dart';

/// Контракт репозитория авторизации.
///
/// TODO: подключить Repository к RemoteDataSource и JWT.
abstract interface class AuthRepository {
  Future<Result<User>> login({
    required String email,
    required String password,
  });

  Future<Result<User>> register({
    required String email,
    required String password,
    required String name,
  });

  Future<Result<void>> logout();

  Future<Result<User?>> getCurrentUser();
}
