import '../../domain/models/user.dart';
import '../models/login_request_dto.dart';
import '../models/register_request_dto.dart';
import '../models/user_dto.dart';
import 'user_mapper.dart';

/// Мапперы auth-запросов и пользователя.
final class AuthMapper {
  const AuthMapper({this.userMapper = const UserMapper()});

  final UserMapper userMapper;

  LoginRequestDto toLoginRequest({
    required String email,
    required String password,
  }) {
    return LoginRequestDto(email: email, password: password);
  }

  RegisterRequestDto toRegisterRequest({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required String role,
  }) {
    return RegisterRequestDto(
      email: email,
      password: password,
      fullName: fullName,
      phone: phone,
      role: role,
    );
  }

  User fromUserDto(UserDto dto) => userMapper.fromDto(dto);
}
