# Запуск проекта с нуля

## Предварительные требования

Нужно установить:

- Flutter 3+;
- Dart SDK, совместимый с Flutter;
- Node.js 22+;
- npm;
- Docker Desktop;
- Git.

Для backend также нужен PostgreSQL. В проекте есть Docker Compose для локального PostgreSQL.

## Клонирование

```bash
git clone <repository-url>
cd ELService
```

`<repository-url>` не указан в проектных файлах.

## Установка Flutter-зависимостей

В корне проекта:

```bash
flutter pub get
```

## Установка backend-зависимостей

```bash
cd backend
npm install
```

## Переменные окружения backend

Создать файл:

```text
backend/.env
```

Минимальный пример для локальной разработки:

```env
NODE_ENV=development
PORT=3000
DATABASE_URL=postgresql://elservice:elservice@localhost:5433/elservice?schema=public
JWT_ACCESS_SECRET=local_access_secret
JWT_REFRESH_SECRET=local_refresh_secret
JWT_ACCESS_EXPIRES_IN=15m
JWT_REFRESH_EXPIRES_IN=30d
CORS_ORIGIN=http://localhost:5173
```

Важно:

- `CORS_ORIGIN` всё ещё нужен для основного разрешённого origin;
- в development/test backend дополнительно разрешает Flutter Web на случайных localhost-портах;
- в production нельзя оставлять простые локальные JWT secrets.

`.env.example` в проекте не найден, хотя backend README его упоминает.

## Запуск PostgreSQL через Docker

Из папки `backend`:

```bash
docker compose up -d postgres
```

PostgreSQL будет доступен на:

```text
localhost:5433
```

Данные:

- user: `elservice`;
- password: `elservice`;
- database: `elservice`.

## Prisma generate

Из папки `backend`:

```bash
npm run prisma:generate
```

или:

```bash
npx prisma generate
```

## Prisma migrations

Для применения существующих миграций:

```bash
npx prisma migrate deploy
```

Для разработки новых миграций в будущем:

```bash
npm run prisma:migrate
```

Текущие миграции:

- `20260720183016_init_auth`;
- `20260721120000_add_order_preferred_date`;
- `20260721130000_add_user_profile_fields`;
- `20260721140000_add_offers`.

Важно:

- ошибка `PrismaClientKnownRequestError P2022: The column User.avatar does not exist` возникает, если миграция `20260721130000_add_user_profile_fields` не применена к базе.

## Запуск backend

Из папки `backend`:

```bash
npm run dev
```

Backend должен подняться на:

```text
http://localhost:3000
```

Проверка:

```bash
curl http://localhost:3000/api/v1/health
```

Ожидаемый ответ:

```json
{
  "success": true,
  "message": "ELService API is running"
}
```

## Запуск Flutter

В корне проекта:

```bash
flutter run
```

Для web:

```bash
flutter run -d chrome
```

Локальный Flutter config сейчас отправляет запросы на:

```text
http://localhost:3000/api/v1
```

## Полный локальный порядок запуска

1. Установить Flutter/Node/Docker.
2. Выполнить `flutter pub get`.
3. Перейти в `backend`.
4. Создать `backend/.env`.
5. Поднять PostgreSQL: `docker compose up -d postgres`.
6. Установить backend dependencies: `npm install`.
7. Сгенерировать Prisma Client: `npm run prisma:generate`.
8. Применить миграции: `npx prisma migrate deploy`.
9. Запустить backend: `npm run dev`.
10. В новом терминале из корня проекта запустить Flutter: `flutter run -d chrome`.

## Docker запуск backend

Из папки `backend`:

```bash
docker compose up --build
```

Важно:

- API container использует Docker-сетевой `DATABASE_URL` на host `postgres`;
- миграции внутри Docker запускаются отдельно, автоматический migrate в `Dockerfile`/compose не найден.

## Проверка регистрации

Пример:

```bash
curl -X POST http://localhost:3000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d "{\"fullName\":\"Codex Check\",\"email\":\"codex@example.com\",\"phone\":\"+77001234567\",\"password\":\"password123\",\"role\":\"CUSTOMER\"}"
```

Ожидается:

- HTTP 201;
- `success: true`;
- `accessToken`;
- `refreshToken`;
- `user`.

## Проверка входа

```bash
curl -X POST http://localhost:3000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"codex@example.com\",\"password\":\"password123\"}"
```

## Проверка защищённого endpoint

```bash
curl http://localhost:3000/api/v1/users/me \
  -H "Authorization: Bearer <accessToken>"
```

## Проверка категорий

```bash
curl http://localhost:3000/api/v1/categories
```

Если ответ пустой, это ожидаемо при базе без seed-данных.

## Проверка заказов

Создание заказа требует существующие:

- `customerId`;
- `categoryId`.

Если категорий нет, сначала нужно добавить категорию вручную через Prisma Studio или другой безопасный способ. API создания категорий не реализован.

## Prisma Studio

Из папки `backend`:

```bash
npm run prisma:studio
```

## Сборка backend

```bash
cd backend
npm run build
```

По текущему заданию команда не запускалась.

## Flutter analyze

```bash
flutter analyze
```

По текущему заданию команда не запускалась.

## Частые проблемы запуска

### Flutter отправляет запросы на production API

Проверить:

- `lib/main.dart`;
- `AppConfig.apiBaseUrl`.

Для локального запуска должно быть:

```text
http://localhost:3000/api/v1
```

### CORS блокирует Flutter Web

Backend в development/test разрешает localhost/127.0.0.1 на любом порту.

Если проблема сохраняется, проверить:

- `NODE_ENV`;
- `CORS_ORIGIN`;
- фактический origin Flutter Web в браузере;
- запущен ли backend на `localhost:3000`.

### Prisma P2022 User.avatar

Применить миграции:

```bash
cd backend
npx prisma migrate deploy
```

### Нет категорий

Seed не реализован. Категории нужно добавить вручную или реализовать отдельный seed/API в будущей задаче.
