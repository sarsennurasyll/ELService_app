# API

## Base URL

Backend монтирует API на:

```text
/api/v1
```

Локальный Flutter config использует:

```text
http://localhost:3000/api/v1
```

Локальный health-check:

```text
GET http://localhost:3000/api/v1/health
```

## Формат ответа

### Success

```json
{
  "success": true,
  "data": {}
}
```

### Error

```json
{
  "success": false,
  "message": "Error message"
}
```

При ошибках валидации может добавляться поле `errors`.

## Авторизация

Защищённые endpoints требуют заголовок:

```text
Authorization: Bearer <accessToken>
```

JWT payload содержит:

- `sub`: id пользователя;
- `role`: роль пользователя.

## Health

### GET /api/v1/health

Проверяет, что API работает.

Response:

```json
{
  "success": true,
  "message": "ELService API is running"
}
```

## Auth

### POST /api/v1/auth/register

Создаёт пользователя.

Auth не требуется.

Request:

```json
{
  "fullName": "Aigerim Bek",
  "email": "aigerim@example.com",
  "phone": "+77001234567",
  "password": "password123",
  "role": "CUSTOMER"
}
```

Правила:

- `fullName`: минимум 2 символа;
- `email`: валидный email;
- `phone`: минимум 8 символов;
- `password`: минимум 6 символов;
- `role`: `CUSTOMER`, `TECHNICIAN`, `ADMIN`, по умолчанию `CUSTOMER`.

Success `201`:

```json
{
  "success": true,
  "data": {
    "accessToken": "...",
    "refreshToken": "...",
    "user": {
      "id": "...",
      "fullName": "Aigerim Bek",
      "email": "aigerim@example.com",
      "phone": "+77001234567",
      "avatar": null,
      "city": null,
      "role": "CUSTOMER",
      "createdAt": "2026-07-22T15:40:53.604Z",
      "updatedAt": "2026-07-22T15:40:53.604Z"
    }
  }
}
```

Errors:

- `400 Validation failed`;
- `409 Email already exists`;
- `409 Phone already exists`;
- `500 Internal server error`.

### POST /api/v1/auth/login

Выполняет вход.

Request:

```json
{
  "email": "aigerim@example.com",
  "password": "password123"
}
```

Success `200`:

```json
{
  "success": true,
  "data": {
    "accessToken": "...",
    "refreshToken": "...",
    "user": {}
  }
}
```

Errors:

- `400 Validation failed`;
- `401 Invalid email or password`;
- `500 Internal server error`.

### POST /api/v1/auth/refresh

Возвращает новый access token.

Request:

```json
{
  "refreshToken": "..."
}
```

Success:

```json
{
  "success": true,
  "data": {
    "accessToken": "..."
  }
}
```

Errors:

- `400 Validation failed`;
- `401 Invalid refresh token`;
- `500 Internal server error`.

### POST /api/v1/auth/logout

Завершает сессию на уровне ответа API.

Request:

```json
{
  "refreshToken": "..."
}
```

`refreshToken` может отсутствовать.

Success:

```json
{
  "success": true,
  "data": {
    "message": "Logged out successfully"
  }
}
```

Ограничение:

- blacklist refresh token не реализован.

## Categories

### GET /api/v1/categories

Возвращает список категорий.

Auth не требуется.

Success:

```json
{
  "success": true,
  "data": [
    {
      "id": "...",
      "name": "Refrigerator",
      "icon": "..."
    }
  ]
}
```

Сортировка:

- `name ASC`.

### GET /api/v1/categories/:id

Возвращает категорию по id.

Errors:

- `404 Category not found`;
- `500 Internal server error`.

## Orders

### POST /api/v1/orders

Создаёт заказ.

Auth middleware сейчас не подключён.

Request:

```json
{
  "customerId": "...",
  "categoryId": "...",
  "description": "Не охлаждает холодильник",
  "address": "Astana, Kazakhstan",
  "preferredDate": "2026-07-23T10:00:00.000Z"
}
```

Обязательные поля:

- `customerId`;
- `categoryId`;
- `description`.

Опциональные:

- `address`;
- `preferredDate`.

Логика:

- проверяется существование категории;
- проверяется существование пользователя;
- статус нового заказа: `PENDING`.

Success `201`:

```json
{
  "success": true,
  "data": {
    "id": "...",
    "customerId": "...",
    "categoryId": "...",
    "status": "PENDING",
    "description": "..."
  }
}
```

Errors:

- `400 Validation failed`;
- `404 Category not found`;
- `404 User not found`;
- `500 Internal server error`.

### GET /api/v1/orders

Возвращает список заказов.

Auth middleware сейчас не подключён.

Сортировка:

- `createdAt DESC`.

### GET /api/v1/orders/:id

Возвращает заказ по id.

Errors:

- `404 Order not found`;
- `500 Internal server error`.

### PATCH /api/v1/orders/:id

Обновляет заказ.

Auth middleware сейчас не подключён.

Request может содержать:

```json
{
  "description": "Новое описание",
  "address": "Новый адрес",
  "preferredDate": "2026-07-23T10:00:00.000Z",
  "status": "ACTIVE"
}
```

Разрешённые статусы:

- `PENDING`;
- `ACCEPTED`;
- `ACTIVE`;
- `COMPLETED`;
- `CANCELLED`;
- `DISPUTED`.

Должно быть передано хотя бы одно поле.

Errors:

- `400 Validation failed`;
- `404 Order not found`;
- `500 Internal server error`.

### DELETE /api/v1/orders/:id

Удаляет заказ.

Auth middleware сейчас не подключён.

Success:

```json
{
  "success": true,
  "data": {
    "id": "..."
  }
}
```

Errors:

- `404 Order not found`;
- `500 Internal server error`.

## Offers

### POST /api/v1/offers

Мастер создаёт предложение.

Auth требуется.

Request:

```json
{
  "orderId": "...",
  "price": 25000,
  "arrivalTime": "Today 14:00-16:00",
  "comment": "Могу приехать сегодня"
}
```

Правила:

- пользователь должен иметь роль `TECHNICIAN`;
- заказ должен существовать;
- заказ должен быть в статусе `PENDING`;
- `price` должен быть положительным;
- `arrivalTime` обязателен;
- `comment` опционален, но если передан, не должен быть пустым.

Success `201`:

```json
{
  "success": true,
  "data": {
    "id": "...",
    "orderId": "...",
    "masterId": "...",
    "price": "25000",
    "arrivalTime": "Today 14:00-16:00",
    "comment": "Могу приехать сегодня",
    "status": "ACTIVE"
  }
}
```

Errors:

- `401 Unauthorized`;
- `403 Forbidden`;
- `404 Order not found`;
- `409 Order is unavailable`;
- `500 Internal server error`.

### GET /api/v1/orders/:id/offers

Возвращает предложения по заказу.

Auth требуется.

Доступ:

- администратор;
- клиент-владелец заказа.

Success:

```json
{
  "success": true,
  "data": [
    {
      "id": "...",
      "orderId": "...",
      "masterId": "...",
      "price": "25000",
      "arrivalTime": "...",
      "status": "ACTIVE",
      "master": {
        "id": "...",
        "fullName": "..."
      }
    }
  ]
}
```

Errors:

- `401 Unauthorized`;
- `403 Forbidden`;
- `404 Order not found`.

### PATCH /api/v1/offers/:id/accept

Принимает предложение.

Auth требуется.

Доступ:

- администратор;
- клиент-владелец заказа.

Логика:

- выбранное предложение получает `ACCEPTED`;
- другие активные предложения заказа получают `INACTIVE`;
- заказ получает `assignedMasterId`;
- заказ получает статус `ACCEPTED`;
- создаётся чат, если его ещё нет.

Errors:

- `401 Unauthorized`;
- `403 Forbidden`;
- `404 Offer not found`;
- `404 Order not found`;
- `409 Offer is unavailable`.

### DELETE /api/v1/offers/:id

Удаляет предложение.

Auth требуется.

Доступ:

- администратор;
- мастер-владелец предложения.

Success:

```json
{
  "success": true,
  "data": {
    "id": "..."
  }
}
```

Errors:

- `401 Unauthorized`;
- `403 Forbidden`;
- `404 Offer not found`.

## Users

### GET /api/v1/users/me

Возвращает профиль текущего пользователя.

Auth требуется.

Success:

```json
{
  "success": true,
  "data": {
    "id": "...",
    "fullName": "...",
    "email": "...",
    "phone": "...",
    "avatar": null,
    "city": null,
    "role": "CUSTOMER",
    "createdAt": "...",
    "updatedAt": "..."
  }
}
```

Errors:

- `401 Unauthorized`;
- `404 User not found`.

### PATCH /api/v1/users/me

Обновляет профиль текущего пользователя.

Auth требуется.

Request:

```json
{
  "fullName": "Aigerim Bek",
  "phone": "+77001234567",
  "avatar": "https://example.com/avatar.png",
  "city": "Astana"
}
```

Разрешено менять:

- `fullName`;
- `phone`;
- `avatar`;
- `city`.

Email менять нельзя.

Должно быть передано хотя бы одно поле.

Errors:

- `400 Validation failed`;
- `401 Unauthorized`;
- `404 User not found`.

## Chats

### POST /api/v1/chats

Создаёт чат или возвращает существующий чат по заказу.

Auth требуется.

Request:

```json
{
  "orderId": "..."
}
```

Доступ:

- клиент заказа;
- назначенный мастер заказа.

Errors:

- `401 Unauthorized`;
- `403 Forbidden`;
- `404 Order not found`.

### GET /api/v1/chats

Возвращает список чатов текущего пользователя.

Auth требуется.

Response содержит:

- conversation fields;
- `order`;
- последнее сообщение в `messages`.

### GET /api/v1/chats/:id/messages

Возвращает сообщения чата.

Auth требуется.

Сортировка:

- `createdAt ASC`.

Errors:

- `401 Unauthorized`;
- `403 Forbidden`;
- `404 Chat not found`.

### POST /api/v1/chats/:id/messages

Отправляет сообщение.

Auth требуется.

Request:

```json
{
  "text": "Здравствуйте"
}
```

Errors:

- `400 Validation failed`;
- `401 Unauthorized`;
- `403 Forbidden`;
- `404 Chat not found`.

## Нереализованные API

Не найдены endpoints для:

- reviews;
- notifications;
- payments;
- admin analytics;
- technician dashboard;
- technician wallet;
- technician calendar;
- category management.
