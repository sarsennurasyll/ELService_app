import { z } from 'zod';

const orderStatusSchema = z.enum([
  'PENDING',
  'ACCEPTED',
  'IN_PROGRESS',
  'ACTIVE',
  'COMPLETED',
  'CANCELLED',
  'DISPUTED',
]);

export const CreateOrderSchema = z.object({
  customerId: z.string().trim().min(1, 'customerId is required').optional(),
  categoryId: z.string().trim().min(1, 'categoryId is required'),
  description: z.string().trim().min(1, 'description is required'),
  address: z.string().trim().min(1, 'address is required').optional(),
  preferredDate: z.coerce.date().optional(),
});

export const OrderListQuerySchema = z.object({
  scope: z
    .enum(['active', 'past', 'incoming', 'accepted', 'completed'])
    .optional(),
});

export const UpdateOrderSchema = z
  .object({
    description: z.string().trim().min(1, 'description is required').optional(),
    address: z.string().trim().min(1, 'address is required').optional(),
    preferredDate: z.coerce.date().optional(),
    status: orderStatusSchema.optional(),
  })
  .refine((value) => Object.values(value).some((field) => field !== undefined), {
    message: 'At least one field is required',
  });

export type CreateOrderInput = z.infer<typeof CreateOrderSchema>;
export type UpdateOrderInput = z.infer<typeof UpdateOrderSchema>;
export type OrderListQuery = z.infer<typeof OrderListQuerySchema>;
