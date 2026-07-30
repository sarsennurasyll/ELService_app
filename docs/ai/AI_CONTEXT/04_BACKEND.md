# Backend

## Технологии

Backend находится в папке `backend`.

Используются:

- Node.js `>=22`;
- Express `5.1.0`;
- TypeScript `5.9.2`;
- Prisma `6.16.0`;
- PostgreSQL;
- JWT через `jsonwebtoken`;
- bcrypt;
- Zod;
- cors;
- helmet;
- morgan;
- dotenv;
- Docker.

## Запуск backend

Основной файл запуска:

- `backend/src/server.ts`.

`server.ts`:

- создаёт Express app через `createApp()`;
- подключается к Prisma;
- запускает сервер на `appConfig.port`.

Express app создаётся в:

- `backend/src/app.ts`.

`createApp()`:

- подключает `helmet`;
- подключает CORS;
- подключает `morgan`;
- подключает JSON parser;
- подключает URL encoded parser;
- монтирует API router на `/api/v1`;
- подключает `notFoundHandler`;
- подключает `errorHandler`.

## Конфигурация

Файлы:

- `backend/src/config/env.ts`;
- `backend/src/config/app.config.ts`.

Переменные окружения валидируются через Zod.

Обязательные:

- `DATABASE_URL`;
- `JWT_ACCESS_SECRET`;
- `JWT_REFRESH_SECRET`.

С дефолтами:

- `NODE_ENV`: `development`;
- `PORT`: `3000`;
- `JWT_ACCESS_EXPIRES_IN`: `15m`;
- `JWT_REFRESH_EXPIRES_IN`: `30d`;
- `CORS_ORIGIN`: `*`.

## CORS

CORS настроен в `backend/src/app.ts`.

Production:

- разрешается только origin, равный `appConfig.corsOrigin`.

Development/test:

- дополнительно разрешены локальные origin:
  - `http://localhost:<любой порт>`;
  - `https://localhost:<любой порт>`;
  - `http://127.0.0.1:<любой порт>`;
  - `https://127.0.0.1:<любой порт>`.

Это нужно для Flutter Web, который при локальном запуске может использовать случайный порт.

## Структура backend

```text
backend/
  prisma/
    migrations/
    schema.prisma
  src/
    config/
    controllers/
    middlewares/
    prisma/
    repositories/
    routes/
    services/
    types/
    utils/
    app.ts
    server.ts
  Dockerfile
  docker-compose.yml
  package.json
  tsconfig.json
```

## Routes

Главный router:

- `backend/src/routes/index.ts`.

Подключённые группы:

- `/health`;
- `/auth`;
- `/categories`;
- `/orders`;
- `/orders/:id/offers`;
- `/offers`;
- `/users`;
- `/chats`.

## Controllers

Controllers:

- `auth.controller.ts`;
- `category.controller.ts`;
- `order.controller.ts`;
- `offer.controller.ts`;
- `user.controller.ts`;
- `chat.controller.ts`;
- `health.controller.ts`.

Controllers используют `asyncHandler` и `sendSuccess`.

## Services

Services:

- `AuthService`;
- `CategoryService`;
- `OrderService`;
- `OfferService`;
- `UserService`;
- `ChatService`.

Services содержат основные проверки:

- уникальность email/phone при регистрации;
- проверка пароля;
- проверка refresh token;
- существование категории;
- существование пользователя;
- существование заказа;
- доступ к предложениям;
- роль мастера для создания предложения;
- доступ к чату только участников;
- создание чата после принятия предложения.

## Repositories

Repositories:

- `UserRepository`;
- `CategoryRepository`;
- `OrderRepository`;
- `OfferRepository`;
- `ChatRepository`.

Repositories обращаются к Prisma Client.

## Prisma

Prisma Client экспортируется из:

- `backend/src/prisma/client.ts`.

Схема находится в:

- `backend/prisma/schema.prisma`.

## Middleware

### authMiddleware

Файл:

- `backend/src/middlewares/auth.middleware.ts`.

Проверяет заголовок:

```text
Authorization: Bearer <accessToken>
```

Если токен валиден, payload записывается в `req.user`.

Если токена нет или он невалиден, возвращается `401`.

### validate

Файл:

- `backend/src/middlewares/validate.middleware.ts`.

Валидирует `body`, `query` или `params` через Zod.

При ошибке возвращает `400 Validation failed`.

### errorHandler

Файл:

- `backend/src/middlewares/error.middleware.ts`.

Если ошибка является `AppError`, возвращает её статус и сообщение.

Иначе пишет ошибку в консоль и возвращает `500 Internal server error`.

### notFoundHandler

Возвращает `404 Route not found` для неизвестных маршрутов.

## ApiResponse

Файл:

- `backend/src/utils/api-response.ts`.

Успешный ответ:

```json
{
  "success": true,
  "data": {}
}
```

Ошибка:

```json
{
  "success": false,
  "message": "Ошибка",
  "errors": {}
}
```

`errors` добавляется только если есть дополнительные детали.

## Auth

### Register

Endpoint:

```text
POST /api/v1/auth/register
```

Валидация:

- `fullName`: строка, минимум 2 символа;
- `email`: валидный email;
- `phone`: строка, минимум 8 символов;
- `password`: минимум 6 символов;
- `role`: `CUSTOMER`, `TECHNICIAN`, `ADMIN`, по умолчанию `CUSTOMER`.

Логика:

- проверяется уникальность email;
- проверяется уникальность phone;
- пароль хешируется через bcrypt;
- создаётся пользователь;
- создаются access/refresh tokens;
- возвращается публичный пользователь без `passwordHash`.

### Login

Endpoint:

```text
POST /api/v1/auth/login
```

Логика:

- пользователь ищется по email;
- пароль проверяется через bcrypt;
- возвращаются токены и пользователь.

### Refresh

Endpoint:

```text
POST /api/v1/auth/refresh
```

Логика:

- проверяется refresh token;
- ищется пользователь;
- возвращается новый access token.

Ограничение:

- blacklist refresh token пока не реализован.

### Logout

Endpoint:

```text
POST /api/v1/auth/logout
```

Логика:

- возвращает сообщение `Logged out successfully`.

Ограничение:

- серверное инвалидирование refresh token пока не реализовано.

## Categories

Endpoints:

- `GET /api/v1/categories`;
- `GET /api/v1/categories/:id`.

Список категорий сортируется по `name ASC`.

Если категория не найдена, возвращается `404 Category not found`.

Создание/обновление/удаление категорий не реализованы.

## Orders

Endpoints:

- `POST /api/v1/orders`;
- `GET /api/v1/orders`;
- `GET /api/v1/orders/:id`;
- `PATCH /api/v1/orders/:id`;
- `DELETE /api/v1/orders/:id`.

Create:

- проверяет существование категории;
- проверяет существование пользователя;
- создаёт заказ со статусом `PENDING`.

List:

- возвращает все заказы;
- сортирует по `createdAt DESC`.

Get by id:

- возвращает заказ;
- если не найден, возвращает `404 Order not found`.

Update:

- разрешает менять `description`, `address`, `preferredDate`, `status`.

Delete:

- удаляет заказ;
- если не найден, возвращает `404 Order not found`.

Ограничение:

- endpoints заказов сейчас не защищены `authMiddleware`;
- создание заказа принимает `customerId` из body, а не из JWT.

## Offers

Endpoints:

- `POST /api/v1/offers`;
- `GET /api/v1/orders/:id/offers`;
- `PATCH /api/v1/offers/:id/accept`;
- `DELETE /api/v1/offers/:id`.

Все endpoints предложений защищены `authMiddleware`.

Create:

- доступно только роли `TECHNICIAN`;
- заказ должен существовать;
- заказ должен иметь статус `PENDING`;
- создаётся предложение со статусом `ACTIVE`;
- действует уникальность пары `orderId + masterId`.

List by order:

- доступно администратору или клиенту-владельцу заказа;
- возвращает предложения по заказу;
- включает имя мастера.

Accept:

- доступно администратору или клиенту-владельцу заказа;
- предложение должно существовать;
- предложение должно быть `ACTIVE`;
- выбранное предложение получает статус `ACCEPTED`;
- остальные активные предложения заказа получают `INACTIVE`;
- заказ получает `assignedMasterId`;
- заказ получает статус `ACCEPTED`;
- если для заказа ещё нет чата, создаётся `Conversation`.

Delete:

- доступно администратору или мастеру-владельцу предложения;
- удаляет предложение.

## Users

Endpoints:

- `GET /api/v1/users/me`;
- `PATCH /api/v1/users/me`.

Оба endpoint защищены `authMiddleware`.

Get me:

- берёт user id из JWT;
- возвращает публичный профиль.

Update me:

- берёт user id из JWT;
- разрешает менять `fullName`, `phone`, `avatar`, `city`;
- email менять нельзя.

## Chat

Endpoints:

- `POST /api/v1/chats`;
- `GET /api/v1/chats`;
- `GET /api/v1/chats/:id/messages`;
- `POST /api/v1/chats/:id/messages`.

Все endpoints чата защищены `authMiddleware`.

Create:

- принимает `orderId`;
- заказ должен существовать;
- пользователь должен быть клиентом заказа или назначенным мастером;
- если чат уже существует, возвращает существующий;
- если чата нет, создаёт `Conversation`.

List:

- возвращает чаты, где текущий пользователь является `userA` или `userB`;
- включает заказ;
- включает последнее сообщение;
- сортирует по `updatedAt DESC`.

Messages:

- возвращает сообщения чата;
- пользователь должен быть участником чата;
- сортирует по `createdAt ASC`.

Send:

- создаёт сообщение;
- пользователь должен быть участником чата.

Ограничение:

- WebSocket не реализован;
- обмен сообщениями предполагается через HTTP polling.

## Docker

`backend/docker-compose.yml` содержит:

- сервис `postgres`;
- сервис `api`.

PostgreSQL:

- image `postgres:16-alpine`;
- container `elservice-postgres`;
- database `elservice`;
- user `elservice`;
- password `elservice`;
- порт хоста `5433`, порт контейнера `5432`.

API:

- собирается из `backend/Dockerfile`;
- container `elservice-api`;
- порт `3000`;
- зависит от `postgres`;
- использует `.env`;
- переопределяет `DATABASE_URL` на Docker-сетевой адрес `postgres:5432`.

## Ограничения backend

- Нет seed-скрипта категорий.
- Нет API для reviews.
- Нет API для notifications.
- Нет API для payments.
- Нет admin API.
- Нет blacklist refresh token.
- Нет WebSocket.
- Chat/Offer часть в некоторых файлах отформатирована плотно, но функционально присутствует.
