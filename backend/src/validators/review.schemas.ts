import { z } from 'zod';

export const CreateReviewSchema = z.object({
  orderId: z.string().trim().min(1, 'orderId is required'),
  rating: z.number().int().min(1).max(5),
  comment: z.string().trim().optional(),
});

export type CreateReviewInput = z.infer<typeof CreateReviewSchema>;
