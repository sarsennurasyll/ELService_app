import { Router } from 'express';

import { authController } from '../controllers/auth.controller';
import { validate } from '../middlewares/validate.middleware';
import {
  LoginSchema,
  RefreshSchema,
  RegisterSchema,
} from '../validators/auth.schemas';

export const authRouter = Router();

authRouter.post('/register', validate(RegisterSchema), authController.register);
authRouter.post('/login', validate(LoginSchema), authController.login);
authRouter.post('/refresh', validate(RefreshSchema), authController.refresh);
authRouter.post('/logout', authController.logout);
