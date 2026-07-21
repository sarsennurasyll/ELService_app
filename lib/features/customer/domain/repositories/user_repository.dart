import '../../../../core/utils/result.dart';
import '../models/user.dart';

abstract interface class UserRepository {
  Future<Result<User>> getCurrentUser();

  Future<Result<User>> updateCurrentUser({
    String? fullName,
    String? phone,
    String? avatar,
    String? city,
  });
}
