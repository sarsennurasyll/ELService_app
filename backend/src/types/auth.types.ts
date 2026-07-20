export type UserRole = 'CUSTOMER' | 'TECHNICIAN' | 'ADMIN';

export type JwtPayload = {
  sub: string;
  role: UserRole;
};

export type AuthTokens = {
  accessToken: string;
  refreshToken: string;
};
