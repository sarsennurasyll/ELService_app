import type { Request, Response } from 'express';

import { CategoryService } from '../services/category.service';
import { sendSuccess } from '../utils/api-response';
import { asyncHandler } from '../utils/async-handler';

const categoryService = new CategoryService();

export const categoryController = {
  list: asyncHandler(async (_req: Request, res: Response) => {
    const data = await categoryService.listCategories();
    sendSuccess(res, data);
  }),

  getById: asyncHandler(async (req: Request, res: Response) => {
    const data = await categoryService.getCategoryById(req.params.id as string);
    sendSuccess(res, data);
  }),
};
