import '../../../../core/errors/api_exception.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/user_dto.dart';

abstract interface class UserRemoteDataSource {
  Future<UserDto> getCurrentUser();

  Future<UserDto> updateCurrentUser({
    String? fullName,
    String? phone,
    String? avatar,
    String? city,
  });
}

final class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  const UserRemoteDataSourceImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<UserDto> getCurrentUser() async {
    final response = await _apiClient.get('${ApiEndpoints.users}/me');
    return _userFromJson(response['data']);
  }

  @override
  Future<UserDto> updateCurrentUser({
    String? fullName,
    String? phone,
    String? avatar,
    String? city,
  }) async {
    final response = await _apiClient.patch(
      '${ApiEndpoints.users}/me',
      body: UserDto.toUpdateMap(
        fullName: fullName,
        phone: phone,
        avatar: avatar,
        city: city,
      ),
    );
    return _userFromJson(response['data']);
  }

  UserDto _userFromJson(dynamic json) {
    if (json is! Map) {
      throw const ApiException(message: 'Некорректный ответ сервера');
    }
    return UserDto.fromMap(Map<String, dynamic>.from(json));
  }
}
