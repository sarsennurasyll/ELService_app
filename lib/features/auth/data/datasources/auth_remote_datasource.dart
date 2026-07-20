import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/login_request_dto.dart';
import '../models/login_response_dto.dart';
import '../models/refresh_token_dto.dart';
import '../models/register_request_dto.dart';
import '../models/user_dto.dart';

/// Удалённый источник данных авторизации.
///
/// TODO: отключить mock и использовать ответы Node.js Backend.
abstract interface class AuthRemoteDataSource {
  Future<LoginResponseDto> login(LoginRequestDto request);

  Future<LoginResponseDto> register(RegisterRequestDto request);

  Future<LoginResponseDto> refreshToken(RefreshTokenDto request);

  Future<void> logout();
}

final class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  final ApiClient _apiClient;

  /// Пока Backend недоступен — возвращаем mock.
  /// TODO: установить в false после появления Node.js API.
  static const _useMockResponses = true;

  @override
  Future<LoginResponseDto> login(LoginRequestDto request) async {
    if (_useMockResponses) {
      return _mockLoginResponse(email: request.email, name: 'User');
    }

    final json = await _apiClient.post(
      ApiEndpoints.authLogin,
      body: request.toMap(),
    );
    return LoginResponseDto.fromMap(json);
  }

  @override
  Future<LoginResponseDto> register(RegisterRequestDto request) async {
    if (_useMockResponses) {
      return _mockLoginResponse(email: request.email, name: request.name);
    }

    final json = await _apiClient.post(
      ApiEndpoints.authRegister,
      body: request.toMap(),
    );
    return LoginResponseDto.fromMap(json);
  }

  @override
  Future<LoginResponseDto> refreshToken(RefreshTokenDto request) async {
    if (_useMockResponses) {
      return _mockLoginResponse(email: 'user@example.com', name: 'User');
    }

    final json = await _apiClient.post(
      ApiEndpoints.authRefresh,
      body: request.toMap(),
    );
    return LoginResponseDto.fromMap(json);
  }

  @override
  Future<void> logout() async {
    if (_useMockResponses) {
      return;
    }

    await _apiClient.post(ApiEndpoints.authLogout);
  }

  LoginResponseDto _mockLoginResponse({
    required String email,
    required String name,
  }) {
    return LoginResponseDto(
      accessToken: 'mock_access_token',
      refreshToken: 'mock_refresh_token',
      user: UserDto(
        id: 'mock-user-id',
        email: email,
        name: name,
        role: 'customer',
      ),
    );
  }
}
