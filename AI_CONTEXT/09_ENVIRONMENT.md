# Окружение и технологии

## Flutter

Проект использует Flutter 3+.

В `pubspec.yaml` указано:

```yaml
environment:
  sdk: ^3.11.0
  flutter: '>=3.38.0'
```

В ходе разработки упоминалась локальная версия:

- Flutter `3.41.7`;
- Dart `3.11.5`.

## Dart зависимости

Основные зависимости:

- `dio: ^5.10.0`;
- `flutter_riverpod: ^3.3.2`;
- `flutter_secure_storage: ^10.3.1`;
- `freezed_annotation: ^3.1.0`;
- `go_router: ^17.3.0`;
- `intl: ^0.20.3`;
- `json_annotation: 4.9.0`;
- `logger: ^2.7.0`.

Dev dependencies:

- `build_runner: 2.7.1`;
- `flutter_lints: ^6.0.0`;
- `freezed: 3.2.3`;
- `json_serializable: 6.11.2`.

## Flutter platforms

В проекте присутствуют стандартные платформенные папки:

- `android`;
- `ios`;
- `web`;
- `windows`;
- `linux`;
- `macos`.

Они появились после `flutter create .`.

## Backend runtime

Backend использует:

- Node.js `>=22`;
- TypeScript;
- Express;
- Prisma;
- PostgreSQL.

## Backend dependencies

Runtime dependencies:

- `@prisma/client`;
- `bcrypt`;
- `cors`;
- `dotenv`;
- `express`;
- `helmet`;
- `jsonwebtoken`;
- `morgan`;
- `zod`.

Dev dependencies:

- `@types/bcrypt`;
- `@types/cors`;
- `@types/express`;
- `@types/jsonwebtoken`;
- `@types/morgan`;
- `@types/node`;
- `nodemon`;
- `prisma`;
- `ts-node`;
- `typescript`.

## PostgreSQL

Docker Compose использует:

- image `postgres:16-alpine`;
- database `elservice`;
- user `elservice`;
- password `elservice`;
- внешний порт `5433`;
- внутренний порт `5432`.

Локальный `DATABASE_URL` должен указывать на PostgreSQL.

Пример для локального запуска вне Docker-сети:

```text
postgresql://elservice:elservice@localhost:5433/elservice?schema=public
```

Пример внутри Docker Compose для API:

```text
postgresql://elservice:elservice@postgres:5432/elservice?schema=public
```

## Docker

Файлы:

- `backend/docker-compose.yml`;
- `backend/Dockerfile`.

Docker Compose поднимает:

- PostgreSQL;
- API container.

## JWT

Используются две переменные:

- `JWT_ACCESS_SECRET`;
- `JWT_REFRESH_SECRET`.

Время жизни:

- `JWT_ACCESS_EXPIRES_IN`, default `15m`;
- `JWT_REFRESH_EXPIRES_IN`, default `30d`.

JWT используется:

- для auth middleware;
- для доступа к users/me;
- для offers;
- для chats.

## CORS

Переменная:

- `CORS_ORIGIN`.

В production разрешается только заданный origin.

В development/test дополнительно разрешён локальный Flutter Web origin на любом localhost/127.0.0.1 порту.

## Git

Правила коммитов:

- Conventional Commits;
- русский язык;
- прошедшее время;
- один коммит — одна логическая задача;
- не включать несвязанные изменения.

Пример:

```text
docs: добавил полную документацию проекта для AI
```

## React/Vite дизайн-референс

Папка:

```text
ELService-design
```

Назначение:

- источник истины для UI;
- используется для анализа экранов, компонентов, цветов, типографики, навигации.

Технологии React-проекта по файлам:

- Vite;
- React;
- TypeScript;
- Tailwind;
- shadcn/ui-подобные компоненты;
- TanStack Router.

## Статический анализ

Файл:

```text
analysis_options.yaml
```

Используется `flutter_lints`.

По текущему заданию `flutter analyze` не запускался.

## Сборка backend

Команда:

```bash
npm run build
```

По текущему заданию `npm run build` не запускался.

## Переменные окружения backend

Backend ожидает:

```text
NODE_ENV
PORT
DATABASE_URL
JWT_ACCESS_SECRET
JWT_REFRESH_SECRET
JWT_ACCESS_EXPIRES_IN
JWT_REFRESH_EXPIRES_IN
CORS_ORIGIN
```

`.env.example` в списке файлов не найден, хотя `backend/README.md` его упоминает.
