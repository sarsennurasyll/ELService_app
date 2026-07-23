import { OrderRepository } from '../repositories/order.repository';
import { ReviewRepository } from '../repositories/review.repository';
import type { JwtPayload } from '../types/auth.types';
import { AppError } from '../utils/app-error';
import type { CreateReviewInput } from '../validators/review.schemas';

export class ReviewService {
  constructor(
    private readonly reviewRepository = new ReviewRepository(),
    private readonly orderRepository = new OrderRepository(),
  ) {}

  async createReview(user: JwtPayload, input: CreateReviewInput) {
    if (user.role !== 'CUSTOMER') {
      throw new AppError(403, 'Only customer can leave review', 'FORBIDDEN');
    }

    const order = await this.orderRepository.findById(input.orderId);
    if (!order) {
      throw new AppError(404, 'Order not found', 'ORDER_NOT_FOUND');
    }
    if (order.customerId !== user.sub) {
      throw new AppError(403, 'Forbidden', 'FORBIDDEN');
    }
    if (order.status !== 'COMPLETED') {
      throw new AppError(409, 'Order is not completed', 'ORDER_NOT_COMPLETED');
    }
    if (!order.assignedMasterId) {
      throw new AppError(409, 'Master is not assigned', 'MASTER_NOT_ASSIGNED');
    }

    const existingReview = await this.reviewRepository.findByOrderId(order.id);
    if (existingReview) {
      throw new AppError(409, 'Review already exists', 'REVIEW_ALREADY_EXISTS');
    }

    return this.reviewRepository.create({
      orderId: order.id,
      customerId: order.customerId,
      technicianId: order.assignedMasterId,
      rating: input.rating,
      comment: input.comment,
    });
  }

  getMasterReviews(masterId: string) {
    return this.reviewRepository.findByMasterId(masterId);
  }

  async getMasterRating(masterId: string) {
    const rating = await this.reviewRepository.getMasterRating(masterId);
    return {
      masterId,
      averageRating: rating._avg.rating ?? 0,
      reviewsCount: rating._count.rating,
    };
  }
}
