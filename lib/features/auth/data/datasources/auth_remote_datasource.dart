import '../../../../core/errors/api_exception.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/login_request_dto.dart';
import '../models/login_response_dto.dart';
import '../models/refresh_token_dto.dart';
import '../models/register_request_dto.dart';

/// Удалённый источник данных авторизации.
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

  @override
  Future<LoginResponseDto> login(LoginRequestDto request) async {
    final json = await _apiClient.post(
      ApiEndpoints.authLogin,
      body: request.toMap(),
    );
    return LoginResponseDto.fromMap(_responseData(json));
  }

  @override
  Future<LoginResponseDto> register(RegisterRequestDto request) async {
    final json = await _apiClient.post(
      ApiEndpoints.authRegister,
      body: request.toMap(),
    );
    return LoginResponseDto.fromMap(_responseData(json));
  }

  @override
  Future<LoginResponseDto> refreshToken(RefreshTokenDto request) async {
    final json = await _apiClient.post(
      ApiEndpoints.authRefresh,
      body: request.toMap(),
    );
    return LoginResponseDto.fromMap(_responseData(json));
  }

  @override
  Future<void> logout() async {
    await _apiClient.post(ApiEndpoints.authLogout);
  }

  Map<String, dynamic> _responseData(Map<String, dynamic> response) {
    final data = response['data'];
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }

    throw const ApiException(message: 'Некорректный ответ сервера');
  }
}
