import { UserRepository } from '../repositories/user.repository';
import type { LoginInput, RefreshInput, RegisterInput } from '../validators/auth.schemas';
import { AppError } from '../utils/app-error';
import { signAccessToken, signAuthTokens, verifyRefreshToken } from '../utils/jwt';
import { comparePassword, hashPassword } from '../utils/password';

export class AuthService {
  constructor(private readonly userRepository = new UserRepository()) {}

  async register(input: RegisterInput) {
    const existingEmail = await this.userRepository.findByEmail(input.email);
    if (existingEmail) {
      throw new AppError(409, 'Email already exists', 'EMAIL_EXISTS');
    }

    const existingPhone = await this.userRepository.findByPhone(input.phone);
    if (existingPhone) {
      throw new AppError(409, 'Phone already exists', 'PHONE_EXISTS');
    }

    const passwordHash = await hashPassword(input.password);
    const user = await this.userRepository.create({
      fullName: input.fullName,
      email: input.email,
      phone: input.phone,
      passwordHash,
      role: input.role,
    });

    const tokens = signAuthTokens({
      sub: user.id,
      role: user.role,
    });

    return {
      ...tokens,
      user: this.userRepository.toPublicUser(user),
    };
  }

  async login(input: LoginInput) {
    const user = await this.userRepository.findByEmail(input.email);
    if (!user) {
      throw new AppError(401, 'Invalid email or password', 'INVALID_CREDENTIALS');
    }

    const isValidPassword = await comparePassword(input.password, user.passwordHash);
    if (!isValidPassword) {
      throw new AppError(401, 'Invalid email or password', 'INVALID_CREDENTIALS');
    }

    const tokens = signAuthTokens({
      sub: user.id,
      role: user.role,
    });

    return {
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken,
      user: this.userRepository.toPublicUser(user),
    };
  }

  async refresh(input: RefreshInput) {
    try {
      const payload = verifyRefreshToken(input.refreshToken);
      const user = await this.userRepository.findById(payload.sub);

      if (!user) {
        throw new AppError(401, 'Invalid refresh token', 'INVALID_REFRESH_TOKEN');
      }

      // TODO: проверить blacklist refresh token.
      const accessToken = signAccessToken({
        sub: user.id,
        role: user.role,
      });

      return { accessToken };
    } catch (error) {
      if (error instanceof AppError) {
        throw error;
      }

      throw new AppError(401, 'Invalid refresh token', 'INVALID_REFRESH_TOKEN');
    }
  }

  async logout(_refreshToken?: string) {
    // TODO: добавить refresh token в blacklist.
    return { message: 'Logged out successfully' };
  }
}
