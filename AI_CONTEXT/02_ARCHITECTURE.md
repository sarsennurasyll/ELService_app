# Архитектура

## Общий подход

Проект использует Feature First и Clean Architecture.

Основная идея:

- код группируется по функциональным модулям;
- внутри feature код разделяется по слоям;
- внешние слои зависят от внутренних;
- UI не работает с API напрямую;
- domain не знает о Flutter, Dio, JSON и хранении данных.

## Верхнеуровневая структура

```text
lib/
  app/
  core/
  shared/
  features/
  l10n/
  main.dart

backend/
  prisma/
  src/
  docker-compose.yml
  Dockerfile
  package.json
```

## Flutter: Feature First

Функциональность размещается в `lib/features/<feature_name>`.

Реальные feature в проекте:

- `auth`;
- `customer`;
- `proposals`;
- `splash`;
- `technician`;
- `admin`.

В структуре проекта также были предусмотрены папки `home`, `orders`, `masters`, `reviews`, `profile`, `settings`, но фактическая активная реализация сейчас сосредоточена в перечисленных выше feature.

## Flutter: Clean Architecture

### data

Слой `data` содержит:

- DTO;
- mapper;
- remote data source;
- repository implementation.

Примеры:

- `AuthRemoteDataSourceImpl`;
- `CategoryRemoteDataSourceImpl`;
- `OrderRemoteDataSourceImpl`;
- `UserRemoteDataSourceImpl`;
- `OfferRemoteDataSourceImpl`;
- `ChatRemoteDataSourceImpl`;
- `AuthRepositoryImpl`;
- `CategoryRepositoryImpl`;
- `OrderRepositoryImpl`;
- `UserRepositoryImpl`;
- `OfferRepositoryImpl`;
- `ChatRepositoryImpl`.

`data` знает о `ApiClient`, DTO и формате backend-ответов.

### domain

Слой `domain` содержит:

- доменные модели;
- контракты репозиториев.

Примеры:

- `Session`;
- `User`;
- `Category`;
- `Order`;
- `Offer`;
- `Chat`;
- `Message`;
- `AuthRepository`;
- `OrderRepository`;
- `ChatRepository`.

Domain не должен зависеть от Flutter, Dio или JSON. В текущем проекте domain-модели написаны обычными Dart-классами.

### presentation

Слой `presentation` содержит:

- страницы;
- локальные виджеты страниц;
- provider, если он относится к feature;
- состояние UI.

Примеры:

- `LoginPage`;
- `RegisterPage`;
- `HomePage`;
- `OrdersPage`;
- `CreateOrderPage`;
- `OrderDetailsPage`;
- `ProfilePage`;
- `OffersPage`;
- `SendOfferPage`;
- `ChatPage`;
- `ChatMessagesPage`;
- `chatRepositoryProvider`.

## Направление зависимостей во Flutter

```text
presentation
  -> domain repositories
  -> data repository implementations
  -> remote data sources
  -> ApiClient
  -> Dio
  -> Backend API
```

UI получает `Result<T>` и показывает состояния:

- Loading;
- Error;
- Empty;
- Success.

## app

`lib/app` содержит инфраструктуру приложения:

- `app.dart` — корневой виджет `App`;
- `bootstrap` — конфигурация запуска;
- `router` — маршруты и `GoRouter`;
- `theme` — дизайн-токены и `AppTheme`.

`App` вручную собирает зависимости:

- `SecureTokenStorage`;
- `ApiClient`;
- `AuthRepositoryImpl`;
- `CategoryRepositoryImpl`;
- `OrderRepositoryImpl`;
- `UserRepositoryImpl`;
- `OfferRepositoryImpl`;
- `AppRouter`.

Riverpod глобально в `App` пока не подключён через `ProviderScope`.

## core

`lib/core` содержит общую техническую инфраструктуру:

- `config` — конфигурация API;
- `constants` — сетевые константы;
- `errors` — ошибки и failure;
- `network` — `ApiClient` и interceptors;
- `storage` — token/local storage;
- `utils` — `Result`, logger;
- `extensions` — расширения.

## shared

`lib/shared` содержит переиспользуемые UI-компоненты:

- `PrimaryButton`;
- `AppTextField`;
- `AppCard`;
- `AppTopBar`;
- `Screen`;
- bottom navigation для customer, technician, admin.

## Backend Architecture

Backend использует классическую Express-структуру:

```text
request
  -> route
  -> middleware
  -> controller
  -> service
  -> repository
  -> Prisma
  -> PostgreSQL
```

### routes

Routes определяют URL и middleware:

- validation через Zod;
- auth middleware для защищённых endpoints.

### controllers

Controllers принимают `Request`, вызывают service и возвращают ответ через `sendSuccess`.

### services

Services содержат бизнес-правила:

- проверка существования пользователя;
- проверка существования категории;
- проверка роли мастера;
- проверка владельца заказа;
- принятие предложения;
- создание чата.

### repositories

Repositories работают с Prisma.

### middleware

Используются:

- `authMiddleware`;
- `validate`;
- `notFoundHandler`;
- `errorHandler`.

### utils

Используются:

- `sendSuccess`;
- `sendError`;
- `AppError`;
- JWT helpers;
- password hashing helpers;
- `asyncHandler`.

## Взаимодействие компонентов

### Регистрация

```text
Flutter Login/Register UI
  -> AuthRepository
  -> AuthRemoteDataSource
  -> ApiClient
  -> POST /api/v1/auth/register
  -> authController
  -> AuthService
  -> UserRepository
  -> Prisma User
```

После успеха Flutter сохраняет:

- `accessToken`;
- `refreshToken`;
- session JSON.

### Заказы

```text
CreateOrderPage
  -> OrderRepository
  -> OrderRemoteDataSource
  -> POST /api/v1/orders
  -> OrderService
  -> CategoryRepository + UserRepository
  -> OrderRepository
  -> Prisma Order
```

### Предложения

```text
SendOfferPage
  -> OfferRepository
  -> OfferRemoteDataSource
  -> POST /api/v1/offers
  -> authMiddleware
  -> OfferService
  -> OfferRepository
  -> Prisma Offer
```

Принятие предложения меняет заказ и предложения в транзакции Prisma.

### Чат

Backend создаёт `Conversation` после принятия предложения.

Flutter data/domain слой для чата умеет:

- получить список чатов;
- получить сообщения;
- отправить сообщение.

Полное подключение этого слоя к существующему `ChatPage` не завершено: `ChatPage` ещё содержит локальные mock-данные, а `ChatMessagesPage` не подключён в `AppRouter`.
