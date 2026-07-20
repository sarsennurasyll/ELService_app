import type { NextFunction, Request, Response } from 'express';
import type { ZodType } from 'zod';

import { AppError } from '../utils/app-error';

type RequestPart = 'body' | 'query' | 'params';

export const validate =
  (schema: ZodType, part: RequestPart = 'body') =>
  (req: Request, _res: Response, next: NextFunction): void => {
    const result = schema.safeParse(req[part]);

    if (!result.success) {
      next(
        new AppError(400, 'Validation failed', 'VALIDATION_ERROR'),
      );
      return;
    }

    req[part] = result.data as never;
    next();
  };
