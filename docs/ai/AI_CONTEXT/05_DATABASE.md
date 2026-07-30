# Database

## Технологии

База данных — PostgreSQL.

ORM — Prisma.

Схема находится в:

```text
backend/prisma/schema.prisma
```

Миграции находятся в:

```text
backend/prisma/migrations
```

## Datasource

```prisma
datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}
```

## Enums

### UserRole

Роли пользователей:

- `CUSTOMER`;
- `TECHNICIAN`;
- `ADMIN`.

### OrderStatus

Статусы заказа:

- `PENDING`;
- `ACCEPTED`;
- `ACTIVE`;
- `COMPLETED`;
- `CANCELLED`;
- `DISPUTED`.

Исторически первая миграция создавала enum без `ACCEPTED`. Значение `ACCEPTED` добавлено миграцией `20260721140000_add_offers`.

### OfferStatus

Статусы предложения:

- `ACTIVE`;
- `ACCEPTED`;
- `INACTIVE`.

## Таблица User

Prisma model:

```text
User
```

Поля:

- `id`: `String`, primary key, `cuid()`;
- `fullName`: `String`;
- `email`: `String`, unique;
- `phone`: `String?`;
- `avatar`: `String?`;
- `city`: `String?`;
- `passwordHash`: `String`;
- `role`: `UserRole`;
- `createdAt`: `DateTime`, default `now()`;
- `updatedAt`: `DateTime`, auto updated.

Связи:

- `customerOrders`: заказы, где пользователь клиент;
- `technicianOrders`: заказы, где пользователь technician;
- `assignedMasterOrders`: заказы, где пользователь назначенный мастер;
- `offers`: предложения мастера;
- `reviewsGiven`: отзывы, оставленные пользователем;
- `reviewsReceived`: отзывы, полученные пользователем;
- `messages`: сообщения пользователя;
- `conversationsA`: чаты, где пользователь `userA`;
- `conversationsB`: чаты, где пользователь `userB`;
- `notifications`: уведомления пользователя.

Важно:

- `passwordHash` не должен уходить на frontend;
- email уникален;
- phone проверяется на уникальность в AuthService через `findFirst`, но в схеме Prisma уникального индекса на `phone` нет.

## Таблица Category

Поля:

- `id`: `String`, primary key, `cuid()`;
- `name`: `String`, unique;
- `icon`: `String?`;
- `createdAt`: `DateTime`, default `now()`;
- `updatedAt`: `DateTime`, auto updated.

Связи:

- `orders`: заказы этой категории.

Ограничение:

- API создания категорий не реализован;
- seed-данные не найдены.

## Таблица Order

Поля:

- `id`: `String`, primary key, `cuid()`;
- `description`: `String`;
- `address`: `String?`;
- `price`: `Decimal?`, `Decimal(12, 2)`;
- `status`: `OrderStatus`, default `PENDING`;
- `preferredDate`: `DateTime?`;
- `customerId`: `String`;
- `technicianId`: `String?`;
- `assignedMasterId`: `String?`;
- `categoryId`: `String`;
- `createdAt`: `DateTime`, default `now()`;
- `updatedAt`: `DateTime`, auto updated.

Связи:

- `customer`: `User`, relation `CustomerOrders`;
- `technician`: `User?`, relation `TechnicianOrders`;
- `assignedMaster`: `User?`, relation `AssignedMasterOrders`;
- `category`: `Category`;
- `offers`: список `Offer`;
- `review`: `Review?`;
- `conversation`: `Conversation?`.

Ограничения:

- `customerId` обязателен;
- `categoryId` обязателен;
- `technicianId` и `assignedMasterId` опциональны;
- при создании заказа статус устанавливается `PENDING`.

## Таблица Offer

Поля:

- `id`: `String`, primary key, `cuid()`;
- `price`: `Decimal`, `Decimal(12, 2)`;
- `arrivalTime`: `String`;
- `comment`: `String?`;
- `status`: `OfferStatus`, default `ACTIVE`;
- `orderId`: `String`;
- `masterId`: `String`;
- `createdAt`: `DateTime`, default `now()`;
- `updatedAt`: `DateTime`, auto updated.

Связи:

- `order`: `Order`, cascade delete;
- `master`: `User`, relation `MasterOffers`.

Индексы:

- index по `orderId`;
- unique по `orderId + masterId`.

Логика:

- один мастер может иметь только одно предложение на один заказ;
- принятие предложения меняет статусы в транзакции.

## Таблица Review

Поля:

- `id`: `String`, primary key, `cuid()`;
- `rating`: `Int`;
- `comment`: `String?`;
- `orderId`: `String`, unique;
- `customerId`: `String`;
- `technicianId`: `String`;
- `createdAt`: `DateTime`, default `now()`;
- `updatedAt`: `DateTime`, auto updated.

Связи:

- `order`: `Order`;
- `customer`: `User`, relation `ReviewsGiven`;
- `technician`: `User`, relation `ReviewsReceived`.

Ограничение:

- backend API для отзывов не реализован.

## Таблица Conversation

Поля:

- `id`: `String`, primary key, `cuid()`;
- `orderId`: `String`, unique;
- `userAId`: `String`;
- `userBId`: `String`;
- `createdAt`: `DateTime`, default `now()`;
- `updatedAt`: `DateTime`, auto updated.

Связи:

- `order`: `Order`;
- `userA`: `User`;
- `userB`: `User`;
- `messages`: список `Message`.

Логика:

- один заказ имеет максимум один чат;
- чат создаётся после принятия предложения или через `POST /api/v1/chats`.

## Таблица Message

Поля:

- `id`: `String`, primary key, `cuid()`;
- `text`: `String`;
- `conversationId`: `String`;
- `senderId`: `String`;
- `createdAt`: `DateTime`, default `now()`;
- `updatedAt`: `DateTime`, auto updated.

Связи:

- `conversation`: `Conversation`;
- `sender`: `User`.

Логика:

- сообщение может отправить только участник чата.

## Таблица Notification

Поля:

- `id`: `String`, primary key, `cuid()`;
- `title`: `String`;
- `body`: `String`;
- `isRead`: `Boolean`, default `false`;
- `userId`: `String`;
- `createdAt`: `DateTime`, default `now()`;
- `updatedAt`: `DateTime`, auto updated.

Связи:

- `user`: `User`.

Ограничение:

- backend API уведомлений не реализован.

## Миграции

### 20260720183016_init_auth

Создаёт:

- `UserRole`;
- `OrderStatus` без `ACCEPTED`;
- таблицу `User`;
- таблицу `Category`;
- таблицу `Order`;
- таблицу `Review`;
- таблицу `Conversation`;
- таблицу `Message`;
- таблицу `Notification`;
- индексы;
- foreign keys.

### 20260721120000_add_order_preferred_date

Добавляет:

- `Order.preferredDate`.

### 20260721130000_add_user_profile_fields

Добавляет:

- `User.avatar`;
- `User.city`.

Эта миграция исправляет ошибку Prisma `P2022`, когда backend пытался читать поле `User.avatar`, но колонка отсутствовала в локальной базе.

### 20260721140000_add_offers

Добавляет:

- значение `ACCEPTED` в `OrderStatus`;
- enum `OfferStatus`;
- `Order.assignedMasterId`;
- таблицу `Offer`;
- unique/index для Offer;
- foreign keys для Offer и assigned master.

## Известное состояние миграций

Во время локальной проверки миграции были применены командой:

```bash
npx prisma migrate deploy
```

После применения Prisma сообщила:

```text
Database schema is up to date!
```

## Ограничения схемы

- В Prisma schema есть `Review` и `Notification`, но API для них не реализован.
- `phone` проверяется как уникальный в сервисе, но в базе нет unique index.
- `Conversation.updatedAt` автоматически обновляется при изменении самой записи, но отправка сообщения создаёт `Message` и не обновляет явно `Conversation.updatedAt`.
