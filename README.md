# ELService

ELService — мобильный маркетплейс услуг по ремонту бытовой техники. Клиент создаёт заявку, мастера отправляют предложения, после выбора исполнителя стороны общаются в чате, выполняют заказ и оставляют отзыв.

## Возможности

- регистрация и вход по email и паролю;
- роли клиента, мастера и администратора;
- создание и просмотр заказов;
- предложения мастеров и назначение исполнителя;
- чат по принятому заказу;
- жизненный цикл заказа: принятие, начало работ, завершение и отмена;
- отзывы и рейтинг мастеров;
- профиль пользователя.

## Технологии

| Часть | Стек |
| --- | --- |
| Мобильное приложение | Flutter, Dart, Material 3, GoRouter, Riverpod, Dio |
| Backend | Node.js, Express, TypeScript, Zod, JWT, bcrypt |
| Данные | PostgreSQL, Prisma |
| Инструменты | Docker, Git, Flutter Lints |

## Архитектура

Flutter-приложение построено по Feature First и Clean Architecture. Код каждой функции разделён на слои `data`, `domain` и `presentation`. Сетевые вызовы выполняются через Dio в data-слое, UI не обращается к API напрямую.

Backend использует разделение на routes, controllers, services и repositories. Prisma отвечает за доступ к PostgreSQL, Zod — за валидацию входных данных.

## Структура

```text
ELService/
├── backend/        # Express API и Prisma
├── docs/
│   └── ai/         # Контекст, бизнес-правила и инструкции для AI
├── lib/            # Flutter-приложение
├── test/           # Flutter-тесты
├── android/ ios/ web/ windows/ linux/ macos/
├── README.md
├── LICENSE
├── pubspec.yaml
└── analysis_options.yaml
```

## Роли

- **Customer** — создаёт заказ, выбирает предложение, общается с мастером и оставляет отзыв.
- **Technician** — видит доступные заказы, отправляет предложения, выполняет назначенные заказы.
- **Admin** — использует административные экраны для контроля данных сервиса.

## Запуск Backend

Требуются Node.js 22+, Docker и Docker Compose.

```bash
cd backend
cp .env.example .env
docker compose up -d postgres
npm install
npm run prisma:generate
npx prisma migrate dev
npm run dev
```

Проверка API: `http://localhost:3000/api/v1/health`.

## Запуск Flutter

Требуется Flutter SDK, совместимый с версией из `pubspec.yaml`.

```bash
flutter pub get
flutter run
```

Для Flutter Web локальный API должен быть доступен из браузера. Базовый URL development-окружения настраивается в `lib/main.dart` через `AppConfig`.

## Скриншоты

Скриншоты экранов будут добавлены перед первым публичным релизом.

## Roadmap

- завершить замену оставшихся демонстрационных данных на API;
- добавить тесты критических пользовательских сценариев;
- подготовить сборки для публикации в магазинах приложений.

## Лицензия

Проект распространяется по проприетарной лицензии. См. [LICENSE](LICENSE).

## Документация для AI

Контекст проекта, бизнес-правила и правила работы с репозиторием находятся в [docs/ai](docs/ai).
