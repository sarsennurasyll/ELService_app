import { Router } from 'express';

import { offerController } from '../controllers/offer.controller';
import { authMiddleware } from '../middlewares/auth.middleware';
import { validate } from '../middlewares/validate.middleware';
import { CreateOfferSchema } from '../validators/offer.schemas';

export const offerRouter = Router();
export const orderOfferRouter = Router();

offerRouter.post('/', authMiddleware, validate(CreateOfferSchema), offerController.create);
offerRouter.patch('/:id/accept', authMiddleware, offerController.accept);
offerRouter.delete('/:id', authMiddleware, offerController.delete);
orderOfferRouter.get('/:id/offers', authMiddleware, offerController.listByOrder);
