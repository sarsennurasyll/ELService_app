import type { Request, Response } from 'express';

import { UserService } from '../services/user.service';
import type { JwtPayload } from '../types/auth.types';
import { sendSuccess } from '../utils/api-response';
import { asyncHandler } from '../utils/async-handler';
import { AppError } from '../utils/app-error';
import type { UpdateUserProfileInput } from '../validators/user.schemas';

type AuthenticatedRequest = Request & { user?: JwtPayload };

const userService = new UserService();

export const userController = {
  getMe: asyncHandler(async (req: Request, res: Response) => {
    const userId = _userId(req);
    const data = await userService.getProfile(userId);
    sendSuccess(res, data);
  }),

  updateMe: asyncHandler(async (req: Request, res: Response) => {
    const userId = _userId(req);
    const data = await userService.updateProfile(
      userId,
      req.body as UpdateUserProfileInput,
    );
    sendSuccess(res, data);
  }),
};

const _userId = (req: Request): string => {
  const user = (req as AuthenticatedRequest).user;
  if (!user) {
    throw new AppError(401, 'Unauthorized', 'UNAUTHORIZED');
  }
  return user.sub;
};
