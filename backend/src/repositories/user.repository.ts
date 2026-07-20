import type { Prisma, User, UserRole } from '@prisma/client';

import { prisma } from '../prisma/client';

export type CreateUserInput = {
  fullName: string;
  email: string;
  phone: string;
  passwordHash: string;
  role: UserRole;
};

/** Репозиторий пользователей через Prisma. */
export class UserRepository {
  findByEmail(email: string) {
    return prisma.user.findUnique({ where: { email } });
  }

  findByPhone(phone: string) {
    return prisma.user.findFirst({ where: { phone } });
  }

  findById(id: string) {
    return prisma.user.findUnique({ where: { id } });
  }

  create(data: CreateUserInput) {
    return prisma.user.create({ data });
  }

  toPublicUser(user: User) {
    const { passwordHash: _passwordHash, ...publicUser } = user;
    return publicUser;
  }
}

export type PublicUser = Omit<User, 'passwordHash'>;
export type { Prisma, User, UserRole };
