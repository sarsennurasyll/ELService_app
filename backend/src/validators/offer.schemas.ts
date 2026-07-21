import { z } from 'zod';

export const CreateOfferSchema = z.object({
  orderId: z.string().trim().min(1, 'orderId is required'),
  price: z.coerce.number().positive('price must be positive'),
  arrivalTime: z.string().trim().min(1, 'arrivalTime is required'),
  comment: z.string().trim().min(1, 'comment is required').optional(),
});

export type CreateOfferInput = z.infer<typeof CreateOfferSchema>;
