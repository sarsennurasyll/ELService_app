# Frontend

## Технологии

Flutter-приложение использует:

- Flutter 3+;
- Dart SDK `^3.11.0`;
- Material 3;
- GoRouter;
- Dio;
- Riverpod;
- flutter_secure_storage;
- logger;
- Freezed annotation;
- Json Serializable annotation.

## Точка входа

Файл: `lib/main.dart`.

`main()` создаёт `AppConfig` для окружения `development`:

- `environment`: `AppEnvironment.development`;
- `appName`: `ELService`;
- `apiBaseUrl`: `http://localhost:3000/api/v1`;
- `enableLogger`: `true`.

После этого `main()` вызывает `bootstrap()` и передаёт `App` через `AppBuilder`.

## Bootstrap

Файл: `lib/app/bootstrap/bootstrap.dart`.

`bootstrap()`:

- принимает `AppConfig`;
- принимает `AppBuilder`;
- создаёт `runZonedGuarded`;
- внутри зоны вызывает `WidgetsFlutterBinding.ensureInitialized()`;
- внутри той же зоны вызывает `runApp()`.

Это исправляет проблему `Zone mismatch`, потому что binding и запуск приложения происходят в одной Zone.

## AppConfig

Файлы:

- `lib/app/bootstrap/app_config.dart`;
- `lib/app/bootstrap/app_environment.dart`.

`AppEnvironment` содержит:

- `development`;
- `staging`;
- `production`.

`AppConfig` хранит:

- окружение;
- название приложения;
- base URL API;
- флаг логирования.

## Корневой App

Файл: `lib/app/app.dart`.

`App` — `StatefulWidget`, который принимает `AppConfig` через конструктор.

Внутри `_AppState` создаются:

- `SecureTokenStorage`;
- `ApiClient`;
- `AuthRepositoryImpl`;
- `CategoryRepositoryImpl`;
- `OrderRepositoryImpl`;
- `UserRepositoryImpl`;
- `OfferRepositoryImpl`;
- `ValueNotifier<int>` для обновления списка заказов;
- `AppRouter`.

`MaterialApp.router` использует `routerConfig` из `AppRouter`.

`AppTheme.light` существует, но в `MaterialApp.router` пока не подключён.

## Роутинг

Файлы:

- `lib/app/router/app_routes.dart`;
- `lib/app/router/app_router.dart`.

Используется GoRouter.

### Основные маршруты

- `/` — `SplashPage`;
- `/login` — `LoginPage`;
- `/register` — `RegisterPage`;
- `/home` — customer home;
- `/orders` — customer orders;
- `/chat` — customer chat list;
- `/profile` — customer profile;
- `/order/new` — создание заказа;
- `/order/details/:id` — детали заказа;
- `/order/:id/offers` — предложения по заказу;
- `/tech/order/:id/offer` — отправка предложения мастером;
- `/tech` — dashboard мастера;
- `/tech/orders` — заказы мастера;
- `/tech/calendar` — календарь мастера;
- `/tech/earnings` — заработок мастера;
- `/tech/profile` — профиль мастера;
- `/admin` — dashboard админа;
- `/admin/orders` — заказы админа;
- `/admin/technicians` — пользователи/мастера;
- `/admin/analytics` — аналитика;
- `/admin/settings` — настройки.

### Shell navigation

Для нижней навигации используется `StatefulShellRoute.indexedStack`.

Это сохраняет состояние вкладок:

- Customer: Home, Orders, Chat, Profile;
- Technician: Dashboard, Orders, Calendar, Earnings, Profile;
- Admin: Dashboard, Orders, Users, Analytics, Settings.

## Riverpod

Зависимость `flutter_riverpod` подключена.

Фактически сейчас есть provider:

- `chatRepositoryProvider` в `lib/features/customer/presentation/providers/chat_providers.dart`.

Provider принимает `ApiClient` через `Provider.family` и создаёт `ChatRepositoryImpl`.

Важно: `ProviderScope` в `App` пока не подключён, поэтому Riverpod не является основной системой DI в текущем состоянии приложения.

## Работа с API

### ApiConfig

Файл: `lib/core/config/api_config.dart`.

Хранит:

- `baseUrl`;
- `connectTimeout`;
- `receiveTimeout`;
- `sendTimeout`.

### ApiClient

Файл: `lib/core/network/api_client.dart`.

`ApiClient` основан на Dio и предоставляет методы:

- `get`;
- `post`;
- `put`;
- `patch`;
- `delete`.

`ApiClient`:

- использует `baseUrl` из `ApiConfig`;
- ставит JSON headers;
- подключает `AuthInterceptor`;
- подключает `LoggingInterceptor`;
- преобразует `DioException` в `NetworkException` или `ApiException`;
- возвращает `Map<String, dynamic>`.

### AuthInterceptor

Файл: `lib/core/network/interceptors/auth_interceptor.dart`.

Перед каждым запросом читает access token из `TokenStorage` и добавляет:

```text
Authorization: Bearer <token>
```

Если токена нет, заголовок не добавляется.

### TokenStorage

Файл: `lib/core/storage/token_storage.dart`.

Есть интерфейс `TokenStorage` и реализации:

- `SecureTokenStorage` на `flutter_secure_storage`;
- `InMemoryTokenStorage` для изолированных тестов.

Хранятся:

- access token;
- refresh token;
- session JSON.

## Result и Failure

Файлы:

- `lib/core/utils/result.dart`;
- `lib/core/errors/failure.dart`.

Используются:

- `Success<T>`;
- `ErrorResult<T>`;
- `Failure`.

UI не должен работать с исключениями напрямую. Repository ловит исключения и возвращает `Result<T>`.

## DTO, Mapper, Repository, DataSource

### Auth

DTO:

- `LoginRequestDto`;
- `RegisterRequestDto`;
- `RefreshTokenDto`;
- `LoginResponseDto`;
- `UserDto`.

Domain:

- `User`;
- `Session`;
- `AuthRepository`.

Data:

- `AuthRemoteDataSourceImpl`;
- `AuthRepositoryImpl`;
- `AuthMapper`;
- `SessionMapper`;
- `UserMapper`.

Поддерживает:

- login;
- register;
- refresh token;
- logout.

После login/register сохраняются токены и session.

### Categories

DTO:

- `CategoryDto`: `id`, `name`, `icon`.

Domain:

- `Category`;
- `CategoryRepository`.

Data:

- `CategoryRemoteDataSourceImpl`;
- `CategoryRepositoryImpl`;
- `CategoryMapper`.

Поддерживает:

- список категорий;
- категорию по id.

### Orders

DTO:

- `OrderDto`: `id`, `customerId`, `categoryId`, `status`, `description`, `technicianId`, `address`, `price`, `preferredDate`.

Domain:

- `Order`;
- `OrderRepository`.

Data:

- `OrderRemoteDataSourceImpl`;
- `OrderRepositoryImpl`;
- `OrderMapper`.

Поддерживает:

- список заказов;
- заказ по id;
- создание заказа.

PATCH/DELETE заказа во Flutter repository пока не реализованы.

### User Profile

DTO:

- `UserDto`: `id`, `fullName`, `email`, `role`, `phone`, `avatar`, `city`.

Domain:

- `User`;
- `UserRepository`.

Data:

- `UserRemoteDataSourceImpl`;
- `UserRepositoryImpl`;
- `UserMapper`.

Поддерживает:

- получить текущего пользователя;
- обновить `fullName`, `phone`, `avatar`, `city`.

### Offers

DTO:

- `OfferDto`: `id`, `orderId`, `masterId`, `price`, `arrivalTime`, `status`, `comment`, `masterName`.

Domain:

- `Offer`;
- `OfferRepository`.

Data:

- `OfferRemoteDataSourceImpl`;
- `OfferRepositoryImpl`;
- `OfferMapper`.

Поддерживает:

- получить предложения по заказу;
- создать предложение;
- принять предложение.

Удаление предложения во Flutter repository пока не реализовано, хотя backend endpoint есть.

### Chat

DTO:

- `ChatDto`: `id`, `orderId`, `userAId`, `userBId`, `lastMessage`;
- `MessageDto`: `id`, `chatId`, `senderId`, `text`, `createdAt`.

Domain:

- `Chat`;
- `Message`;
- `ChatRepository`.

Data:

- `ChatRemoteDataSourceImpl`;
- `ChatRepositoryImpl`;
- `ChatMapper`;
- `MessageMapper`.

Поддерживает:

- получить список чатов;
- получить сообщения;
- отправить сообщение.

Фактическое ограничение: существующий `ChatPage` пока использует локальные mock-данные. `ChatMessagesPage` существует с polling каждые 10 секунд, но маршрут к нему в `AppRouter` не добавлен.

## Экраны

### Auth

- `LoginPage`;
- `RegisterPage`.

Login и Register работают с `AuthRepository`.

После успешного входа/регистрации выполняется переход на customer home.

### Splash

- `SplashPage`.

Стартовый экран. Подключён как `/`.

### Customer

- `HomePage`;
- `OrdersPage`;
- `CreateOrderPage`;
- `OrderDetailsPage`;
- `ChatPage`;
- `ChatMessagesPage`;
- `ProfilePage`.

### Proposals

- `OffersPage`;
- `SendOfferPage`.

### Technician

- `DashboardPage`;
- `OrdersPage`;
- `CalendarPage`;
- `EarningsPage`;
- `ProfilePage`.

Страницы есть как UI-заготовки.

### Admin

- `DashboardPage`;
- `OrdersPage`;
- `UsersPage`;
- `AnalyticsPage`;
- `SettingsPage`.

Страницы есть как UI-заготовки.

## Дизайн-система Flutter

Файлы:

- `app_colors.dart`;
- `app_spacing.dart`;
- `app_radius.dart`;
- `app_duration.dart`;
- `app_shadows.dart`;
- `app_text_styles.dart`;
- `app_theme.dart`.

### Цвета

Основные цвета:

- `primary`: `#2563EB`;
- `secondary`: `#0EA5E9`;
- `background`: `#F8FAFC`;
- `surface`: `#FFFFFF`;
- `foreground`: `#0F172A`;
- `muted`: `#F1F5F9`;
- `mutedForeground`: `#64748B`;
- `success`: `#22C55E`;
- `warning`: `#F59E0B`;
- `error`: `#EF4444`;
- `info`: `secondary`;
- `border`: `#E2E8F0`;
- `divider`: `border`;
- `scrim`: `#CC000000`.

Есть оттенки primary с alpha: 5, 10, 20, 30, 40, 80, 90.

### Типографика

Используется семейство `Inter`, но шрифт пока не подключён через assets/fonts.

Стили:

- `displayLarge`;
- `displayMedium`;
- `headlineLarge`;
- `headlineMedium`;
- `titleLarge`;
- `titleMedium`;
- `bodyLarge`;
- `bodyMedium`;
- `bodySmall`;
- `labelLarge`;
- `labelMedium`;
- `labelSmall`.

### UI Kit

Общие компоненты:

- `PrimaryButton`;
- `AppTextField`;
- `AppCard`;
- `AppTopBar`;
- `Screen`;
- `CustomerBottomNavigation`;
- `TechnicianBottomNavigation`;
- `AdminBottomNavigation`.

## Состояние UI

В текущих экранах часто используется `FutureBuilder<Result<T>>`.

Примеры состояний:

- `CircularProgressIndicator` для loading;
- текст ошибки для error;
- отдельный блок empty;
- список/контент для success.

## Ограничения frontend

- `AppTheme.light` не подключён к `MaterialApp.router`.
- `ProviderScope` не подключён.
- Chat UI не полностью подключён к backend.
- Нет глобальной авторизационной маршрутизации и redirects.
- Нет refresh interceptor.
- Нет экранов оплаты и отзывов.
- Локализация не подключена.
