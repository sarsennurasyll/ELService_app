import { prisma } from '../prisma/client';

/** Заготовка репозитория категорий. */
export class CategoryRepository {
  findAll() {
    return prisma.category.findMany();
  }
}
