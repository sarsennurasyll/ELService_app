import type { Request, Response } from 'express';

import { OfferService } from '../services/offer.service';
import type { JwtPayload } from '../types/auth.types';
import { AppError } from '../utils/app-error';
import { sendSuccess } from '../utils/api-response';
import { asyncHandler } from '../utils/async-handler';
import type { CreateOfferInput } from '../validators/offer.schemas';

type AuthenticatedRequest = Request & { user?: JwtPayload };
const offerService = new OfferService();

export const offerController = {
  create: asyncHandler(async (req: Request, res: Response) => {
    const data = await offerService.createOffer(_user(req), req.body as CreateOfferInput);
    sendSuccess(res, data, 201);
  }),
  listByOrder: asyncHandler(async (req: Request, res: Response) => {
    const data = await offerService.getOffers(_user(req), req.params.id as string);
    sendSuccess(res, data);
  }),
  accept: asyncHandler(async (req: Request, res: Response) => {
    const data = await offerService.acceptOffer(_user(req), req.params.id as string);
    sendSuccess(res, data);
  }),
  delete: asyncHandler(async (req: Request, res: Response) => {
    await offerService.deleteOffer(_user(req), req.params.id as string);
    sendSuccess(res, { id: req.params.id });
  }),
};

const _user = (req: Request): JwtPayload => {
  const user = (req as AuthenticatedRequest).user;
  if (!user) throw new AppError(401, 'Unauthorized', 'UNAUTHORIZED');
  return user;
};
