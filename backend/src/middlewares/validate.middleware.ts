import type { NextFunction, Request, Response } from 'express';
import type { ZodType } from 'zod';

import { AppError } from '../utils/app-error';

type RequestPart = 'body' | 'query' | 'params';
type RequestWithValidatedData = Request & {
  validated?: Partial<Record<RequestPart, unknown>>;
};

export const validate =
  (schema: ZodType, part: RequestPart = 'body') =>
  (req: Request, _res: Response, next: NextFunction): void => {
    const result = schema.safeParse(req[part]);

    if (!result.success) {
      next(
        new AppError(400, 'Validation failed', 'VALIDATION_ERROR', result.error.flatten()),
      );
      return;
    }

    if (part === 'query') {
      const request = req as RequestWithValidatedData;
      request.validated = {
        ...request.validated,
        query: result.data,
      };
      next();
      return;
    }

    req[part] = result.data as never;
    next();
  };
