-- CreateEnum
CREATE TYPE "InstanceConnectionStatus" AS ENUM ('ONLINE', 'OFFLINE');

-- CreateEnum
CREATE TYPE "MessageSource" AS ENUM ('ios', 'android', 'web');

-- CreateEnum
CREATE TYPE "DeviceMessage" AS ENUM ('ios', 'android', 'web', 'unknown', 'desktop');

-- CreateTable
CREATE TABLE "Instance" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "description" VARCHAR(255),
    "connectionStatus" "InstanceConnectionStatus" DEFAULT 'OFFLINE',
    "ownerJid" VARCHAR(100),
    "profilePicUrl" VARCHAR(500),
    "createdAt" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3),
    "externalAttributes" JSONB,

    CONSTRAINT "Instance_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Auth" (
    "id" SERIAL NOT NULL,
    "token" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3),
    "instanceId" INTEGER NOT NULL,

    CONSTRAINT "Auth_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Message" (
    "id" SERIAL NOT NULL,
    "keyId" VARCHAR(100) NOT NULL,
    "keyRemoteJid" VARCHAR(100),
    "keyLid" VARCHAR(100),
    "keyFromMe" BOOLEAN NOT NULL,
    "keyParticipant" VARCHAR(100),
    "keyParticipantLid" VARCHAR(100),
    "pushName" VARCHAR(100),
    "messageType" VARCHAR(100) NOT NULL,
    "content" JSONB NOT NULL,
    "messageTimestamp" INTEGER NOT NULL,
    "device" "DeviceMessage" NOT NULL,
    "isGroup" BOOLEAN,
    "instanceId" INTEGER NOT NULL,

    CONSTRAINT "Message_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Media" (
    "id" SERIAL NOT NULL,
    "fileName" VARCHAR(500) NOT NULL,
    "type" VARCHAR(100) NOT NULL,
    "mimetype" VARCHAR(100) NOT NULL,
    "createdAt" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,
    "messageId" INTEGER NOT NULL,

    CONSTRAINT "Media_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MessageUpdate" (
    "id" SERIAL NOT NULL,
    "dateTime" TIMESTAMP(3) NOT NULL,
    "status" VARCHAR(30) NOT NULL,
    "messageId" INTEGER NOT NULL,

    CONSTRAINT "MessageUpdate_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Chat" (
    "id" SERIAL NOT NULL,
    "remoteJid" VARCHAR(100) NOT NULL,
    "content" JSONB,
    "createdAt" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3),
    "instanceId" INTEGER NOT NULL,

    CONSTRAINT "Chat_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Contact" (
    "id" SERIAL NOT NULL,
    "remoteJid" VARCHAR(100) NOT NULL,
    "pushName" VARCHAR(100),
    "profilePicUrl" VARCHAR(500),
    "createdAt" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3),
    "instanceId" INTEGER NOT NULL,

    CONSTRAINT "Contact_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Webhook" (
    "id" SERIAL NOT NULL,
    "url" VARCHAR(500) NOT NULL,
    "enabled" BOOLEAN DEFAULT true,
    "events" JSONB,
    "createdAt" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "instanceId" INTEGER NOT NULL,

    CONSTRAINT "Webhook_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ActivityLogs" (
    "id" SERIAL NOT NULL,
    "dateTime" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,
    "context" VARCHAR(100),
    "type" VARCHAR(100),
    "content" JSONB,
    "description" VARCHAR(500),
    "instanceId" INTEGER,

    CONSTRAINT "ActivityLogs_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Instance_name_key" ON "Instance"("name");

-- CreateIndex
CREATE UNIQUE INDEX "Auth_token_key" ON "Auth"("token");

-- CreateIndex
CREATE UNIQUE INDEX "Auth_instanceId_key" ON "Auth"("instanceId");

-- CreateIndex
CREATE INDEX "keyId" ON "Message"("keyId");

-- CreateIndex
CREATE UNIQUE INDEX "Media_fileName_key" ON "Media"("fileName");

-- CreateIndex
CREATE UNIQUE INDEX "Media_messageId_key" ON "Media"("messageId");

-- CreateIndex
CREATE UNIQUE INDEX "Webhook_instanceId_key" ON "Webhook"("instanceId");

-- AddForeignKey
ALTER TABLE "Auth" ADD CONSTRAINT "Auth_instanceId_fkey" FOREIGN KEY ("instanceId") REFERENCES "Instance"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Message" ADD CONSTRAINT "Message_instanceId_fkey" FOREIGN KEY ("instanceId") REFERENCES "Instance"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Media" ADD CONSTRAINT "Media_messageId_fkey" FOREIGN KEY ("messageId") REFERENCES "Message"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MessageUpdate" ADD CONSTRAINT "MessageUpdate_messageId_fkey" FOREIGN KEY ("messageId") REFERENCES "Message"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Chat" ADD CONSTRAINT "Chat_instanceId_fkey" FOREIGN KEY ("instanceId") REFERENCES "Instance"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Contact" ADD CONSTRAINT "Contact_instanceId_fkey" FOREIGN KEY ("instanceId") REFERENCES "Instance"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Webhook" ADD CONSTRAINT "Webhook_instanceId_fkey" FOREIGN KEY ("instanceId") REFERENCES "Instance"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ActivityLogs" ADD CONSTRAINT "ActivityLogs_instanceId_fkey" FOREIGN KEY ("instanceId") REFERENCES "Instance"("id") ON DELETE CASCADE ON UPDATE CASCADE;
