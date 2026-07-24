import { CategoryRepository } from '../repositories/category.repository';
import type { OrderStatus } from '@prisma/client';
import {
  OrderRepository,
  type CreateOrderInput,
  type UpdateOrderInput,
} from '../repositories/order.repository';
import type { JwtPayload } from '../types/auth.types';
import { UserRepository } from '../repositories/user.repository';
import { AppError } from '../utils/app-error';

export class OrderService {
  constructor(
    private readonly orderRepository = new OrderRepository(),
    private readonly categoryRepository = new CategoryRepository(),
    private readonly userRepository = new UserRepository(),
  ) {}

  async createOrder(
    user: JwtPayload,
    input: Omit<CreateOrderInput, 'customerId'> & { customerId?: string },
  ) {
    if (user.role !== 'CUSTOMER' && user.role !== 'ADMIN') {
      throw new AppError(403, 'Only customer can create order', 'FORBIDDEN');
    }

    const customerId =
      user.role === 'ADMIN' && input.customerId ? input.customerId : user.sub;
    const [category, customer] = await Promise.all([
      this.categoryRepository.findById(input.categoryId),
      this.userRepository.findById(customerId),
    ]);

    if (!category) {
      throw new AppError(404, 'Category not found', 'CATEGORY_NOT_FOUND');
    }
    if (!customer) {
      throw new AppError(404, 'User not found', 'USER_NOT_FOUND');
    }

    return this.orderRepository.create({
      categoryId: input.categoryId,
      customerId,
      description: input.description,
      address: input.address,
      preferredDate: input.preferredDate,
    });
  }

  listOrders(user: JwtPayload) {
    if (user.role === 'ADMIN') {
      return this.orderRepository.findAll();
    }
    if (user.role === 'TECHNICIAN') {
      return this.orderRepository.findAllForTechnician(user.sub);
    }
    return this.orderRepository.findAllForCustomer(user.sub);
  }

  async getOrderById(user: JwtPayload, id: string) {
    const order = await this.orderRepository.findById(id);
    if (!order) {
      throw new AppError(404, 'Order not found', 'ORDER_NOT_FOUND');
    }
    this.assertCanViewOrder(user, order);
    return order;
  }

  async updateOrder(user: JwtPayload, id: string, input: UpdateOrderInput) {
    const order = await this.getOrderForAction(id);
    this.assertCanUpdateOrder(user, order);
    if (input.status) {
      this.assertStatusTransition(order.status, input.status);
    }
    return this.orderRepository.update(id, input);
  }

  async startOrder(user: JwtPayload, id: string) {
    return this.updateOrderStatus(user, id, 'IN_PROGRESS');
  }

  async completeOrder(user: JwtPayload, id: string) {
    return this.updateOrderStatus(user, id, 'COMPLETED');
  }

  async cancelOrder(user: JwtPayload, id: string) {
    const order = await this.getOrderForAction(id);
    if (
      user.role !== 'ADMIN' &&
      !(user.role === 'CUSTOMER' && order.customerId === user.sub)
    ) {
      throw new AppError(403, 'Forbidden', 'FORBIDDEN');
    }

    this.assertStatusTransition(order.status, 'CANCELLED');
    return this.orderRepository.updateStatus(id, 'CANCELLED');
  }

  async deleteOrder(user: JwtPayload, id: string) {
    const order = await this.getOrderForAction(id);
    if (
      user.role !== 'ADMIN' &&
      !(user.role === 'CUSTOMER' && order.customerId === user.sub)
    ) {
      throw new AppError(403, 'Forbidden', 'FORBIDDEN');
    }
    await this.orderRepository.delete(id);
  }

  private async updateOrderStatus(
    user: JwtPayload,
    id: string,
    status: OrderStatus,
  ) {
    const order = await this.getOrderForAction(id);
    if (
      user.role !== 'ADMIN' &&
      !(user.role === 'TECHNICIAN' && order.assignedMasterId === user.sub)
    ) {
      throw new AppError(403, 'Forbidden', 'FORBIDDEN');
    }

    this.assertStatusTransition(order.status, status);
    return this.orderRepository.updateStatus(id, status);
  }

  private async getOrderForAction(id: string) {
    const order = await this.orderRepository.findById(id);
    if (!order) {
      throw new AppError(404, 'Order not found', 'ORDER_NOT_FOUND');
    }
    return order;
  }

  private assertCanViewOrder(
    user: JwtPayload,
    order: Awaited<ReturnType<OrderRepository['findById']>>,
  ) {
    if (!order) {
      throw new AppError(404, 'Order not found', 'ORDER_NOT_FOUND');
    }

    if (user.role === 'ADMIN') {
      return;
    }
    if (user.role === 'CUSTOMER' && order.customerId === user.sub) {
      return;
    }
    if (
      user.role === 'TECHNICIAN' &&
      this.isVisibleForTechnician(user.sub, order)
    ) {
      return;
    }

    throw new AppError(403, 'Forbidden', 'FORBIDDEN');
  }

  private assertCanUpdateOrder(
    user: JwtPayload,
    order: Awaited<ReturnType<OrderRepository['findById']>>,
  ) {
    if (!order) {
      throw new AppError(404, 'Order not found', 'ORDER_NOT_FOUND');
    }

    if (user.role === 'ADMIN') {
      return;
    }
    if (user.role === 'CUSTOMER' && order.customerId === user.sub) {
      return;
    }

    throw new AppError(403, 'Forbidden', 'FORBIDDEN');
  }

  private isVisibleForTechnician(
    technicianId: string,
    order: Awaited<ReturnType<OrderRepository['findById']>>,
  ) {
    return Boolean(
      order &&
        ((order.status === 'PENDING' && !order.assignedMasterId) ||
          order.assignedMasterId === technicianId),
    );
  }

  private assertStatusTransition(from: OrderStatus, to: OrderStatus) {
    if (from === to) {
      return;
    }

    const allowedTransitions: Record<OrderStatus, OrderStatus[]> = {
      PENDING: ['ACCEPTED', 'CANCELLED'],
      ACCEPTED: ['IN_PROGRESS', 'CANCELLED'],
      IN_PROGRESS: ['COMPLETED', 'CANCELLED'],
      ACTIVE: ['COMPLETED', 'CANCELLED'],
      COMPLETED: [],
      CANCELLED: [],
      DISPUTED: [],
    };

    if (!allowedTransitions[from].includes(to)) {
      throw new AppError(409, 'Invalid order status transition', 'INVALID_ORDER_STATUS_TRANSITION');
    }
  }
}
