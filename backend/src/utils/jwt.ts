import jwt from 'jsonwebtoken';

import { appConfig } from '../config/app.config';
import type { AuthTokens, JwtPayload } from '../types/auth.types';

export const signAccessToken = (payload: JwtPayload): string => {
  return jwt.sign(payload, appConfig.jwt.accessSecret, {
    expiresIn: appConfig.jwt.accessExpiresIn as jwt.SignOptions['expiresIn'],
  });
};

export const signRefreshToken = (payload: JwtPayload): string => {
  return jwt.sign(payload, appConfig.jwt.refreshSecret, {
    expiresIn: appConfig.jwt.refreshExpiresIn as jwt.SignOptions['expiresIn'],
  });
};

export const signAuthTokens = (payload: JwtPayload): AuthTokens => {
  return {
    accessToken: signAccessToken(payload),
    refreshToken: signRefreshToken(payload),
  };
};

export const verifyAccessToken = (token: string): JwtPayload => {
  return jwt.verify(token, appConfig.jwt.accessSecret) as JwtPayload;
};

export const verifyRefreshToken = (token: string): JwtPayload => {
  return jwt.verify(token, appConfig.jwt.refreshSecret) as JwtPayload;
};
