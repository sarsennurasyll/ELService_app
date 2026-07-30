# 06 — Database Requirements

**No database is provisioned today.** Lovable Cloud / Supabase is not enabled. The schema below is the target model required to support the screens in `src/routes/`.

Use PostgreSQL (via Lovable Cloud). All tables in schema `public`, RLS enabled, with `GRANT`s per project rules.

---

## Enums

```sql
create type user_role as enum ('customer','technician','admin');
create type user_status as enum ('unverified','active','suspended','deleted');
create type tech_verification as enum ('pending','under_review','approved','rejected');

create type order_status as enum (
  'draft','searching','offer_received','accepted','en_route',
  'arrived','in_progress','completed','paid','reviewed',
  'cancelled','expired','disputed','refunded'
);
create type offer_status as enum ('requested','submitted','accepted','declined','expired','withdrawn','ignored');
create type payment_status as enum ('pending','authorising','requires_action','succeeded','failed','refunded');
create type payment_method_kind as enum ('card','apple_pay','google_pay','cash');
create type notification_channel as enum ('push','email','sms','in_app');
create type dispute_status as enum ('open','in_review','resolved_refund','resolved_upheld','escalated');
```

---

## Tables

### `users` — extends `auth.users` (Supabase). One row per account.
- `id uuid pk references auth.users(id)`
- `role user_role not null default 'customer'`
- `status user_status not null default 'unverified'`
- `full_name text not null`
- `phone text not null unique`
- `email text unique`
- `city text`
- `avatar_url text`
- `locale text default 'en'`
- `created_at timestamptz default now()`

> **Roles live in a separate table** per project convention. Use `user_roles(user_id, role)` with `has_role()` security-definer function. The `role` column above is denormalised for convenience only; the source of truth is `user_roles`.

### `user_roles`
- `id uuid pk`, `user_id uuid fk users(id) on delete cascade`, `role app_role`, unique (user_id, role).

### `addresses`
- `id uuid pk`
- `user_id uuid fk users(id) on delete cascade`
- `label text` (Home / Work)
- `street text not null`
- `apt text`
- `city text not null`
- `lat double precision`, `lng double precision`
- `is_default boolean default false`

### `payment_methods`
- `id uuid pk`, `user_id uuid fk`, `kind payment_method_kind`, `gateway_token text`, `brand text`, `last4 text`, `exp_month int`, `exp_year int`, `is_default boolean`.

### `categories` (appliance types)
- `id uuid pk`, `slug text unique`, `name text`, `icon text`, `sort int`, `active boolean default true`.

### `technician_profiles` — one row per technician user.
- `user_id uuid pk fk users(id)`
- `verification tech_verification default 'pending'`
- `bio text`
- `specialties uuid[]` (fk to categories)
- `service_radius_km numeric`
- `base_city text`
- `rating_avg numeric default 0`
- `rating_count int default 0`
- `jobs_completed int default 0`
- `wallet_balance numeric default 0`
- `is_online boolean default false`

### `technician_availability`
- `user_id uuid fk`
- `weekday smallint (0-6)`
- `start_time time`
- `end_time time`
- pk (user_id, weekday)

### `orders`
- `id uuid pk`
- `customer_id uuid fk users(id)`
- `technician_id uuid fk users(id) null` (set on accept)
- `category_id uuid fk categories(id)`
- `appliance_brand text`, `appliance_model text`
- `description text not null`
- `address_id uuid fk addresses(id)`
- `scheduled_date date`, `scheduled_slot text`
- `status order_status not null default 'draft'`
- `estimate_min numeric`, `estimate_max numeric`
- `final_price numeric` (from accepted offer)
- `created_at timestamptz default now()`
- `updated_at timestamptz default now()`
- indices: `(customer_id, status)`, `(technician_id, status)`.

### `order_photos`
- `id uuid pk`, `order_id uuid fk on delete cascade`, `url text`, `sort int`. Constraint: max 6 per order.

### `order_events` — immutable state-transition log.
- `id uuid pk`, `order_id uuid fk`, `from_status order_status`, `to_status order_status`, `actor_id uuid`, `at timestamptz default now()`, `meta jsonb`.

### `offers`
- `id uuid pk`
- `order_id uuid fk`
- `technician_id uuid fk users(id)`
- `price numeric not null check (price > 0)`
- `eta_minutes int not null check (eta_minutes > 0)`
- `note text`
- `status offer_status not null default 'submitted'`
- `created_at`, `expires_at`
- unique (order_id, technician_id)

### `payments`
- `id uuid pk`, `order_id uuid fk unique` (one primary payment per order; refunds are child rows)
- `method_id uuid fk payment_methods(id)`
- `amount numeric not null`, `fee numeric`, `tip numeric default 0`
- `status payment_status`, `gateway_ref text`, `created_at`.

### `refunds`
- `id uuid pk`, `payment_id uuid fk`, `amount numeric`, `reason text`, `issued_by uuid fk users(id)`, `created_at`.

### `reviews`
- `id uuid pk`
- `order_id uuid fk unique` (one review per order)
- `customer_id uuid fk`, `technician_id uuid fk`
- `rating smallint not null check (rating between 1 and 5)`
- `tags text[]`
- `comment text`
- `created_at`.

### `favorites`
- `customer_id uuid fk`, `technician_id uuid fk`, pk (customer_id, technician_id).

### `chats`
- `id uuid pk`, `order_id uuid fk unique`, `customer_id uuid fk`, `technician_id uuid fk`, `last_message_at`.

### `messages`
- `id uuid pk`, `chat_id uuid fk`, `sender_id uuid fk`, `text text`, `attachment_url text`, `read_at`, `created_at`.

### `notifications`
- `id uuid pk`, `user_id uuid fk`, `channel notification_channel`, `title text`, `body text`, `data jsonb`, `read_at`, `created_at`.

### `devices` — push tokens.
- `id uuid pk`, `user_id uuid fk`, `token text unique`, `platform text` ('ios'|'android'|'web'), `created_at`.

### `disputes`
- `id uuid pk`, `order_id uuid fk`, `opened_by uuid fk`, `reason text`, `description text`, `status dispute_status default 'open'`, `resolved_by uuid fk`, `resolution_note text`, `created_at`, `resolved_at`.

### `withdrawals`
- `id uuid pk`, `technician_id uuid fk`, `amount numeric`, `card_id uuid fk payment_methods(id)`, `status text` ('pending','paid','failed'), `created_at`, `paid_at`.

### `broadcasts` (admin messaging)
- `id uuid pk`, `audience text`, `message text`, `scheduled_at`, `sent_at`, `created_by uuid fk`.

### `platform_settings`
- Singleton table with fee %, min payout, request TTL, dispute window, etc.

---

## Key relationships

- `users 1—* addresses`, `users 1—* payment_methods`, `users 1—1 technician_profiles` (when role = technician).
- `orders *—1 customer (users)`, `orders *—1 technician (users)`, `orders *—1 categories`, `orders *—1 addresses`.
- `orders 1—* offers`, `orders 1—* order_photos`, `orders 1—* order_events`, `orders 1—1 payments`, `orders 1—1 reviews`, `orders 1—1 chats`, `orders 1—* disputes`.
- `payments 1—* refunds`.
- `chats 1—* messages`.

---

## RLS policies (summary)

- `orders`: customer can `SELECT` where `customer_id = auth.uid()`; technician can `SELECT` where `technician_id = auth.uid()` OR order is in `searching` AND matches their category+radius (via view / security-definer function). Admin: all.
- `offers`: technician can INSERT/UPDATE their own; customer can SELECT offers on their orders; admin: all.
- `reviews`: customer can INSERT for own completed orders; everyone can SELECT.
- `messages`: participants of the chat only.
- All admin-only tables (`broadcasts`, `platform_settings`, `refunds`) use `has_role(auth.uid(),'admin')`.

Every `CREATE TABLE public.*` migration must be followed by explicit `GRANT` blocks per project rules.
