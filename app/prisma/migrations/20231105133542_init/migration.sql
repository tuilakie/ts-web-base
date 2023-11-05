/*
  Warnings:

  - The primary key for the `User` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - You are about to drop the `Post` table. If the table is not empty, all the data it contains will be lost.
  - Added the required column `updatedAt` to the `User` table without a default value. This is not possible if the table is not empty.

*/
-- CreateEnum
CREATE TYPE "UserPermission" AS ENUM ('ADMIN', 'USER', 'ITEMCREATE', 'ITEMUPDATE', 'ITEMDELETE', 'PERMISSIONUPDATE');

-- CreateEnum
CREATE TYPE "Gender" AS ENUM ('MALE', 'FEMALE', 'OTHER');

-- CreateEnum
CREATE TYPE "RoomStatus" AS ENUM ('AVAILABLE', 'RESERVED', 'RENTED');

-- CreateEnum
CREATE TYPE "InvoiceStatus" AS ENUM ('paid', 'unpaid', 'cancel');

-- DropForeignKey
ALTER TABLE "Post" DROP CONSTRAINT "Post_authorId_fkey";

-- AlterTable
ALTER TABLE "User" DROP CONSTRAINT "User_pkey",
ADD COLUMN     "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "departmentId" TEXT,
ADD COLUMN     "permissions" "UserPermission"[],
ADD COLUMN     "updatedAt" TIMESTAMP(3) NOT NULL,
ALTER COLUMN "id" DROP DEFAULT,
ALTER COLUMN "id" SET DATA TYPE TEXT,
ADD CONSTRAINT "User_pkey" PRIMARY KEY ("id");
DROP SEQUENCE "User_id_seq";

-- DropTable
DROP TABLE "Post";

-- CreateTable
CREATE TABLE "Department" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "location" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Department_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Room" (
    "id" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "max" INTEGER NOT NULL,
    "space" INTEGER NOT NULL,
    "roomPrice" INTEGER NOT NULL,
    "electricityPrice" INTEGER NOT NULL,
    "waterPrice" INTEGER NOT NULL,
    "internetPrice" INTEGER NOT NULL,
    "cleaningPrice" INTEGER NOT NULL,
    "washingmechinePrice" INTEGER NOT NULL,
    "parkingPrice" INTEGER NOT NULL,
    "monthlyChargeDate" INTEGER NOT NULL,
    "paymentTermDate" INTEGER NOT NULL,
    "status" "RoomStatus" NOT NULL,
    "genderPriority" "Gender"[],
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "departmentId" TEXT,

    CONSTRAINT "Room_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Tenant" (
    "id" TEXT NOT NULL,
    "fullname" TEXT NOT NULL,
    "phone" TEXT NOT NULL,
    "cccd" TEXT NOT NULL,
    "cccdFront" TEXT NOT NULL,
    "cccdBack" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "joinDate" TIMESTAMP(3) NOT NULL,
    "dob" TIMESTAMP(3) NOT NULL,
    "gender" "Gender" NOT NULL,
    "avatar" TEXT NOT NULL,
    "roomId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "contractId" TEXT,

    CONSTRAINT "Tenant_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Contract" (
    "id" TEXT NOT NULL,
    "from" TIMESTAMP(3) NOT NULL,
    "to" TIMESTAMP(3) NOT NULL,
    "deposit" INTEGER NOT NULL,
    "reason" TEXT NOT NULL,
    "initialElectric" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "primaryTenantId" TEXT,
    "tenaniId" TEXT,
    "roomId" TEXT,

    CONSTRAINT "Contract_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Invoice" (
    "id" TEXT NOT NULL,
    "status" "InvoiceStatus" NOT NULL,
    "payerId" TEXT,
    "contractId" TEXT,
    "roomAmount" INTEGER NOT NULL,
    "electricityAmount" INTEGER NOT NULL,
    "waterAmount" INTEGER NOT NULL,
    "internetAmount" INTEGER NOT NULL,
    "cleaningAmount" INTEGER NOT NULL,
    "washingmechineAmount" INTEGER NOT NULL,
    "parkingAmount" INTEGER NOT NULL,
    "totalAmount" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "oldElectricityNumber" INTEGER NOT NULL,
    "newElectricityNumber" INTEGER NOT NULL,
    "usedElectricity" INTEGER NOT NULL,
    "oldWaterNumber" INTEGER NOT NULL,
    "newWaterNumber" INTEGER NOT NULL,
    "usedWater" INTEGER NOT NULL,

    CONSTRAINT "Invoice_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "User" ADD CONSTRAINT "User_departmentId_fkey" FOREIGN KEY ("departmentId") REFERENCES "Department"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Room" ADD CONSTRAINT "Room_departmentId_fkey" FOREIGN KEY ("departmentId") REFERENCES "Department"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Tenant" ADD CONSTRAINT "Tenant_roomId_fkey" FOREIGN KEY ("roomId") REFERENCES "Room"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Tenant" ADD CONSTRAINT "Tenant_contractId_fkey" FOREIGN KEY ("contractId") REFERENCES "Contract"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Contract" ADD CONSTRAINT "Contract_roomId_fkey" FOREIGN KEY ("roomId") REFERENCES "Room"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Invoice" ADD CONSTRAINT "Invoice_payerId_fkey" FOREIGN KEY ("payerId") REFERENCES "Tenant"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Invoice" ADD CONSTRAINT "Invoice_contractId_fkey" FOREIGN KEY ("contractId") REFERENCES "Contract"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- RenameIndex
ALTER INDEX "User.email_unique" RENAME TO "User_email_key";
