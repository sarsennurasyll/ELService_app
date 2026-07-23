import type { OrderStatus } from '@prisma/client';

import { prisma } from '../prisma/client';

export type CreateOrderInput = {
  customerId: string;
  categoryId: string;
  description: string;
  address?: string;
  preferredDate?: Date;
};

export type UpdateOrderInput = {
  description?: string;
  address?: string;
  preferredDate?: Date;
  status?: OrderStatus;
};

export class OrderRepository {
  create(data: CreateOrderInput) {
    return prisma.order.create({
      data: {
        ...data,
        status: 'PENDING',
      },
    });
  }

  findAll() {
    return prisma.order.findMany({
      orderBy: { createdAt: 'desc' },
    });
  }

  findById(id: string) {
    return prisma.order.findUnique({ where: { id } });
  }

  update(id: string, data: UpdateOrderInput) {
    return prisma.order.update({
      where: { id },
      data,
    });
  }

  updateStatus(id: string, status: OrderStatus) {
    return prisma.order.update({
      where: { id },
      data: { status },
    });
  }

  delete(id: string) {
    return prisma.order.delete({ where: { id } });
  }
}
