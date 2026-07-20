import type { Request, Response } from 'express';

import { AuthService } from '../services/auth.service';
import { sendSuccess } from '../utils/api-response';
import { asyncHandler } from '../utils/async-handler';
import type { LoginInput, RefreshInput, RegisterInput } from '../validators/auth.schemas';

const authService = new AuthService();

export const authController = {
  register: asyncHandler(async (req: Request, res: Response) => {
    const data = await authService.register(req.body as RegisterInput);
    sendSuccess(res, data, 201);
  }),

  login: asyncHandler(async (req: Request, res: Response) => {
    const data = await authService.login(req.body as LoginInput);
    sendSuccess(res, data);
  }),

  refresh: asyncHandler(async (req: Request, res: Response) => {
    const data = await authService.refresh(req.body as RefreshInput);
    sendSuccess(res, data);
  }),

  logout: asyncHandler(async (req: Request, res: Response) => {
    const refreshToken =
      typeof req.body?.refreshToken === 'string' ? req.body.refreshToken : undefined;
    const data = await authService.logout(refreshToken);
    sendSuccess(res, data);
  }),
};
