import type { Request, Response } from 'express';

import { OrderService } from '../services/order.service';
import { sendSuccess } from '../utils/api-response';
import { asyncHandler } from '../utils/async-handler';
import type {
  CreateOrderInput,
  UpdateOrderInput,
} from '../validators/order.schemas';

const orderService = new OrderService();

export const orderController = {
  create: asyncHandler(async (req: Request, res: Response) => {
    const data = await orderService.createOrder(req.body as CreateOrderInput);
    sendSuccess(res, data, 201);
  }),

  list: asyncHandler(async (_req: Request, res: Response) => {
    const data = await orderService.listOrders();
    sendSuccess(res, data);
  }),

  getById: asyncHandler(async (req: Request, res: Response) => {
    const data = await orderService.getOrderById(req.params.id as string);
    sendSuccess(res, data);
  }),

  update: asyncHandler(async (req: Request, res: Response) => {
    const data = await orderService.updateOrder(
      req.params.id as string,
      req.body as UpdateOrderInput,
    );
    sendSuccess(res, data);
  }),

  start: asyncHandler(async (req: Request, res: Response) => {
    const data = await orderService.startOrder(req.params.id as string);
    sendSuccess(res, data);
  }),

  complete: asyncHandler(async (req: Request, res: Response) => {
    const data = await orderService.completeOrder(req.params.id as string);
    sendSuccess(res, data);
  }),

  cancel: asyncHandler(async (req: Request, res: Response) => {
    const data = await orderService.cancelOrder(req.params.id as string);
    sendSuccess(res, data);
  }),

  delete: asyncHandler(async (req: Request, res: Response) => {
    await orderService.deleteOrder(req.params.id as string);
    sendSuccess(res, { id: req.params.id });
  }),
};
