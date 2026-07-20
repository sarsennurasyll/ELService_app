import { createApp } from './app';
import { appConfig } from './config/app.config';
import { prisma } from './prisma/client';

const app = createApp();

const start = async () => {
  try {
    await prisma.$connect();
    app.listen(appConfig.port, () => {
      console.log(`ELService API listening on port ${appConfig.port}`);
    });
  } catch (error) {
    console.error('Failed to start server', error);
    process.exit(1);
  }
};

void start();
