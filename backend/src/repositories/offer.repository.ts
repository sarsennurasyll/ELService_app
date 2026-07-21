import { prisma } from '../prisma/client';

import type { CreateOfferInput } from '../validators/offer.schemas';

export class OfferRepository {
  create(masterId: string, data: CreateOfferInput) {
    return prisma.offer.create({ data: { ...data, masterId } });
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
      await transaction.offer.update({ where: { id }, data: { status: 'ACCEPTED' } });
      await transaction.offer.updateMany({
        where: { orderId: offer.orderId, id: { not: id }, status: 'ACTIVE' },
        data: { status: 'INACTIVE' },
      });
      await transaction.order.update({
        where: { id: offer.orderId },
        data: { assignedMasterId: offer.masterId, status: 'ACCEPTED' },
      });
      return transaction.offer.findUnique({ where: { id } });
    });
  }
}
