import { prisma } from '../prisma/client';

export type CreateReviewData = {
  orderId: string;
  customerId: string;
  technicianId: string;
  rating: number;
  comment?: string;
};

export class ReviewRepository {
  create(data: CreateReviewData) {
    return prisma.review.create({
      data,
      include: { customer: { select: { id: true, fullName: true } } },
    });
  }

  findByOrderId(orderId: string) {
    return prisma.review.findUnique({ where: { orderId } });
  }

  findByMasterId(masterId: string) {
    return prisma.review.findMany({
      where: { technicianId: masterId },
      include: { customer: { select: { id: true, fullName: true } } },
      orderBy: { createdAt: 'desc' },
    });
  }

  getMasterRating(masterId: string) {
    return prisma.review.aggregate({
      where: { technicianId: masterId },
      _avg: { rating: true },
      _count: { rating: true },
    });
  }
}
