import { AppError } from '../utils/app-error';

/** Заготовка сервиса заказов. */
export class OrderService {
  listOrders(): never {
    throw new AppError(501, 'Orders list is not implemented yet', 'NOT_IMPLEMENTED');
  }
}
