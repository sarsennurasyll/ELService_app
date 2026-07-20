import { AppError } from '../utils/app-error';

/** Заготовка сервиса авторизации. */
export class AuthService {
  login(_email: string, _password: string): never {
    throw new AppError(501, 'Auth login is not implemented yet', 'NOT_IMPLEMENTED');
  }

  register(_payload: unknown): never {
    throw new AppError(501, 'Auth register is not implemented yet', 'NOT_IMPLEMENTED');
  }
}
