import { z } from 'zod';

const orderStatusSchema = z.enum([
  'PENDING',
  'ACTIVE',
  'COMPLETED',
  'CANCELLED',
  'DISPUTED',
]);

export const CreateOrderSchema = z.object({
  customerId: z.string().trim().min(1, 'customerId is required'),
  categoryId: z.string().trim().min(1, 'categoryId is required'),
  description: z.string().trim().min(1, 'description is required'),
  address: z.string().trim().min(1, 'address is required').optional(),
  preferredDate: z.coerce.date().optional(),
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
