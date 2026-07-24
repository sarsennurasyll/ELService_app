import type { Request, Response } from 'express';

import { OrderService } from '../services/order.service';
import type { JwtPayload } from '../types/auth.types';
import { AppError } from '../utils/app-error';
import { sendSuccess } from '../utils/api-response';
import { asyncHandler } from '../utils/async-handler';
import type {
  CreateOrderInput,
  OrderListQuery,
  UpdateOrderInput,
} from '../validators/order.schemas';

const orderService = new OrderService();
type AuthenticatedRequest = Request & { user?: JwtPayload };

export const orderController = {
  create: asyncHandler(async (req: Request, res: Response) => {
    const data = await orderService.createOrder(
      getUser(req),
      req.body as CreateOrderInput,
    );
    sendSuccess(res, data, 201);
  }),

  list: asyncHandler(async (req: Request, res: Response) => {
    const data = await orderService.listOrders(
      getUser(req),
      req.query as OrderListQuery,
    );
    sendSuccess(res, data);
  }),

  getById: asyncHandler(async (req: Request, res: Response) => {
    const data = await orderService.getOrderById(
      getUser(req),
      req.params.id as string,
    );
    sendSuccess(res, data);
  }),

  update: asyncHandler(async (req: Request, res: Response) => {
    const data = await orderService.updateOrder(
      getUser(req),
      req.params.id as string,
      req.body as UpdateOrderInput,
    );
    sendSuccess(res, data);
  }),

  start: asyncHandler(async (req: Request, res: Response) => {
    const data = await orderService.startOrder(
      getUser(req),
      req.params.id as string,
    );
    sendSuccess(res, data);
  }),

  complete: asyncHandler(async (req: Request, res: Response) => {
    const data = await orderService.completeOrder(
      getUser(req),
      req.params.id as string,
    );
    sendSuccess(res, data);
  }),

  cancel: asyncHandler(async (req: Request, res: Response) => {
    const data = await orderService.cancelOrder(
      getUser(req),
      req.params.id as string,
    );
    sendSuccess(res, data);
  }),

  delete: asyncHandler(async (req: Request, res: Response) => {
    await orderService.deleteOrder(getUser(req), req.params.id as string);
    sendSuccess(res, { id: req.params.id });
  }),
};

const getUser = (req: Request): JwtPayload => {
  const user = (req as AuthenticatedRequest).user;
  if (!user) {
    throw new AppError(401, 'Unauthorized', 'UNAUTHORIZED');
  }
  return user;
};
