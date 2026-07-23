CREATE INDEX IF NOT EXISTS "Order_createdAt_idx" ON "Order"("createdAt");
CREATE INDEX IF NOT EXISTS "Order_customerId_createdAt_idx" ON "Order"("customerId", "createdAt");
CREATE INDEX IF NOT EXISTS "Order_assignedMasterId_status_idx" ON "Order"("assignedMasterId", "status");
CREATE INDEX IF NOT EXISTS "Review_technicianId_createdAt_idx" ON "Review"("technicianId", "createdAt");
CREATE INDEX IF NOT EXISTS "Conversation_userAId_updatedAt_idx" ON "Conversation"("userAId", "updatedAt");
CREATE INDEX IF NOT EXISTS "Conversation_userBId_updatedAt_idx" ON "Conversation"("userBId", "updatedAt");
CREATE INDEX IF NOT EXISTS "Message_conversationId_createdAt_idx" ON "Message"("conversationId", "createdAt");
