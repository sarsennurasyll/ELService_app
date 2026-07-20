import { prisma } from '../prisma/client';

/** Репозиторий категорий через Prisma. */
export class CategoryRepository {
  findAll() {
    return prisma.category.findMany({
      orderBy: { name: 'asc' },
    });
  }

  findById(id: string) {
    return prisma.category.findUnique({ where: { id } });
  }
}
