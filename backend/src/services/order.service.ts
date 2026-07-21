import { CategoryRepository } from '../repositories/category.repository';
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
    await this.getOrderById(id);
    return this.orderRepository.update(id, input);
  }

  async deleteOrder(id: string) {
    await this.getOrderById(id);
    await this.orderRepository.delete(id);
  }
}
