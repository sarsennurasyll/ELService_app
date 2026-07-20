import type { Request, Response } from 'express';

import { asyncHandler } from '../utils/async-handler';

/** Заготовки auth-эндпоинтов без бизнес-логики. */
export const authController = {
  login: asyncHandler(async (_req: Request, res: Response) => {
    res.status(501).json({
      success: false,
      message: 'Auth login is not implemented yet',
      code: 'NOT_IMPLEMENTED',
    });
  }),

  register: asyncHandler(async (_req: Request, res: Response) => {
    res.status(501).json({
      success: false,
      message: 'Auth register is not implemented yet',
      code: 'NOT_IMPLEMENTED',
    });
  }),

  refresh: asyncHandler(async (_req: Request, res: Response) => {
    res.status(501).json({
      success: false,
      message: 'Auth refresh is not implemented yet',
      code: 'NOT_IMPLEMENTED',
    });
  }),

  logout: asyncHandler(async (_req: Request, res: Response) => {
    res.status(501).json({
      success: false,
      message: 'Auth logout is not implemented yet',
      code: 'NOT_IMPLEMENTED',
    });
  }),
};
