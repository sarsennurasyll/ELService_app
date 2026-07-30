# 02 — Screen Logic

For each route file in `src/routes/` this document lists: **Purpose · Entry · Data · Actions · Validation · States · Navigation · Dependencies**. All data today is hardcoded in each component; "Required data" describes what a production implementation must provide.

> Convention: "States" lists loading / empty / error / success requirements. The current build renders only the "happy" state for every screen — other states are **Not implemented** unless explicitly noted.

---

## Auth & onboarding

### `/` — Splash (`index.tsx`)
- **Purpose:** brand entry point.
- **Entry:** app cold start / logo tap.
- **Data:** none.
- **Actions:** Get Started → `/onboarding`; I already have an account → `/login`.
- **Validation / states:** none.
- **Dependencies:** `MobileShell`.

### `/onboarding`
- **Purpose:** explain value props before signup.
- **Entry:** from Splash.
- **Actions:** Skip / Next → `/register`.
- **States:** all **Not implemented** (no slide state persisted).

### `/login`
- **Purpose:** sign in existing user.
- **Data:** phone, password inputs.
- **Actions:** Sign in → `/home`; Forgot → `/forgot-password`; Create account → `/register`.
- **Validation (required in prod):** phone E.164, password min 8 chars.
- **States:** loading spinner on submit, error toast on bad creds — **Not implemented**.

### `/register`
- **Purpose:** create account.
- **Data:** name, phone, email, password, terms checkbox.
- **Actions:** Sign up → `/otp`.
- **Validation (required in prod):** name ≥ 2 chars, phone E.164, email RFC 5322, password ≥ 8 with 1 digit, terms accepted.
- **States:** duplicate account error — **Not implemented**.

### `/otp`
- **Purpose:** verify phone via 6-digit SMS code.
- **Data:** 6 slot digits; countdown "Resend in 00:28".
- **Actions:** Verify → `/home`; Change phone → back to `/register`.
- **Validation:** all 6 digits numeric.
- **States:** wrong code, expired code, resend cool-down — **Not implemented**.

### `/forgot-password`
- **Purpose:** request password reset email.
- **Actions:** Send link → success state → `/reset-password`.

### `/reset-password`
- **Purpose:** set new password using recovery link.
- **Data:** new password, confirm.
- **Validation:** ≥ 8 chars, matches confirm.
- **Actions:** Save → `/login`.

---

## Customer core

### `/home`
- **Purpose:** hub with search, categories, promo, recent orders, top techs.
- **Data:** current city, user first name, category list, promo, recent orders (last N), featured technicians.
- **Actions:** category tile → `/order/new`; search → `/search`; bell → `/notifications`; avatar → `/profile`; recent order card → `/tracking/$id` or `/order/completed/$id`.
- **States:** empty recents block, offline banner — **Not implemented**.
- **Dependencies:** `CustomerNav`.

### `/search`
- **Purpose:** free-text search + suggestions.
- **Data:** recent queries, popular tags.
- **Actions:** submit query → results list (**Not implemented** — currently no results screen).

### `/categories`
- **Purpose:** full category grid.
- **Actions:** tile → `/order/new` (with category prefilled — **Not implemented**, prefill is decorative).

### `/favorites`
- **Purpose:** saved technicians.
- **Actions:** row → `/technician/$id`; heart to remove — **Not implemented**.

### `/notifications`
- **Purpose:** list system + order push messages, grouped by day.
- **Actions:** row → related order/screen — **Not implemented** (rows are inert).

---

## Order creation wizard

### `/order/new`
- **Purpose:** compose an order.
- **Data:** appliance, problem description, photos, address, schedule slot, estimated range.
- **Actions:** each row opens sub-picker; Continue → `/order/confirm`.
- **Validation (prod):** appliance selected, description ≥ 10 chars, address chosen, slot chosen.
- **States:** validation errors under each row — **Not implemented**.

### `/order/appliance`
- Pick appliance type + brand + model.
- Save → `/order/new`.

### `/order/photos`
- Add up to 6 photos (camera / gallery).
- **Validation:** ≤ 6 images, ≤ 5 MB each — **Not implemented**.

### `/order/address`
- Choose saved address or add new.
- **Validation:** street + apt + city required.

### `/order/schedule`
- Pick date + time window.
- **Validation:** date ≥ today; slot within technician working hours (**Not implemented**).

### `/order/confirm`
- Read-only summary + estimate range + terms.
- Actions: **Find technician** → `/order/waiting`; **Edit** → `/order/new`.

### `/order/waiting`
- **Purpose:** searching-technician state; broadcasts request to nearby techs.
- **Data:** counters (technicians notified, offers received), elapsed time.
- **Actions:** View offers → `/order/offers`; Cancel request → confirm dialog (**Not implemented**) → back to `/home`.
- **States:** searching (default), timeout with no offers — **Not implemented**.

### `/order/offers`
- **Purpose:** compare up to N technician offers live.
- **Data per offer:** technician profile, ETA, price, rating, jobs count.
- **Actions:** tap card → `/technician/$id`.
- **States:** empty (no offers yet), stale offers (expired) — **Not implemented**.

### `/technician/$id`
- **Purpose:** technician profile + accept the offer that led here.
- **Data:** name, avatar, rating, reviews, specialties, price for this order, ETA.
- **Actions:** Accept → `/tracking/$id`; Chat → `/chat/$id`; Back to offers.

### `/tracking/$id`
- **Purpose:** live status of an active order.
- **Data:** status timeline (Accepted → En route → Arrived → In progress → Completed), ETA, technician contact.
- **Actions:** Call, Chat → `/chat/$id`, Cancel (rules per state), Proceed to payment → `/payment/$id` when status = Completed.
- **States:** each status renders differently; connection-lost banner — **Not implemented**.

### `/payment/$id`
- **Purpose:** collect payment for completed job.
- **Data:** amount, breakdown (labor, parts, service fee), saved cards, wallets, cash option.
- **Actions:** Pay → `/order/completed/$id`.
- **Validation (prod):** method selected; card CVV.
- **States:** processing, declined, 3-DS challenge — **Not implemented**.

### `/order/completed/$id`
- **Purpose:** success confirmation + receipt summary.
- **Actions:** Rate → `/review/$id`; Back to home → `/home`.

### `/review/$id`
- **Purpose:** post-job rating.
- **Data:** 1–5 stars, tag chips, comment.
- **Validation:** stars required.
- **Actions:** Submit → `/home`.

---

## Customer chat

### `/chat`
- List of active conversations. Row → `/chat/$id`.

### `/chat/$id`
- Thread with technician. Send text; attach photo — **Not implemented**.

---

## Customer orders history

### `/orders`
- Tabs: Active / Completed / Cancelled.
- Row → tracking or completed screen depending on status.

---

## Customer profile / settings

### `/profile`
- Header (avatar, name, stats). Menu rows to edit, favorites, orders, help, settings, language, sign out.

### `/profile/edit`
- Editable fields (name, email, phone, city).
- Save → `/profile`.

### `/settings`
- Preferences (notifications toggle, dark mode, language), Security (change password, 2FA), Account (delete). All toggles are visual only.

### `/language`
- Radio list of supported languages.

### `/help`
- FAQ accordion + contact CTA.

---

## Technician

### `/tech`
- Dashboard: today earnings, active job, incoming request badge.
- Row/CTA → `/tech/orders`, `/tech/active`, `/tech/offer/$id`, `/tech/wallet`.

### `/tech/orders`
- List of assigned orders. Row → `/tech/orders/$id`.

### `/tech/orders/$id`
- Order detail. Actions: Navigate → `/tech/navigation`; Call customer; Mark en-route / Started / Completed.
- **State transitions (prod):** Assigned → EnRoute → Arrived → InProgress → Completed.

### `/tech/offer/$id`
- Send offer for an incoming request. Inputs: price, ETA, note.
- **Validation:** price > 0, ETA ≤ working-hours end.

### `/tech/active`
- Currently running job with elapsed timer + checklist + Complete CTA.

### `/tech/navigation`
- Map + directions placeholder.

### `/tech/calendar`
- Week schedule.

### `/tech/availability`
- Day toggles + working-hours pickers.

### `/tech/earnings`
- Range picker + chart + per-day breakdown.

### `/tech/wallet`
- Balance + transactions. Withdraw → `/tech/withdraw`.

### `/tech/withdraw`
- Amount + destination card. **Validation:** amount ≤ balance, amount ≥ min payout.

### `/tech/profile`, `/tech/reviews`, `/tech/stats`, `/tech/settings`
- Read-only summaries and preferences.

---

## Administrator

### `/admin`
- KPI cards, activity feed, quick links.

### `/admin/orders`
- Table with status filter, search, row → order detail (**Not implemented** — detail screen is missing for admin).

### `/admin/technicians`
- List with verification badge; action buttons decorative.

### `/admin/customers`
- List with search.

### `/admin/disputes`
- Queue of disputes. Actions: assign, resolve — **Not implemented**.

### `/admin/categories`
- Category tree with add/edit/delete affordances (decorative).

### `/admin/analytics`
- Charts.

### `/admin/payments`
- Ledger of transactions/payouts.

### `/admin/reports`
- Report presets (revenue, technician performance, dispute rate).

### `/admin/notifications`
- Compose broadcast (audience picker, message, schedule).

### `/admin/settings`
- Platform config toggles.

---

## Shared dependencies (all screens)
- `src/components/mobile/MobileShell.tsx` — device frame on desktop, full-bleed on mobile.
- `src/components/mobile/Screen.tsx` — `TopBar` component (back button, title, subtitle, transparent variant).
- `src/components/mobile/BottomNav.tsx` — `CustomerNav`, tech nav, admin nav.
- Design tokens live in `src/styles.css` (semantic Tailwind v4 tokens: `primary`, `secondary`, `surface`, `border`, `subtitle`, `success`, `warning`, `error`).
