import { Router } from 'express';

import { userController } from '../controllers/user.controller';
import { authMiddleware } from '../middlewares/auth.middleware';
import { validate } from '../middlewares/validate.middleware';
import { UpdateUserProfileSchema } from '../validators/user.schemas';

export const userRouter = Router();

userRouter.get('/me', authMiddleware, userController.getMe);
userRouter.patch(
  '/me',
  authMiddleware,
  validate(UpdateUserProfileSchema),
  userController.updateMe,
);
