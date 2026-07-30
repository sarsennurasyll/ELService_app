# Реализованные функции

## Авторизация

### Backend

Реализованы:

- регистрация;
- вход;
- refresh access token;
- logout;
- хранение password hash;
- JWT access/refresh tokens;
- проверка email;
- проверка phone;
- проверка пароля.

Endpoints:

- `POST /api/v1/auth/register`;
- `POST /api/v1/auth/login`;
- `POST /api/v1/auth/refresh`;
- `POST /api/v1/auth/logout`.

Ограничения:

- blacklist refresh token не реализован;
- logout фактически не инвалидирует refresh token на сервере.

### Flutter

Реализованы:

- `LoginPage`;
- `RegisterPage`;
- `AuthRemoteDataSource`;
- `AuthRepository`;
- DTO и mapper;
- сохранение accessToken;
- сохранение refreshToken;
- сохранение session JSON.

После успешного login/register происходит переход на customer home.

## Регистрация

Поля backend:

- `fullName`;
- `email`;
- `phone`;
- `password`;
- `role`.

Роль по умолчанию на backend: `CUSTOMER`.

Flutter отправляет роль явно через `RegisterRequestDto`.

Ошибки:

- валидация;
- конфликт email;
- конфликт phone.

## Профиль

### Backend

Реализованы:

- получить текущего пользователя по JWT;
- обновить профиль.

Endpoints:

- `GET /api/v1/users/me`;
- `PATCH /api/v1/users/me`.

Разрешено менять:

- `fullName`;
- `phone`;
- `avatar`;
- `city`.

Email менять нельзя.

### Flutter

Реализованы:

- `ProfilePage`;
- загрузка профиля через API;
- отображение loading/error/success;
- диалог редактирования профиля;
- отправка PATCH запроса;
- обновление UI после сохранения.

Ограничения:

- logout в профиле оставлен как TODO;
- статистика профиля отображается локальными значениями.

## Категории

### Backend

Реализованы:

- список категорий;
- получение категории по id.

Endpoints:

- `GET /api/v1/categories`;
- `GET /api/v1/categories/:id`.

Сортировка:

- `name ASC`.

### Flutter

Реализованы:

- `CategoryRemoteDataSource`;
- `CategoryRepository`;
- `CategoryDto`;
- `CategoryMapper`;
- загрузка категорий на `HomePage`;
- загрузка категорий на `CreateOrderPage`;
- состояния loading/error/empty/success.

Ограничения:

- нет API для создания категорий;
- нет seed-данных;
- иконка категории вычисляется на Flutter по `icon` или `name`.

## Заказы

### Backend

Реализованы:

- создание заказа;
- список заказов;
- заказ по id;
- обновление заказа;
- удаление заказа.

Endpoints:

- `POST /api/v1/orders`;
- `GET /api/v1/orders`;
- `GET /api/v1/orders/:id`;
- `PATCH /api/v1/orders/:id`;
- `DELETE /api/v1/orders/:id`.

При создании:

- проверяется категория;
- проверяется пользователь;
- статус становится `PENDING`.

Ограничение:

- endpoints заказов не защищены JWT;
- `customerId` приходит из request body.

### Flutter

Реализованы:

- `OrdersPage`;
- `CreateOrderPage`;
- `OrderDetailsPage`;
- `OrderRemoteDataSource`;
- `OrderRepository`;
- `OrderDto`;
- `OrderMapper`;
- loading/error/empty/success.

Создание заказа:

- берёт user id из сохранённой session;
- отправляет `POST /api/v1/orders`;
- после успеха обновляет `ordersRefreshNotifier`;
- переходит на список заказов.

Ограничения:

- Flutter repository реализует только list/get/create;
- update/delete на Flutter не реализованы;
- фото заказа в UI пока локальная визуальная часть;
- часть данных UI остаётся локальной или вычисляемой.

## Предложения мастеров

### Backend

Реализованы:

- мастер отправляет предложение;
- клиент получает предложения по заказу;
- клиент принимает предложение;
- мастер или admin удаляет предложение.

Endpoints:

- `POST /api/v1/offers`;
- `GET /api/v1/orders/:id/offers`;
- `PATCH /api/v1/offers/:id/accept`;
- `DELETE /api/v1/offers/:id`.

Правила:

- создавать предложение может только `TECHNICIAN`;
- предложения доступны клиенту заказа или admin;
- принять предложение может клиент заказа или admin;
- заказ должен быть `PENDING` для отправки предложения;
- после принятия заказ становится `ACCEPTED`;
- у заказа заполняется `assignedMasterId`;
- остальные предложения становятся `INACTIVE`;
- создаётся `Conversation`.

### Flutter

Реализованы:

- `OffersPage`;
- `SendOfferPage`;
- `OfferRemoteDataSource`;
- `OfferRepository`;
- `OfferDto`;
- `OfferMapper`.

Ограничения:

- delete offer на Flutter не реализован;
- предложения требуют авторизации через сохранённый JWT.

## Чат

### Backend

Реализованы:

- создать или получить чат по заказу;
- получить список чатов пользователя;
- получить сообщения чата;
- отправить сообщение.

Endpoints:

- `POST /api/v1/chats`;
- `GET /api/v1/chats`;
- `GET /api/v1/chats/:id/messages`;
- `POST /api/v1/chats/:id/messages`.

Правила:

- доступ есть только у участников чата;
- чат связан с заказом;
- сообщение содержит `senderId`, `conversationId`, `text`, `createdAt`;
- WebSocket не используется.

### Flutter

Реализованы:

- `ChatRemoteDataSource`;
- `ChatRepository`;
- `ChatDto`;
- `MessageDto`;
- `ChatMapper`;
- `MessageMapper`;
- `ChatMessagesPage` с polling каждые 10 секунд.

Ограничения:

- существующий `ChatPage` пока использует локальные mock-чаты;
- `ChatMessagesPage` не подключён в `AppRouter`;
- polling реализован на уровне страницы сообщений, но экран сообщений пока не достижим маршрутом из основного роутера.

## Splash

Реализован стартовый экран:

- `lib/features/splash/presentation/pages/splash_page.dart`.

Маршрут:

- `/`.

Splash ведёт к login через действие в UI.

## Customer Home

Реализован главный экран клиента:

- приветствие;
- город;
- кнопка уведомлений;
- avatar initials;
- search action;
- категории через API;
- emergency repair banner;
- список топовых мастеров локальными данными.

Ограничения:

- мастера на Home пока mock;
- уведомления не подключены;
- search не подключён.

## Customer Orders

Реализован список заказов:

- загрузка заказов через API;
- разделение active/past;
- карточки заказов;
- статусы;
- пустое состояние;
- ошибка;
- переход в детали заказа.

## Customer Profile

Реализован экран профиля:

- загрузка профиля через API;
- header;
- initials;
- email;
- edit profile;
- статистика локальными значениями;
- меню локальными пунктами.

## Technician Module

Реализованы Flutter UI-страницы:

- dashboard;
- orders;
- calendar;
- earnings;
- profile.

Реализована нижняя навигация мастера.

Backend API мастера как отдельный модуль не реализован.

## Admin Module

Реализованы Flutter UI-страницы:

- dashboard;
- orders;
- users;
- analytics;
- settings.

Реализована нижняя навигация admin.

Backend admin API не реализован.

## Уведомления

В Prisma есть модель `Notification`.

В UI есть элементы уведомлений.

API уведомлений не реализован.

## Отзывы

В Prisma есть модель `Review`.

В UI деталей заказа есть кнопка `Rate technician`.

API отзывов не реализован.

## Оплата

В пользовательском workflow оплата предусмотрена.

В Flutter profile есть пункт `Payment methods`.

Backend API оплаты не реализован.
