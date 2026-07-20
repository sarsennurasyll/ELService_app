import type { NextFunction, Request, Response } from 'express';

import { AppError } from '../utils/app-error';
import { sendError } from '../utils/api-response';

export const notFoundHandler = (_req: Request, _res: Response, next: NextFunction): void => {
  next(new AppError(404, 'Route not found', 'NOT_FOUND'));
};

export const errorHandler = (
  error: unknown,
  _req: Request,
  res: Response,
  _next: NextFunction,
): void => {
  if (error instanceof AppError) {
    sendError(res, error.statusCode, error.message, error.errors);
    return;
  }

  console.error(error);
  sendError(res, 500, 'Internal server error');
};
