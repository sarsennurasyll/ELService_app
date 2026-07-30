# Известные проблемы и ограничения

## Уже исправлено

### Zone mismatch во Flutter

Проблема:

- `WidgetsFlutterBinding.ensureInitialized()` вызывался вне `runZonedGuarded`;
- `runApp()` запускался внутри другой Zone.

Исправление:

- binding и `runApp()` находятся внутри одной `runZonedGuarded` зоны в `bootstrap()`.

### Flutter использовал production baseUrl

Проблема:

- локальный Flutter отправлял запросы на `https://api.elservice.dev`;
- backend работал локально на `localhost:3000`.

Исправление:

- `lib/main.dart` использует `http://localhost:3000/api/v1` для development.

### CORS для Flutter Web

Проблема:

- Flutter Web запускался на случайном `localhost` порту;
- backend разрешал только `http://localhost:5173`;
- браузер блокировал запросы.

Исправление:

- backend разрешает `localhost` и `127.0.0.1` на любом порту в development/test;
- production остаётся ограниченным через `CORS_ORIGIN`.

### Prisma P2022 User.avatar

Проблема:

- Prisma schema и код ожидали колонку `User.avatar`;
- локальная база не имела эту колонку;
- миграция `20260721130000_add_user_profile_fields` существовала, но не была применена.

Исправление:

- применены все существующие миграции через `npx prisma migrate deploy`;
- регистрация перестала возвращать HTTP 500.

## Текущие ограничения Flutter

### AppTheme не подключён

`AppTheme.light` существует, но `MaterialApp.router` в `App` не передаёт `theme`.

### Riverpod не подключён глобально

`flutter_riverpod` установлен, provider для чата есть, но `ProviderScope` в корневом приложении не используется.

### Auth redirects не реализованы

GoRouter не проверяет:

- есть ли access token;
- истекла ли сессия;
- какая роль у пользователя;
- куда отправлять пользователя после login.

### Роли не управляют UI

Роли `CUSTOMER`, `TECHNICIAN`, `ADMIN` есть в backend и session, но Flutter не переключает стартовый интерфейс по роли.

### Chat UI не полностью подключён

Факты:

- backend Chat API реализован;
- Flutter data/domain слой чата реализован;
- `ChatMessagesPage` существует;
- `ChatMessagesPage` использует polling каждые 10 секунд.

Ограничения:

- `ChatPage` всё ещё содержит mock-чаты;
- `ChatMessagesPage` не подключён в `AppRouter`;
- переход из списка чатов в сообщения не реализован.

### API endpoints в ApiEndpoints неполные

`ApiEndpoints` содержит не все реальные backend endpoints.

Некоторые data sources используют строки напрямую:

- `/offers`;
- `/orders/$orderId/offers`;
- `/chats`;
- `/chats/$chatId/messages`.

### Freezed/Json Serializable подключены, но почти не используются

Зависимости есть, но DTO написаны вручную.

Сгенерированные файлы для DTO не используются.

### Локализация не подключена

Папка `lib/l10n` существует, но локализация не настроена.

### Нет tests для бизнес-сценариев

Стандартный шаблонный widget test был ранее приведён к минимальному состоянию или удалён. Полноценных тестов API/Flutter-сценариев в документации не найдено.

## Текущие ограничения backend

### Нет seed-данных

Категории нужны для создания заказа, но seed-скрипта не найдено.

Если база пустая, `GET /api/v1/categories` вернёт пустой список.

### Orders endpoints не защищены JWT

Endpoints заказов сейчас не используют `authMiddleware`.

Последствие:

- `customerId` передаётся из body;
- backend не проверяет, что пользователь создаёт заказ от своего имени.

### Нет API для reviews

Prisma model `Review` есть.

Backend routes/controllers/services для отзывов не найдены.

### Нет API для notifications

Prisma model `Notification` есть.

Backend routes/controllers/services для уведомлений не найдены.

### Нет API оплаты

Payment workflow не реализован.

### Нет admin API

Flutter admin pages существуют, но backend endpoints для admin dashboard, users, reports, payments, disputes не реализованы.

### Нет technician API как отдельного модуля

Flutter technician pages существуют, но backend module для technician dashboard/orders/calendar/wallet не реализован.

### Logout не инвалидирует refresh token

В `AuthService.logout` есть TODO по blacklist.

### Conversation.updatedAt не обновляется при отправке сообщения

`ChatRepository.send` создаёт `Message`, но не обновляет `Conversation.updatedAt`.

При сортировке чатов по `updatedAt DESC` это может мешать поднимать активный чат наверх.

### phone не уникален на уровне базы

AuthService проверяет `phone` через `findFirst`, но Prisma schema не содержит unique index для `User.phone`.

## Ограничения документации проекта

### README устарел

Корневой `README.md` говорит, что создана только структура каталогов. Фактически проект уже содержит Flutter UI, data/domain слой и backend API.

Backend README тоже содержит фразу, что бизнес-логика пока не реализована, хотя часть бизнес-логики уже есть.

По текущему заданию README не изменялся.

### Есть много несвязанных незакоммиченных изменений

На момент создания этой документации `git status` содержит изменения и untracked-файлы вне `AI_CONTEXT`.

По правилам проекта их нельзя включать в коммит документации.

## Что стоит сделать позже

- Подключить `AppTheme.light` в `MaterialApp.router`.
- Подключить `ProviderScope`, если Riverpod станет основной DI/state системой.
- Подключить Chat UI к `ChatRepository`.
- Добавить route для `ChatMessagesPage`.
- Защитить Orders endpoints JWT.
- Реализовать seed категорий.
- Реализовать Reviews API.
- Реализовать Notifications API.
- Реализовать Payments API.
- Реализовать роль-based redirects.
- Обновить README.
- Добавить тесты backend services и Flutter repositories.
