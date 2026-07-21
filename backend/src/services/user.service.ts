import { UserRepository, type UpdateUserProfileInput } from '../repositories/user.repository';
import { AppError } from '../utils/app-error';

export class UserService {
  constructor(private readonly userRepository = new UserRepository()) {}

  async getProfile(userId: string) {
    const user = await this.userRepository.findById(userId);
    if (!user) {
      throw new AppError(404, 'User not found', 'USER_NOT_FOUND');
    }
    return this.userRepository.toPublicUser(user);
  }

  async updateProfile(userId: string, input: UpdateUserProfileInput) {
    await this.getProfile(userId);
    const user = await this.userRepository.updateProfile(userId, input);
    return this.userRepository.toPublicUser(user);
  }
}
