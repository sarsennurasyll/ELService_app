import type { NextFunction, Request, Response } from 'express';

import { AppError } from '../utils/app-error';
import { verifyAccessToken } from '../utils/jwt';

export const authMiddleware = (req: Request, _res: Response, next: NextFunction): void => {
  const header = req.headers.authorization;

  if (!header?.startsWith('Bearer ')) {
    next(new AppError(401, 'Unauthorized', 'UNAUTHORIZED'));
    return;
  }

  const token = header.slice('Bearer '.length);

  try {
    const payload = verifyAccessToken(token);
    (req as Request & { user?: unknown }).user = payload;
    next();
  } catch {
    next(new AppError(401, 'Invalid or expired token', 'INVALID_TOKEN'));
  }
};
