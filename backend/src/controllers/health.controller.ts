import type { Request, Response } from 'express';

import { asyncHandler } from '../utils/async-handler';

export const healthController = {
  check: asyncHandler(async (_req: Request, res: Response) => {
    res.status(200).json({
      success: true,
      message: 'ELService API is running',
    });
  }),
};
