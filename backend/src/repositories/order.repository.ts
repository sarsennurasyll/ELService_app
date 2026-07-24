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

export type CustomerOrderScope = 'active' | 'past';
export type TechnicianOrderScope = 'incoming' | 'accepted' | 'completed';

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

  findAllForCustomer(customerId: string, scope?: CustomerOrderScope) {
    const terminalStatuses: OrderStatus[] = ['COMPLETED', 'CANCELLED'];
    return prisma.order.findMany({
      where: {
        customerId,
        ...(scope === 'active' ? { status: { notIn: terminalStatuses } } : {}),
        ...(scope === 'past' ? { status: { in: terminalStatuses } } : {}),
      },
      orderBy: { createdAt: 'desc' },
    });
  }

  findAllForTechnician(
    technicianId: string,
    scope?: TechnicianOrderScope,
  ) {
    return prisma.order.findMany({
      where: this.technicianWhere(technicianId, scope),
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

  private technicianWhere(
    technicianId: string,
    scope?: TechnicianOrderScope,
  ) {
    if (scope === 'incoming') {
      return { status: 'PENDING' as const, assignedMasterId: null };
    }
    if (scope === 'accepted') {
      return {
        assignedMasterId: technicianId,
        status: { notIn: ['COMPLETED', 'CANCELLED'] as OrderStatus[] },
      };
    }
    if (scope === 'completed') {
      return { assignedMasterId: technicianId, status: 'COMPLETED' as const };
    }

    return {
      OR: [
        { status: 'PENDING' as const, assignedMasterId: null },
        { assignedMasterId: technicianId },
      ],
    };
  }
}
