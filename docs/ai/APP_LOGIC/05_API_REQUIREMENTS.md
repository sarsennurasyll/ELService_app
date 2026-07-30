# 05 — API Requirements

**No API exists in the current codebase.** There are no `createServerFn` handlers, no `src/routes/api/*` server routes, no Supabase/DB integration. Everything below is the API contract a production implementation must build to satisfy the UI in `src/routes/`.

Conventions:
- Base URL: `/api`.
- Auth: `Authorization: Bearer <JWT>` on all authenticated endpoints.
- Content-Type: `application/json` unless noted.
- Errors: `{ "error": { "code": "STRING_CODE", "message": "human readable" } }` with appropriate HTTP status.
- All list endpoints support `?limit=`, `?cursor=`.

---

## Auth

### `POST /api/auth/register`
- **Auth:** none.
- **Body:** `{ name, phone, email, password }`
- **Validation:** name ≥ 2, phone E.164, email valid, password ≥ 8 with digit.
- **Response 201:** `{ userId, otpChannel: "sms" }`
- **Errors:** 409 `EMAIL_TAKEN`, 409 `PHONE_TAKEN`, 400 `VALIDATION`.

### `POST /api/auth/otp/verify`
- **Body:** `{ userId, code }`
- **Response 200:** `{ accessToken, refreshToken, user }`
- **Errors:** 400 `INVALID_CODE`, 410 `CODE_EXPIRED`, 429 `TOO_MANY_ATTEMPTS`.

### `POST /api/auth/otp/resend`
- **Body:** `{ userId }`
- **Errors:** 429 `COOLDOWN`.

### `POST /api/auth/login`
- **Body:** `{ phone, password }`
- **Response 200:** `{ accessToken, refreshToken, user }`
- **Errors:** 401 `INVALID_CREDENTIALS`, 423 `ACCOUNT_LOCKED`.

### `POST /api/auth/forgot-password`
- **Body:** `{ email }`
- **Response:** 202 (always, to avoid enumeration).

### `POST /api/auth/reset-password`
- **Body:** `{ token, newPassword }`
- **Errors:** 400 `INVALID_TOKEN`, 410 `TOKEN_EXPIRED`.

### `POST /api/auth/refresh` — rotates tokens.
### `POST /api/auth/logout` — invalidates refresh token.

---

## User / profile

### `GET /api/me` — current user profile.
### `PATCH /api/me` — update name/email/phone/city/avatar.
### `POST /api/me/avatar` — multipart image, ≤ 5 MB.
### `DELETE /api/me` — self-service account deletion.

### `GET /api/me/addresses` / `POST` / `PATCH /:id` / `DELETE /:id`
- Body: `{ label, street, apt, city, lat, lng, isDefault }`.

### `GET /api/me/payment-methods` / `POST` (tokenised via gateway) / `DELETE /:id`.

### `GET /api/me/favorites` / `POST { technicianId }` / `DELETE /:technicianId`.

---

## Categories & search

### `GET /api/categories` — appliance categories used on `/home` and `/categories`.
### `GET /api/search?q=...` — search across categories, technicians, past orders.

---

## Orders (customer)

### `POST /api/orders`
- **Auth:** customer.
- **Body:**
  ```
  {
    "categoryId": "uuid",
    "appliance": { "brand": "Samsung", "model": "RB37" },
    "description": "string",
    "photos": ["url", ...],
    "addressId": "uuid",
    "scheduledFor": { "date": "YYYY-MM-DD", "slot": "10:00-12:00" }
  }
  ```
- **Validation:** description ≥ 10 chars, photos ≤ 6, `scheduledFor.date` ≥ today.
- **Response 201:** `{ order }` with status `Searching`.

### `GET /api/orders` — list current user's orders, filter `?status=`.
### `GET /api/orders/:id` — order detail.
### `PATCH /api/orders/:id` — edit while status ∈ {Draft, Searching}.
### `POST /api/orders/:id/cancel` — body `{ reason }`. Rules per state (see 03).

### `GET /api/orders/:id/offers` — technician offers for this order.
### `POST /api/orders/:id/accept-offer` — body `{ offerId }`. Sets state to `Accepted`.

### `POST /api/orders/:id/photos` — multipart upload up to 6.

### `POST /api/orders/:id/payment`
- Body `{ methodId, amount, tipAmount? }`.
- Response `{ paymentId, status }`.

### `POST /api/orders/:id/review`
- Body `{ rating: 1..5, tags: string[], comment? }`.

### `POST /api/orders/:id/dispute`
- Body `{ reason, description }`.

---

## Technician endpoints

### `GET /api/tech/requests` — orders currently broadcast to this technician (state `Searching` matching filters).
### `POST /api/tech/requests/:id/offer`
- Body `{ price, etaMinutes, note? }`.
- Errors: 409 `ALREADY_ACCEPTED`, 410 `EXPIRED`.
### `DELETE /api/tech/offers/:id` — withdraw before accept.

### `GET /api/tech/orders` — assigned orders.
### `GET /api/tech/orders/:id` — detail.
### `POST /api/tech/orders/:id/status` — body `{ status: "EnRoute"|"Arrived"|"InProgress"|"Completed" }`. Enforces state machine.

### `GET /api/tech/availability` / `PUT` — `{ enabled, weekdays[], workingHours }`.
### `GET /api/tech/calendar?from&to`.
### `GET /api/tech/earnings?range=`.
### `GET /api/tech/wallet` — `{ balance, currency, transactions }`.
### `POST /api/tech/withdraw` — body `{ amount, cardId }`. Validates `amount ≤ balance && amount ≥ minPayout`.
### `GET /api/tech/reviews`.
### `GET /api/tech/stats`.
### `PATCH /api/tech/profile` — bio, specialties, service radius.

---

## Chat

### `GET /api/chats` — customer or technician conversation list.
### `GET /api/chats/:id/messages?cursor=`.
### `POST /api/chats/:id/messages` — body `{ text?, attachmentUrl? }`.
### WebSocket `/ws/chat` — real-time messages.

---

## Notifications

### `GET /api/notifications` — user notifications feed.
### `PATCH /api/notifications/:id/read`.
### `POST /api/devices` — register push token `{ token, platform }`.

---

## Public technician profile

### `GET /api/technicians/:id` — profile shown on `/technician/$id`.

---

## Admin

All admin endpoints require role `admin`.

### `GET /api/admin/overview` — KPIs for `/admin`.
### `GET /api/admin/orders` — full order list with filters.
### `GET /api/admin/orders/:id` — detail.
### `POST /api/admin/orders/:id/refund` — issue refund.
### `GET /api/admin/technicians` — list with verification state.
### `POST /api/admin/technicians/:id/verify` — body `{ decision: "approve"|"reject", note? }`.
### `POST /api/admin/technicians/:id/suspend` / `POST .../unsuspend`.
### `GET /api/admin/customers` / `POST /:id/suspend`.
### `GET /api/admin/disputes` / `POST /:id/resolve` — body `{ decision, refundAmount? }`.
### `GET /api/admin/categories` / `POST` / `PATCH /:id` / `DELETE /:id`.
### `GET /api/admin/analytics?metric=&range=`.
### `GET /api/admin/payments` / `GET /:id`.
### `GET /api/admin/reports` / `POST /generate`.
### `POST /api/admin/broadcasts` — body `{ audience, message, scheduledAt? }`.
### `GET /api/admin/settings` / `PUT`.

---

## Realtime

- WebSocket `/ws/orders/:id` — pushes state changes for tracking screen.
- WebSocket `/ws/tech/requests` — pushes new requests to online technicians.

---

## Error codes (canonical)

`VALIDATION`, `UNAUTHENTICATED`, `FORBIDDEN`, `NOT_FOUND`, `CONFLICT`, `RATE_LIMITED`, `PAYMENT_DECLINED`, `PAYMENT_REQUIRES_ACTION`, `STATE_INVALID` (state-machine violation), `TECHNICIAN_UNAVAILABLE`.
