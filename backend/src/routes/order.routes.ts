import { Router } from 'express';

import { orderController } from '../controllers/order.controller';
import { validate } from '../middlewares/validate.middleware';
import { CreateOrderSchema, UpdateOrderSchema } from '../validators/order.schemas';

export const orderRouter = Router();

orderRouter.post('/', validate(CreateOrderSchema), orderController.create);
orderRouter.get('/', orderController.list);
orderRouter.get('/:id', orderController.getById);
orderRouter.patch('/:id/start', orderController.start);
orderRouter.patch('/:id/complete', orderController.complete);
orderRouter.patch('/:id/cancel', orderController.cancel);
orderRouter.patch('/:id', validate(UpdateOrderSchema), orderController.update);
orderRouter.delete('/:id', orderController.delete);
