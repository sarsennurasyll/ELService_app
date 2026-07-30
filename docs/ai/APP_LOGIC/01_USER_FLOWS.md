# 01 — User Flows

This document describes every navigable flow currently wired in the ELService prototype. Only flows backed by an actual route file in `src/routes/` are listed. Anything a real production app would need beyond these routes is marked **Not implemented.**

Legend: `→` = `<Link to=...>` navigation present in code. All screens are static mockups with hardcoded data — no backend calls exist yet.

---

## A. Customer flows

### A1. First launch / onboarding
1. `/` (Splash) — brand screen with two CTAs.
2. **Get Started** → `/onboarding` (feature carousel, static content).
3. From onboarding → `/register` (Sign up form) or → `/login`.

### A2. Registration
1. `/register` — name, phone, email, password fields (form is display-only, no submit handler).
2. Submit CTA → `/otp` (6-digit OTP screen, 4 digits pre-filled, 5th slot focused).
3. **Verify** → `/home`.
- **Not implemented:** actual account creation, phone verification API, duplicate-account handling.

### A3. Login
1. `/login` — phone + password.
2. **Sign in** → `/home`.
3. **Forgot password?** → `/forgot-password` → success state → `/reset-password` → `/login`.
- **Not implemented:** credential validation, session persistence, error state on wrong password.

### A4. Browse & discovery
- `/home` — greeting, search box, 8 category tiles, promo strip, recent orders, top technicians.
- `/search` — search input with recent + popular queries (static list).
- `/categories` — full category grid → each tile → `/order/new`.
- `/favorites` — saved technicians list → `/technician/$id`.

### A5. Create a repair order (4-step wizard)
1. `/home` category tile → `/order/new` (step indicator shows 4/4 filled — the wizard is shown as already complete for demo purposes).
2. Sub-screens editable from `/order/new`:
   - Appliance picker → `/order/appliance`
   - Photos manager → `/order/photos`
   - Address picker → `/order/address`
   - Schedule picker → `/order/schedule`
3. **Continue** → `/order/confirm` (summary + price estimate).
4. **Confirm & find technician** → `/order/waiting`.
5. `/order/waiting` (searching state) → **View offers** → `/order/offers`.
6. `/order/offers` — 3 technician offers; tap a card → `/technician/$id` (profile / accept).
7. From technician profile → **Accept offer** → `/tracking/$id`.
8. `/tracking/$id` — live status timeline, ETA, contact CTA → `/chat/$id`.
9. When technician finishes, tracking screen exposes → `/payment/$id`.
10. `/payment/$id` — method picker, breakdown, pay CTA → `/order/completed/$id`.
11. `/order/completed/$id` — success screen → **Rate technician** → `/review/$id`.
12. `/review/$id` — 5-star + tag chips + comment → **Submit** → `/home`.

### A6. Order history
- `/orders` — list of past/active orders (tabs).
- Any row → `/tracking/$id` (active) or `/order/completed/$id` (finished).

### A7. Chat
- `/chat` — conversation list.
- Row → `/chat/$id` — message thread with technician (mock messages).

### A8. Notifications
- `/notifications` — grouped list of push messages (static).

### A9. Profile & account
- `/profile` — avatar, stats, menu.
- Rows go to: `/profile/edit`, `/favorites`, `/orders`, `/help`, `/settings`, `/language`.
- `/profile/edit` — editable fields → **Save** → `/profile`.
- `/settings` — preferences, security, delete account (toggles are decorative).
- `/language` — language picker.
- `/help` — FAQ + contact links.
- **Sign out** — **Not implemented** (no auth state to clear).

---

## B. Technician flows

### B1. Enter technician mode
- No dedicated technician login screen. Enter via `/tech` (index dashboard) directly.
- **Not implemented:** technician signup, verification/KYC upload flow, role selector on login.

### B2. Dashboard & work
- `/tech` — today's earnings, active job card, incoming-offer badge → `/tech/orders`, `/tech/active`, `/tech/offer/$id`.
- `/tech/orders` — list of assigned orders → `/tech/orders/$id`.
- `/tech/orders/$id` — order detail (customer, appliance, address, notes) with action buttons: navigate, call, mark en-route, mark started, mark completed.
- `/tech/offer/$id` — incoming request; **Send offer** (price + ETA) → back to `/tech`.
- `/tech/active` — currently active job with timer, checklist, complete button.
- `/tech/navigation` — map placeholder + turn-by-turn stub.

### B3. Calendar & availability
- `/tech/calendar` — week view with time-slot bookings.
- `/tech/availability` — day toggles + working hours.

### B4. Earnings & wallet
- `/tech/earnings` — chart, breakdown per day.
- `/tech/wallet` — balance, transactions → `/tech/withdraw`.
- `/tech/withdraw` — amount + card picker → confirmation.

### B5. Profile / reviews / stats / settings
- `/tech/profile` — public profile preview.
- `/tech/reviews` — customer reviews list.
- `/tech/stats` — KPIs (jobs, rating, response time).
- `/tech/settings` — preferences.

---

## C. Administrator flows

Enter via `/admin` (no auth gate). All admin screens are read-only mockups.

- `/admin` — KPI overview (revenue, active orders, disputes, new users).
- `/admin/orders` — orders table with status filters.
- `/admin/technicians` — technician list, verification status.
- `/admin/customers` — customer list.
- `/admin/disputes` — disputes queue.
- `/admin/categories` — appliance categories CRUD (UI only).
- `/admin/analytics` — charts.
- `/admin/payments` — payouts/transactions ledger.
- `/admin/reports` — report generation stubs.
- `/admin/notifications` — broadcast composer.
- `/admin/settings` — platform config.

**Not implemented for admin:** approve/reject actions, dispute resolution workflow, refund issuance, technician verification decisions with side effects.

---

## D. Cross-cutting flows

- Password reset: `/forgot-password` → email sent state → `/reset-password` → `/login`.
- 404: unmatched URL → root `NotFoundComponent` → `/`.
- Error boundary: any thrown error → `ErrorComponent` with "Try again" (`router.invalidate() + reset()`).

**Not implemented globally:** authentication, authorization, role gating between customer/tech/admin, real-time updates, push notifications, deep linking with parameters other than `$id`.
