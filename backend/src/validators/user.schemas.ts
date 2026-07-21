import { z } from 'zod';

export const UpdateUserProfileSchema = z
  .object({
    fullName: z.string().trim().min(2, 'fullName is too short').optional(),
    phone: z.string().trim().min(8, 'Invalid phone').optional(),
    avatar: z.string().url('Invalid avatar URL').optional(),
    city: z.string().trim().min(2, 'city is too short').optional(),
  })
  .refine((value) => Object.values(value).some((field) => field !== undefined), {
    message: 'At least one field is required',
  });

export type UpdateUserProfileInput = z.infer<typeof UpdateUserProfileSchema>;
