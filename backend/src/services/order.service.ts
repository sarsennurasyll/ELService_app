import { CategoryRepository } from '../repositories/category.repository';
import type { OrderStatus } from '@prisma/client';
import {
  OrderRepository,
  type CreateOrderInput,
  type UpdateOrderInput,
} from '../repositories/order.repository';
import { UserRepository } from '../repositories/user.repository';
import { AppError } from '../utils/app-error';

export class OrderService {
  constructor(
    private readonly orderRepository = new OrderRepository(),
    private readonly categoryRepository = new CategoryRepository(),
    private readonly userRepository = new UserRepository(),
  ) {}

  async createOrder(input: CreateOrderInput) {
    const [category, customer] = await Promise.all([
      this.categoryRepository.findById(input.categoryId),
      this.userRepository.findById(input.customerId),
    ]);

    if (!category) {
      throw new AppError(404, 'Category not found', 'CATEGORY_NOT_FOUND');
    }
    if (!customer) {
      throw new AppError(404, 'User not found', 'USER_NOT_FOUND');
    }

    return this.orderRepository.create(input);
  }

  listOrders() {
    return this.orderRepository.findAll();
  }

  async getOrderById(id: string) {
    const order = await this.orderRepository.findById(id);
    if (!order) {
      throw new AppError(404, 'Order not found', 'ORDER_NOT_FOUND');
    }
    return order;
  }

  async updateOrder(id: string, input: UpdateOrderInput) {
    const order = await this.getOrderById(id);
    if (input.status) {
      this.assertStatusTransition(order.status, input.status);
    }
    return this.orderRepository.update(id, input);
  }

  async startOrder(id: string) {
    return this.updateOrderStatus(id, 'IN_PROGRESS');
  }

  async completeOrder(id: string) {
    return this.updateOrderStatus(id, 'COMPLETED');
  }

  async cancelOrder(id: string) {
    return this.updateOrderStatus(id, 'CANCELLED');
  }

  async deleteOrder(id: string) {
    await this.getOrderById(id);
    await this.orderRepository.delete(id);
  }

  private async updateOrderStatus(id: string, status: OrderStatus) {
    const order = await this.getOrderById(id);
    this.assertStatusTransition(order.status, status);
    return this.orderRepository.updateStatus(id, status);
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
