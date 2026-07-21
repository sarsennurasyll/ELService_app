import '../../domain/models/user.dart';
import '../models/user_dto.dart';

final class UserMapper {
  const UserMapper();

  User fromDto(UserDto dto) {
    return User(
      id: dto.id,
      fullName: dto.fullName,
      email: dto.email,
      role: dto.role,
      phone: dto.phone,
      avatar: dto.avatar,
      city: dto.city,
    );
  }
}
