import { Router } from 'express';

import { authRouter } from './auth.routes';
import { categoryRouter } from './category.routes';
import { healthRouter } from './health.routes';

export const apiRouter = Router();

apiRouter.use('/health', healthRouter);
apiRouter.use('/auth', authRouter);
apiRouter.use('/categories', categoryRouter);
