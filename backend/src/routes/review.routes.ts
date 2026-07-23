import { Router } from 'express';

import { reviewController } from '../controllers/review.controller';
import { authMiddleware } from '../middlewares/auth.middleware';
import { validate } from '../middlewares/validate.middleware';
import { CreateReviewSchema } from '../validators/review.schemas';

export const reviewRouter = Router();
export const masterReviewRouter = Router();

reviewRouter.post(
  '/',
  authMiddleware,
  validate(CreateReviewSchema),
  reviewController.create,
);

masterReviewRouter.get('/:id/reviews', authMiddleware, reviewController.listByMaster);
masterReviewRouter.get('/:id/rating', authMiddleware, reviewController.getMasterRating);
