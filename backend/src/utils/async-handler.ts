import type { AsyncRequestHandler } from '../types/express.types';

export const asyncHandler = (handler: AsyncRequestHandler): AsyncRequestHandler => {
  return async (req, res, next) => {
    try {
      await handler(req, res, next);
    } catch (error) {
      next(error);
    }
  };
};
