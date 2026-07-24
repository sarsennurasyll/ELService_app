import { prisma } from '../prisma/client';

import type { CreateOfferInput } from '../validators/offer.schemas';

export class OfferAcceptConflictError extends Error {
  constructor() {
    super('Offer is unavailable');
    this.name = 'OfferAcceptConflictError';
  }
}

export class OfferRepository {
  upsert(masterId: string, data: CreateOfferInput) {
    return prisma.offer.upsert({
      where: {
        orderId_masterId: {
          orderId: data.orderId,
          masterId,
        },
      },
      create: { ...data, masterId },
      update: {
        price: data.price,
        arrivalTime: data.arrivalTime,
        comment: data.comment,
        status: 'ACTIVE',
      },
    });
  }

  findByOrderId(orderId: string) {
    return prisma.offer.findMany({
      where: { orderId },
      include: { master: { select: { id: true, fullName: true } } },
      orderBy: { createdAt: 'asc' },
    });
  }

  findById(id: string) {
    return prisma.offer.findUnique({ where: { id } });
  }

  delete(id: string) {
    return prisma.offer.delete({ where: { id } });
  }

  accept(id: string) {
    return prisma.$transaction(async (transaction) => {
      const offer = await transaction.offer.findUnique({ where: { id } });
      if (!offer || offer.status !== 'ACTIVE') {
        return null;
      }

      const order = await transaction.order.findUnique({
        where: { id: offer.orderId },
        select: { id: true, customerId: true, status: true },
      });
      if (!order || order.status !== 'PENDING') {
        return null;
      }

      const acceptedOffer = await transaction.offer.updateMany({
        where: { id, status: 'ACTIVE' },
        data: { status: 'ACCEPTED' },
      });
      if (acceptedOffer.count !== 1) {
        return null;
      }

      const updatedOrder = await transaction.order.updateMany({
        where: { id: offer.orderId, status: 'PENDING' },
        data: { assignedMasterId: offer.masterId, status: 'ACCEPTED' },
      });
      if (updatedOrder.count !== 1) {
        throw new OfferAcceptConflictError();
      }

      await transaction.offer.updateMany({
        where: { orderId: offer.orderId, id: { not: id }, status: 'ACTIVE' },
        data: { status: 'INACTIVE' },
      });

      await transaction.conversation.upsert({
        where: { orderId: offer.orderId },
        create: {
          orderId: offer.orderId,
          userAId: order.customerId,
          userBId: offer.masterId,
        },
        update: {},
      });

      return transaction.offer.findUnique({ where: { id } });
    });
  }
}
