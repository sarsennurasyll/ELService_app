import { AppError } from '../utils/app-error';

/** Заготовка сервиса пользователей. */
export class UserService {
  getProfile(_userId: string): never {
    throw new AppError(501, 'User profile is not implemented yet', 'NOT_IMPLEMENTED');
  }
}
