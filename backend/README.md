# ELService Backend

Backend API для маркетплейса ремонта бытовой техники.

## Стек

- Node.js 22+
- Express.js
- TypeScript
- PostgreSQL
- Prisma ORM
- JWT / bcrypt
- Zod

## Структура

```text
backend/
  prisma/
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
  docker-compose.yml
  Dockerfile
```

## Быстрый старт

1. Скопировать переменные окружения:

```bash
cp .env.example .env
```

2. Поднять PostgreSQL:

```bash
docker compose up -d postgres
```

3. Установить зависимости:

```bash
npm install
```

4. Сгенерировать Prisma Client и применить миграции:

```bash
npm run prisma:generate
npx prisma migrate dev --name init
```

5. Запустить API в режиме разработки:

```bash
npm run dev
```

Health-check: `GET http://localhost:3000/api/v1/health`

## Скрипты

- `npm run dev` — разработка (nodemon + ts-node)
- `npm run build` — сборка TypeScript
- `npm start` — запуск собранного сервера
- `npm run prisma:generate` — генерация Prisma Client
- `npm run prisma:migrate` — миграции
- `npm run prisma:studio` — Prisma Studio

## Docker

Полный стек:

```bash
cp .env.example .env
docker compose up --build
```

## Примечание

Бизнес-логика пока не реализована. Подготовлены каркас Express, Prisma-модели, JWT/utils и заготовки controllers / services / repositories.
