# 07 — Validations

None of these validations are currently enforced (all inputs on forms accept any value). Below is the required validation matrix implied by the UI.

---

## Phone number
- Format: E.164 (`+7XXXXXXXXXX` for Kazakhstan default seen in mockups).
- Length: 11–15 digits after `+`.
- Regex: `^\+[1-9]\d{7,14}$`.
- Uniqueness: unique across `users.phone`.
- Verification: 6-digit SMS OTP, TTL 5 min, max 5 attempts, resend cool-down 30 s.

## Email
- RFC 5322 practical subset: `^[^\s@]+@[^\s@]+\.[^\s@]+$`.
- Length ≤ 254.
- Uniqueness: unique across `users.email`.
- Normalised to lowercase.

## Password
- Length ≥ 8 characters.
- Must contain at least one digit and one letter.
- Must not equal the user's phone or email.
- Confirm-password must match exactly on `/reset-password` and `/register`.
- Stored hashed (bcrypt/argon2 via Supabase).

## Name
- Length 2..60 characters.
- Allowed: letters, spaces, `-`, `'`.

## Address
- `street` required, 2..120 chars.
- `apt` optional, ≤ 20 chars.
- `city` required, from allowed list.
- `lat`, `lng` must fall inside the service area polygon.
- Only one `is_default` per user.

## Order — creation
- `categoryId` required, must reference an active category.
- `appliance.brand` 1..40 chars, `appliance.model` 1..40 chars.
- `description` required, 10..1000 chars.
- `photos` array, 0..6 items; each ≤ 5 MB; mime `image/jpeg|png|webp`.
- `addressId` required, must belong to `auth.uid()`.
- `scheduledFor.date` must be ≥ today and ≤ today + 14 days.
- `scheduledFor.slot` must match a valid slot (`08:00-10:00`, `10:00-12:00`, …).

## Order — status transitions
- Only allowed edges from the state machine in `04_STATE_MACHINE.md`. Reject with `STATE_INVALID`.

## Offer
- `price` numeric, > 0, ≤ 1,000,000.
- `etaMinutes` integer, 5..240.
- `note` ≤ 200 chars.
- Only one offer per (order_id, technician_id).
- Order must be in `searching`.
- Technician must be `approved` and `is_online`.
- Order's category must be in technician's `specialties`.
- Order's address must be within `service_radius_km` of technician's `base_city` centroid.

## Payment
- `amount` = order.final_price + platform fee, matches server calc within ±0.01.
- `methodId` must belong to `auth.uid()` (unless method = cash).
- `tip` optional, 0..0.5 × amount.
- Gateway response required before status = succeeded.

## Review
- `rating` integer 1..5, required.
- `tags` array of strings from an allowed vocabulary (Punctual, Skilled, Friendly, Clean work, Fair price, Explained well, …), max 6.
- `comment` optional, ≤ 500 chars.
- Only allowed if order.status = `paid` and no existing review for the order.
- Not editable after creation (immutable).

## Withdrawal (technician)
- `amount` > 0, ≥ `min_payout` (platform setting), ≤ `wallet_balance`.
- `cardId` must belong to technician and be a `card` method.
- Only one pending withdrawal per technician at a time.

## Chat message
- Either `text` (1..2000 chars) or `attachmentUrl` required.
- Attachments: images ≤ 5 MB.
- Only sendable while the order is not in a terminal state.

## Dispute
- Order must be in `paid` / `completed` / `in_progress`.
- Must be filed within 7 days of order completion (window in `platform_settings`).
- `reason` from enum; `description` 20..1000 chars.

## OTP
- Exactly 6 digits, numeric only.
- Case-sensitive TTL: 5 minutes.
- Attempts limited to 5, then lock for 15 minutes.

## Broadcast (admin)
- Audience: `all_customers | all_technicians | segment:*`.
- Message length ≤ 500 chars.
- `scheduledAt` must be ≥ now.

## Cross-field rules
- `orders.scheduled_date` cannot fall on a date where the customer already has an active (non-terminal) order at the same slot.
- A technician cannot accept a request whose scheduled slot overlaps another accepted job for them.
