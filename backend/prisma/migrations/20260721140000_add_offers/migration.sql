-- AlterEnum
ALTER TYPE "OrderStatus" ADD VALUE IF NOT EXISTS 'ACCEPTED';

-- CreateEnum
CREATE TYPE "OfferStatus" AS ENUM ('ACTIVE', 'ACCEPTED', 'INACTIVE');

-- AlterTable
ALTER TABLE "Order" ADD COLUMN "assignedMasterId" TEXT;

-- CreateTable
CREATE TABLE "Offer" (
    "id" TEXT NOT NULL,
    "price" DECIMAL(12,2) NOT NULL,
    "arrivalTime" TEXT NOT NULL,
    "comment" TEXT,
    "status" "OfferStatus" NOT NULL DEFAULT 'ACTIVE',
    "orderId" TEXT NOT NULL,
    "masterId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "Offer_pkey" PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX "Offer_orderId_masterId_key" ON "Offer"("orderId", "masterId");
CREATE INDEX "Offer_orderId_idx" ON "Offer"("orderId");
ALTER TABLE "Order" ADD CONSTRAINT "Order_assignedMasterId_fkey" FOREIGN KEY ("assignedMasterId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE "Offer" ADD CONSTRAINT "Offer_orderId_fkey" FOREIGN KEY ("orderId") REFERENCES "Order"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "Offer" ADD CONSTRAINT "Offer_masterId_fkey" FOREIGN KEY ("masterId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
