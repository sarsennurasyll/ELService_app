import { prisma } from '../prisma/client';

/** Заготовка репозитория заказов. */
export class OrderRepository {
  findAll() {
    return prisma.order.findMany();
  }

  findById(id: string) {
    return prisma.order.findUnique({ where: { id } });
  }
}
