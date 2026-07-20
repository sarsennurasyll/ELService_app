import '../../domain/models/session.dart';
import '../models/login_response_dto.dart';
import 'user_mapper.dart';

/// Маппер LoginResponseDto → Session.
final class SessionMapper {
  const SessionMapper({this.userMapper = const UserMapper()});

  final UserMapper userMapper;

  Session fromLoginResponse(LoginResponseDto dto) {
    return Session(
      user: userMapper.fromDto(dto.user),
      accessToken: dto.accessToken,
      refreshToken: dto.refreshToken,
    );
  }
}
