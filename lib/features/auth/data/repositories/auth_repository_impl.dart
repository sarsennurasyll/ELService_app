import '../../../../core/errors/failure.dart';
import '../../../../core/utils/result.dart';
import '../../domain/models/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../mappers/user_mapper.dart';

/// Реализация [AuthRepository].
///
/// TODO: подключить Repository к RemoteDataSource и TokenStorage.
final class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required UserMapper userMapper,
  }) : _remoteDataSource = remoteDataSource,
       _userMapper = userMapper;

  final AuthRemoteDataSource _remoteDataSource;
  final UserMapper _userMapper;

  @override
  Future<Result<User>> login({
    required String email,
    required String password,
  }) async {
    // TODO: сохранить JWT после успешного ответа Backend.
    try {
      final dto = await _remoteDataSource.login(
        email: email,
        password: password,
      );
      return Success(_userMapper.fromDto(dto));
    } on Exception catch (error) {
      return ErrorResult(Failure(message: error.toString()));
    }
  }

  @override
  Future<Result<User>> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final dto = await _remoteDataSource.register(
        email: email,
        password: password,
        name: name,
      );
      return Success(_userMapper.fromDto(dto));
    } on Exception catch (error) {
      return ErrorResult(Failure(message: error.toString()));
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await _remoteDataSource.logout();
      return const Success(null);
    } on Exception catch (error) {
      return ErrorResult(Failure(message: error.toString()));
    }
  }

  @override
  Future<Result<User?>> getCurrentUser() async {
    try {
      final dto = await _remoteDataSource.getCurrentUser();
      if (dto == null) {
        return const Success(null);
      }
      return Success(_userMapper.fromDto(dto));
    } on Exception catch (error) {
      return ErrorResult(Failure(message: error.toString()));
    }
  }
}
