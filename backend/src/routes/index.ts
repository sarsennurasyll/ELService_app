import { Router } from 'express';

import { authRouter } from './auth.routes';
import { categoryRouter } from './category.routes';
import { healthRouter } from './health.routes';
import { orderRouter } from './order.routes';
import { offerRouter, orderOfferRouter } from './offer.routes';
import { userRouter } from './user.routes';
import { chatRouter } from './chat.routes';
import { masterReviewRouter, reviewRouter } from './review.routes';

export const apiRouter = Router();

apiRouter.use('/health', healthRouter);
apiRouter.use('/auth', authRouter);
apiRouter.use('/categories', categoryRouter);
apiRouter.use('/orders', orderRouter);
apiRouter.use('/orders', orderOfferRouter);
apiRouter.use('/offers', offerRouter);
apiRouter.use('/users', userRouter);
apiRouter.use('/chats', chatRouter);
apiRouter.use('/reviews', reviewRouter);
apiRouter.use('/masters', masterReviewRouter);
