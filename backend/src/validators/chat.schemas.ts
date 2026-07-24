import { z } from 'zod';
export const CreateChatSchema = z.object({ orderId: z.string().min(1) });
export const CreateMessageSchema = z.object({ text: z.string().trim().min(1) });
export type CreateMessageInput = z.infer<typeof CreateMessageSchema>;
