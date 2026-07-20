import '../../domain/models/user.dart';
import '../models/user_dto.dart';

/// Маппер UserDto ↔ User.
final class UserMapper {
  const UserMapper();

  User fromDto(UserDto dto) {
    // TODO: расширить маппинг по полям Backend.
    return User(
      id: dto.id,
      email: dto.email,
      name: dto.name,
      role: dto.role,
      phone: dto.phone,
    );
  }

  UserDto toDto(User entity) {
    // TODO: расширить маппинг по полям Backend.
    return UserDto(
      id: entity.id,
      email: entity.email,
      name: entity.name,
      role: entity.role,
      phone: entity.phone,
    );
  }
}
