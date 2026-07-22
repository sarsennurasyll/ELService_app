import cors from 'cors';
import express from 'express';
import helmet from 'helmet';
import morgan from 'morgan';

import { appConfig } from './config/app.config';
import { errorHandler, notFoundHandler } from './middlewares/error.middleware';
import { apiRouter } from './routes';

const localOriginPattern = /^https?:\/\/(localhost|127\.0\.0\.1)(:\d+)?$/;

const resolveCorsOrigin = (
  origin: string | undefined,
  callback: (error: Error | null, origin?: boolean | string) => void,
) => {
  if (!origin) {
    callback(null, true);
    return;
  }

  if (origin === appConfig.corsOrigin) {
    callback(null, origin);
    return;
  }

  if (appConfig.env !== 'production' && localOriginPattern.test(origin)) {
    callback(null, origin);
    return;
  }

  callback(new Error('Not allowed by CORS'));
};

export const createApp = () => {
  const app = express();

  app.use(helmet());
  app.use(
    cors({
      origin: resolveCorsOrigin,
    }),
  );
  app.use(morgan(appConfig.env === 'production' ? 'combined' : 'dev'));
  app.use(express.json());
  app.use(express.urlencoded({ extended: true }));

  app.use('/api/v1', apiRouter);

  app.use(notFoundHandler);
  app.use(errorHandler);

  return app;
};
