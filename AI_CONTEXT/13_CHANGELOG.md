# Changelog

Этот файл описывает фактически реализованные этапы проекта по состоянию текущего рабочего дерева.

## Создана структура Flutter-проекта

Добавлена базовая структура:

- `lib/app`;
- `lib/core`;
- `lib/shared`;
- `lib/features`;
- `lib/l10n`;
- `lib/main.dart`.

Архитектурный подход:

- Feature First;
- Clean Architecture.

## Добавлен AGENTS.md

Создан главный документ правил проекта:

- общие правила разработки;
- архитектура;
- организация папок;
- именование;
- комментарии;
- README;
- Riverpod;
- Dio;
- Freezed/Json Serializable;
- UI;
- SOLID/DRY/KISS/Clean Code;
- создание feature;
- Git;
- Conventional Commits.

## Настроен pubspec.yaml

Подключены зависимости MVP:

- Riverpod;
- GoRouter;
- Dio;
- Freezed annotation;
- Json annotation;
- intl;
- flutter_secure_storage;
- logger.

Dev dependencies:

- build_runner;
- freezed;
- json_serializable;
- flutter_lints.

## Настроен статический анализ

Создан `analysis_options.yaml` на базе `flutter_lints`.

## Создана конфигурация приложения

Добавлены:

- `AppEnvironment`;
- `AppConfig`.

Окружения:

- development;
- staging;
- production.

## Создан корневой App

Добавлен `App`, принимающий `AppConfig`.

Используется:

- `MaterialApp.router`;
- `AppRouter`.

## Создан bootstrap

Добавлена функция `bootstrap()`.

Запуск происходит через:

- `runZonedGuarded`;
- `WidgetsFlutterBinding.ensureInitialized`;
- `runApp`.

## Создана маршрутизация

Добавлены:

- `AppRoutes`;
- `AppRouter`.

Используется:

- GoRouter;
- `StatefulShellRoute.indexedStack`.

Подключены роли:

- Customer;
- Technician;
- Admin.

## Исправлены зависимости под Flutter/Dart

Версии зависимостей были приведены к совместимому состоянию для локального Flutter/Dart SDK.

## Сделан первый запуск приложения

`main.dart` создаёт development config и запускает `App` через `bootstrap`.

## Исправлен Zone mismatch

`WidgetsFlutterBinding.ensureInitialized()` перенесён внутрь `runZonedGuarded`.

## Приведён проект к зелёному состоянию анализа

Шаблонный widget test был исправлен или минимизирован.

Исправлено замечание `unnecessary_underscores`.

## Создана основа дизайн-системы

Добавлены токены:

- цвета;
- spacing;
- radius;
- duration;
- shadows.

## Проведён аудит React/Vite дизайна

Проект `ELService-design` используется как источник истины для UI.

Из него перенесены:

- цвета;
- типографика;
- spacing;
- radius;
- shadows;
- компоненты и навигационные паттерны.

## Обновлены дизайн-токены Flutter

Нейтральные временные значения заменены на токены из дизайн-аудита.

## Добавлена типографика

Создан `AppTextStyles` под Inter.

Шрифт Inter указан в TextStyle, но не подключён как asset.

## Добавлена тема приложения

Создан `AppTheme.light` с:

- Material 3;
- ColorScheme;
- AppBarTheme;
- CardTheme;
- ElevatedButtonTheme;
- OutlinedButtonTheme;
- InputDecorationTheme;
- DividerTheme;
- TextTheme.

Ограничение:

- тема пока не передана в `MaterialApp.router`.

## Создан базовый UI Kit

Добавлены:

- `PrimaryButton`;
- `AppTextField`;
- `AppCard`;
- `AppTopBar`;
- `Screen`;
- bottom navigation для Customer, Technician, Admin.

## Создан Splash

Добавлен `SplashPage`.

Подключён стартовый маршрут `/`.

## Создан Login

Добавлен `LoginPage`.

Позже подключён к backend через `AuthRepository`.

## Создан Register

Добавлен `RegisterPage`.

Позже подключён к backend через `AuthRepository`.

## Создан Customer Home

Добавлен `HomePage`.

Категории позже подключены к backend.

## Создан Customer Module

Добавлены customer страницы:

- Orders;
- Chat;
- Profile.

Навигация Customer работает через bottom navigation.

## Оптимизирована навигация Customer

Используется `StatefulShellRoute.indexedStack`, чтобы вкладки не пересоздавались без необходимости при переключении.

## Подключена авторизация к backend

Flutter использует:

- `AuthRemoteDataSource`;
- `AuthRepository`;
- DTO;
- mapper;
- `TokenStorage`;
- `ApiClient`.

После login/register сохраняются токены и session.

## Подключены категории к backend

Flutter получает категории через:

- `GET /api/v1/categories`;
- `GET /api/v1/categories/:id`.

Локальные mock-категории убраны из Home.

## Реализован Orders API

Backend endpoints:

- `POST /api/v1/orders`;
- `GET /api/v1/orders`;
- `GET /api/v1/orders/:id`;
- `PATCH /api/v1/orders/:id`;
- `DELETE /api/v1/orders/:id`.

## Подключён Flutter Orders к backend

Flutter умеет:

- получить список заказов;
- получить детали заказа;
- создать заказ.

## Реализован профиль пользователя

Backend:

- `GET /api/v1/users/me`;
- `PATCH /api/v1/users/me`.

Flutter:

- загрузка профиля;
- редактирование профиля.

## Реализованы предложения мастеров

Backend:

- создание предложения;
- список предложений заказа;
- принятие предложения;
- удаление предложения.

Flutter:

- список предложений;
- отправка предложения;
- принятие предложения.

## Реализован backend Chat API

Endpoints:

- `POST /api/v1/chats`;
- `GET /api/v1/chats`;
- `GET /api/v1/chats/:id/messages`;
- `POST /api/v1/chats/:id/messages`.

Чат создаётся после принятия предложения.

## Добавлен Flutter data/domain слой чата

Добавлены:

- `ChatDto`;
- `MessageDto`;
- `ChatMapper`;
- `MessageMapper`;
- `ChatRemoteDataSource`;
- `ChatRepositoryImpl`;
- `ChatRepository`;
- `Chat`;
- `Message`.

## Добавлен экран сообщений чата

Создан `ChatMessagesPage`.

Реализовано:

- загрузка сообщений;
- отправка сообщения;
- polling каждые 10 секунд.

Ограничение:

- экран не подключён к роутеру.

## Исправлен локальный Flutter baseUrl

`lib/main.dart` использует:

```text
http://localhost:3000/api/v1
```

## Исправлен CORS для локальной разработки

Backend разрешает Flutter Web на случайных localhost-портах в development/test.

## Применены Prisma миграции

Локальная база была приведена к актуальному состоянию.

Исправлена runtime-проблема:

```text
Prisma P2022: The column User.avatar does not exist
```

## Добавлена документация для AI

Создана папка `AI_CONTEXT` с полным описанием проекта для AI-ассистентов.
