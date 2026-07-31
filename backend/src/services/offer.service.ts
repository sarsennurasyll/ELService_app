import {
  OfferAcceptConflictError,
  OfferRepository,
} from '../repositories/offer.repository';
import { OrderRepository } from '../repositories/order.repository';
import { AppError } from '../utils/app-error';
import type { JwtPayload } from '../types/auth.types';
import type { CreateOfferInput } from '../validators/offer.schemas';

export class OfferService {
  constructor(
    private readonly offerRepository = new OfferRepository(),
    private readonly orderRepository = new OrderRepository(),
  ) {}

  async createOffer(user: JwtPayload, input: CreateOfferInput) {
    if (user.role !== 'TECHNICIAN') throw new AppError(403, 'Forbidden', 'FORBIDDEN');
    const order = await this.orderRepository.findById(input.orderId);
    if (!order) throw new AppError(404, 'Order not found', 'ORDER_NOT_FOUND');
    if (order.status !== 'PENDING') throw new AppError(409, 'Order is unavailable', 'ORDER_UNAVAILABLE');
    return this.offerRepository.upsert(user.sub, input);
  }

  async getOffers(user: JwtPayload, orderId: string) {
    const order = await this.orderRepository.findById(orderId);
    if (!order) throw new AppError(404, 'Order not found', 'ORDER_NOT_FOUND');
    if (user.role !== 'ADMIN' && user.sub !== order.customerId) {
      throw new AppError(403, 'Forbidden', 'FORBIDDEN');
    }
    return this.offerRepository.findByOrderId(orderId);
  }

  async acceptOffer(user: JwtPayload, offerId: string) {
    const offer = await this.offerRepository.findById(offerId);
    if (!offer) throw new AppError(404, 'Offer not found', 'OFFER_NOT_FOUND');
    const order = await this.orderRepository.findById(offer.orderId);
    if (!order) throw new AppError(404, 'Order not found', 'ORDER_NOT_FOUND');
    if (user.role !== 'ADMIN' && user.sub !== order.customerId) throw new AppError(403, 'Forbidden', 'FORBIDDEN');
    try {
      const acceptedOffer = await this.offerRepository.accept(offerId);
      if (!acceptedOffer) throw new AppError(409, 'Offer is unavailable', 'OFFER_UNAVAILABLE');
      return acceptedOffer;
    } catch (error) {
      if (error instanceof OfferAcceptConflictError) {
        throw new AppError(409, 'Offer is unavailable', 'OFFER_UNAVAILABLE');
      }
      throw error;
    }
  }

  async deleteOffer(user: JwtPayload, offerId: string) {
    const offer = await this.offerRepository.findById(offerId);
    if (!offer) throw new AppError(404, 'Offer not found', 'OFFER_NOT_FOUND');
    if (user.role !== 'ADMIN' && user.sub !== offer.masterId) throw new AppError(403, 'Forbidden', 'FORBIDDEN');
    if (offer.status !== 'ACTIVE') {
      throw new AppError(409, 'Offer cannot be deleted', 'OFFER_UNAVAILABLE');
    }
    await this.offerRepository.delete(offerId);
  }
}
