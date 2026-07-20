import '../../../../core/errors/api_exception.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/network_exception.dart';
import '../../../../core/storage/token_storage.dart';
import '../../../../core/utils/result.dart';
import '../../domain/models/session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../mappers/auth_mapper.dart';
import '../mappers/session_mapper.dart';
import '../models/refresh_token_dto.dart';

/// Реализация [AuthRepository].
final class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required TokenStorage tokenStorage,
    this.authMapper = const AuthMapper(),
    this.sessionMapper = const SessionMapper(),
  }) : _remoteDataSource = remoteDataSource,
       _tokenStorage = tokenStorage;

  final AuthRemoteDataSource _remoteDataSource;
  final TokenStorage _tokenStorage;
  final AuthMapper authMapper;
  final SessionMapper sessionMapper;

  @override
  Future<Result<Session>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _remoteDataSource.login(
        authMapper.toLoginRequest(email: email, password: password),
      );
      final session = sessionMapper.fromLoginResponse(response);
      await _persistSession(session);
      return Success(session);
    } on Exception catch (error) {
      return ErrorResult(_mapFailure(error));
    }
  }

  @override
  Future<Result<Session>> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final response = await _remoteDataSource.register(
        authMapper.toRegisterRequest(
          email: email,
          password: password,
          name: name,
        ),
      );
      final session = sessionMapper.fromLoginResponse(response);
      await _persistSession(session);
      return Success(session);
    } on Exception catch (error) {
      return ErrorResult(_mapFailure(error));
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await _remoteDataSource.logout();
      await _tokenStorage.clear();
      return const Success(null);
    } on Exception catch (error) {
      await _tokenStorage.clear();
      return ErrorResult(_mapFailure(error));
    }
  }

  @override
  Future<Result<Session>> refreshToken() async {
    try {
      final refreshToken = await _tokenStorage.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        return const ErrorResult(
          Failure(message: 'Refresh token отсутствует'),
        );
      }

      final response = await _remoteDataSource.refreshToken(
        RefreshTokenDto(refreshToken: refreshToken),
      );
      final session = sessionMapper.fromLoginResponse(response);
      await _persistSession(session);
      return Success(session);
    } on Exception catch (error) {
      return ErrorResult(_mapFailure(error));
    }
  }

  Future<void> _persistSession(Session session) async {
    await _tokenStorage.saveAccessToken(session.accessToken);
    await _tokenStorage.saveRefreshToken(session.refreshToken);
  }

  Failure _mapFailure(Exception error) {
    if (error is ApiException) {
      return Failure(message: error.message, code: error.code);
    }
    if (error is NetworkException) {
      return Failure(message: error.message);
    }
    return Failure(message: error.toString());
  }
}
