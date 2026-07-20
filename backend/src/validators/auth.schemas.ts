import { z } from 'zod';

export const RegisterSchema = z.object({
  fullName: z.string().trim().min(2, 'fullName is too short'),
  email: z.string().trim().email('Invalid email'),
  phone: z.string().trim().min(8, 'Invalid phone'),
  password: z.string().min(6, 'Password must be at least 6 characters'),
  role: z.enum(['CUSTOMER', 'TECHNICIAN', 'ADMIN']).default('CUSTOMER'),
});

export const LoginSchema = z.object({
  email: z.string().trim().email('Invalid email'),
  password: z.string().min(1, 'Password is required'),
});

export const RefreshSchema = z.object({
  refreshToken: z.string().min(1, 'refreshToken is required'),
});

export type RegisterInput = z.infer<typeof RegisterSchema>;
export type LoginInput = z.infer<typeof LoginSchema>;
export type RefreshInput = z.infer<typeof RefreshSchema>;
