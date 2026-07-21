import '../../../../core/errors/api_exception.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/network_exception.dart';
import '../../../../core/utils/result.dart';
import '../../domain/models/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_datasource.dart';
import '../mappers/user_mapper.dart';

final class UserRepositoryImpl implements UserRepository {
  const UserRepositoryImpl({
    required UserRemoteDataSource remoteDataSource,
    this.userMapper = const UserMapper(),
  }) : _remoteDataSource = remoteDataSource;

  final UserRemoteDataSource _remoteDataSource;
  final UserMapper userMapper;

  @override
  Future<Result<User>> getCurrentUser() async {
    try {
      final user = await _remoteDataSource.getCurrentUser();
      return Success(userMapper.fromDto(user));
    } on Exception catch (error) {
      return ErrorResult(_mapFailure(error));
    }
  }

  @override
  Future<Result<User>> updateCurrentUser({
    String? fullName,
    String? phone,
    String? avatar,
    String? city,
  }) async {
    try {
      final user = await _remoteDataSource.updateCurrentUser(
        fullName: fullName,
        phone: phone,
        avatar: avatar,
        city: city,
      );
      return Success(userMapper.fromDto(user));
    } on Exception catch (error) {
      return ErrorResult(_mapFailure(error));
    }
  }

  Failure _mapFailure(Exception error) {
    if (error is ApiException) {
      return Failure(
        message: error.message,
        code: error.code,
        statusCode: error.statusCode,
      );
    }
    if (error is NetworkException) {
      return Failure(message: error.message);
    }
    return Failure(message: error.toString());
  }
}
