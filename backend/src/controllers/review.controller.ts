import type { Request, Response } from 'express';

import { ReviewService } from '../services/review.service';
import type { JwtPayload } from '../types/auth.types';
import { AppError } from '../utils/app-error';
import { sendSuccess } from '../utils/api-response';
import { asyncHandler } from '../utils/async-handler';
import type { CreateReviewInput } from '../validators/review.schemas';

type AuthenticatedRequest = Request & { user?: JwtPayload };

const reviewService = new ReviewService();

export const reviewController = {
  create: asyncHandler(async (req: Request, res: Response) => {
    const data = await reviewService.createReview(
      _user(req),
      req.body as CreateReviewInput,
    );
    sendSuccess(res, data, 201);
  }),

  listByMaster: asyncHandler(async (req: Request, res: Response) => {
    const data = await reviewService.getMasterReviews(req.params.id as string);
    sendSuccess(res, data);
  }),

  getMasterRating: asyncHandler(async (req: Request, res: Response) => {
    const data = await reviewService.getMasterRating(req.params.id as string);
    sendSuccess(res, data);
  }),
};

const _user = (req: Request): JwtPayload => {
  const user = (req as AuthenticatedRequest).user;
  if (!user) {
    throw new AppError(401, 'Unauthorized', 'UNAUTHORIZED');
  }
  return user;
};
