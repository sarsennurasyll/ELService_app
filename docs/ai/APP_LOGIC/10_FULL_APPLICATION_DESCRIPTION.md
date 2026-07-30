# 10 — Full Application Description

Complete functional specification of ELService as it exists in this repository plus the behaviours the UI implies. Intended as a rebuild blueprint. Statements about the **current build** describe what runs today (static React screens rendered by TanStack Start). Statements about **required behaviour** describe what a production rebuild must implement. Where a capability is absent from both, it is marked **Not implemented.**

---

## 1. Product summary

ELService is a mobile marketplace that connects **customers** who need home-appliance repair (fridge, washer, AC, TV, microwave, oven, heater, other) with vetted **technicians**, and gives **administrators** a console to moderate the platform. The customer describes the problem, receives live competing offers from nearby technicians, tracks the chosen technician in real time, pays in-app after completion, and reviews the technician. Technicians manage requests, availability, calendar, earnings, wallet, and payouts. Administrators oversee orders, users, disputes, categories, analytics, payments, reports, broadcasts and platform settings.

## 2. Tech stack (current)

- TanStack Start v1 on Vite 7, React 19.
- Tailwind CSS v4 with semantic tokens in `src/styles.css`.
- File-based routing under `src/routes/`.
- No backend, no database, no auth. All screens render hardcoded data.
- Shared shell components in `src/components/mobile/` (`MobileShell`, `Screen`, `BottomNav`).

Target additions for production rebuild: Lovable Cloud (Postgres + Auth + Storage + Functions), TanStack Query for reads, `createServerFn` for RPC, WebSockets for realtime, push (FCM/APNs), SMS + email providers, payment gateway.

## 3. Roles

- **Customer** — default account. Creates orders, chats, pays, reviews.
- **Technician** — verified account. Receives requests, offers, executes and completes jobs, withdraws earnings.
- **Administrator** — internal staff. Full moderation console.

Roles must be stored in a dedicated `user_roles` table with a `has_role()` security-definer function per project rules. Role-based route guards are **Not implemented** in the current build; today all routes are open.

## 4. Application shell

Every route renders inside `MobileShell`, which frames the app as a phone on desktop viewports and full-bleed on mobile. `TopBar` provides back button + title + optional subtitle + transparent variant. `BottomNav` provides three role-specific tab bars: customer (`Home / Orders / Chat / Profile`), technician (`Dashboard / Orders / Calendar / Wallet / Profile`), admin (`Overview / Orders / Users / Disputes / More`).

## 5. Screens & flows (canonical)

The full list, routing, purpose, entry, actions, and states for every screen is in `02_SCREEN_LOGIC.md`. End-to-end flow narratives are in `01_USER_FLOWS.md`. The state model for orders / offers / payments / users is in `04_STATE_MACHINE.md`.

Summary of primary paths:

- **Customer happy path:** `/` → `/onboarding` → `/register` → `/otp` → `/home` → category → `/order/new` (`/order/appliance`, `/order/photos`, `/order/address`, `/order/schedule`) → `/order/confirm` → `/order/waiting` → `/order/offers` → `/technician/$id` → `/tracking/$id` → `/payment/$id` → `/order/completed/$id` → `/review/$id` → `/home`.
- **Customer secondary paths:** `/search`, `/categories`, `/favorites`, `/chat` + `/chat/$id`, `/orders`, `/notifications`, `/profile`, `/profile/edit`, `/settings`, `/language`, `/help`, `/forgot-password`, `/reset-password`.
- **Technician:** `/tech` → `/tech/orders` / `/tech/orders/$id` / `/tech/offer/$id` / `/tech/active` / `/tech/navigation` / `/tech/calendar` / `/tech/availability` / `/tech/earnings` / `/tech/wallet` / `/tech/withdraw` / `/tech/profile` / `/tech/reviews` / `/tech/stats` / `/tech/settings`.
- **Admin:** `/admin` → `/admin/orders` / `/admin/technicians` / `/admin/customers` / `/admin/disputes` / `/admin/categories` / `/admin/analytics` / `/admin/payments` / `/admin/reports` / `/admin/notifications` / `/admin/settings`.

## 6. Data model

Full ERD in `06_DATABASE_REQUIREMENTS.md`. Core entities: `users` (+ `user_roles`), `addresses`, `payment_methods`, `categories`, `technician_profiles`, `technician_availability`, `orders`, `order_photos`, `order_events`, `offers`, `payments`, `refunds`, `reviews`, `favorites`, `chats`, `messages`, `notifications`, `devices`, `disputes`, `withdrawals`, `broadcasts`, `platform_settings`. Every table lives in `public` schema with RLS enabled and explicit GRANTs.

## 7. API surface

Full HTTP contract in `05_API_REQUIREMENTS.md`. High-level namespaces: `/api/auth/*`, `/api/me/*`, `/api/orders/*`, `/api/tech/*`, `/api/chats/*`, `/api/notifications/*`, `/api/technicians/:id`, `/api/admin/*`, plus WebSocket channels `/ws/orders/:id` and `/ws/tech/requests`.

Implementation guidance for this stack: use `createServerFn` from `@tanstack/react-start` for authenticated client-called operations; use file-based server routes under `src/routes/api/public/*` for webhooks (payment gateway, SMS DLR); use the Supabase clients pattern (`client.ts` for browser, `auth-middleware` for user-scoped server functions, `client.server.ts` `supabaseAdmin` for verified webhooks only).

## 8. Business rules

Full list in `03_BUSINESS_RULES.md`. Essentials:

- Only customers create orders; only their owner can edit/cancel while pre-execution.
- Technicians can only quote while an order is `searching`; one offer per technician per order.
- Customer accepts exactly one offer; the rest are auto-declined.
- Payment occurs after `completed`; refunds only via admin.
- Reviews are one-per-order, immutable, and only after `paid`.
- Technicians match on category, service radius, availability window, and verification = `approved`.
- Withdrawals require `balance ≥ min_payout` to a verified card.

## 9. State machines

Every order, offer, payment, dispute, technician verification and user account is modelled as a finite state machine — see `04_STATE_MACHINE.md`. Transitions must be enforced server-side with `STATE_INVALID` errors on illegal edges and an append-only `order_events` log for auditability.

## 10. Validation

Complete rules in `07_VALIDATIONS.md`. Client-side validation is a UX affordance; server-side is authoritative. Highlights: phone E.164, password ≥ 8 chars with digit, description 10..1000 chars, up to 6 photos ≤ 5 MB each, offer price > 0 and eta 5..240 min, review rating 1..5, dispute window 7 days.

## 11. Notifications

Complete matrix in `08_NOTIFICATIONS.md`. Push + in-app + email + SMS. Quiet hours 23:00–07:00 for non-active-job events. Dedup 30-s window. Notification preferences are per-user, per-channel, per-category. All dispatched notifications write to `notifications` for in-app feed persistence.

## 12. Edge cases

Full catalogue in `09_EDGE_CASES.md`. Highlights: no-offers timeout, duplicate submission dedup, card decline retry, 3-DS resume-on-foreground, technician late-arrival cancellation waiver, offline queueing for chat, OTP brute-force lockout, refund-larger-than-payment rejection, race on offer acceptance via row-level lock.

## 13. Design system

Colour and shape tokens are defined in `src/styles.css` and consumed through Tailwind v4 semantic classes: `bg-primary`, `bg-secondary`, `bg-surface`, `border-border`, `text-subtitle`, `text-success`, `text-warning`, `text-error`, `bg-background`. Layout primitives: `rounded-2xl` cards, `border border-border`, `shadow-lg shadow-primary/20` accents. Typography scale is Tailwind's default with weight emphasis (`font-black`, `font-bold`, `font-semibold`). Icons from `lucide-react`. Bottom nav and top bar are the only chrome. Currency displayed as `<amount> ₸` (KZT).

Reusable UI patterns visible in the current code:
- **Status pill** — small rounded-full label with `bg-*-10/20` tinted surface and matching foreground colour.
- **List row** — `bg-surface border border-border rounded-2xl p-4 flex items-center gap-3` with a leading icon square, label + subtitle, trailing chevron.
- **CTA button** — full-width `bg-primary text-white py-3.5 rounded-2xl font-bold text-sm text-center shadow-lg shadow-primary/20`.
- **Step indicator** — thin coloured segments in a flex row (`/order/new`).
- **Empty / success illustration** — large circular icon halo with inner filled circle (`/order/completed/$id`, `/order/waiting`).

## 14. Non-functional requirements

- Mobile-first, works within a 375–430 px viewport as the primary target; larger viewports show the phone frame.
- Every list view supports keyboard-safe scroll; interactive elements have min 44 px hit area.
- Realtime SLAs: order status push < 3 s, chat message delivery < 1 s.
- Payments must be PCI-DSS-scoped through the gateway (no PAN on our servers).
- All PII access must go through RLS-authorised queries.

## 15. What is present today vs required

**Present:** 60 route files delivering a fully navigable static UI covering every screen listed above; brand-consistent design system; TanStack Router shell with error boundary and 404.

**Not implemented:** authentication, authorization, database, API layer, real-time channels, payment integration, notification dispatch, form validation, loading/empty/error/success states beyond the default happy path, technician signup/verification flow, dispute resolution actions, refund issuance, chat send/receive, push devices, background jobs (order expiry, review reminders), analytics wiring on admin dashboards, i18n beyond English strings, dark mode wiring, sign-out.

## 16. Rebuild checklist

1. Enable Lovable Cloud; create schema per `06_DATABASE_REQUIREMENTS.md` with RLS + GRANTs.
2. Add `user_roles` + `has_role()` and wire the managed `_authenticated/` gate.
3. Implement `createServerFn`s in `src/lib/*.functions.ts` for each `/api/*` group in `05_API_REQUIREMENTS.md`.
4. Add webhooks under `src/routes/api/public/*` (payment gateway callback, SMS delivery receipts).
5. Convert every screen from hardcoded data to `useSuspenseQuery(queryOptions)` reading through server functions.
6. Add Zod validators per `07_VALIDATIONS.md` as `.inputValidator()` on every server function.
7. Enforce state-machine transitions in the DB (triggers) and mirror in server functions.
8. Wire the notification dispatcher per `08_NOTIFICATIONS.md` (server-side event → channel fan-out).
9. Implement loading skeletons, empty states, error states and success toasts on every screen.
10. Add real auth flows (register, OTP, login, forgot/reset password, sign-out with cache teardown).
11. Add role-based route gating for `/tech/*` and `/admin/*`.
12. Add push registration + realtime subscriptions for `/tracking/$id`, `/tech`, `/chat/$id`.
13. Implement payment gateway integration and 3-DS handling on `/payment/$id`.
14. Implement admin actions (verify tech, resolve dispute, refund, edit category, broadcast).
15. Add analytics event tracking and populate `/admin/analytics`, `/admin/reports`.

Once every item above ships and every "Not implemented" note in these documents is resolved, the product matches the intent of the current UI.
