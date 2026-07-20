import '../../../../core/utils/result.dart';
import '../models/session.dart';

/// Контракт репозитория авторизации.
///
/// TODO: подключить к реальному Node.js Backend.
abstract interface class AuthRepository {
  Future<Result<Session>> login({
    required String email,
    required String password,
  });

  Future<Result<Session>> register({
    required String email,
    required String password,
    required String name,
  });

  Future<Result<void>> logout();

  Future<Result<Session>> refreshToken();
}
