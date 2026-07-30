# 03 — Business Rules

The current codebase enforces **zero** business rules at runtime (all screens are static). This document lists the rules the product implies through its screens and the rules a production implementation must add. Rules marked **Implied by UI** are visible in the mockups; rules marked **Not implemented** must be added when building the backend.

---

## Roles

- **Customer** — creates orders, chooses technicians, pays, reviews.
- **Technician** — receives requests, sends offers, executes jobs, withdraws earnings.
- **Administrator** — moderates users, resolves disputes, manages categories/payments.
- **Not implemented:** role assignment, role switching, permission checks. Every route is publicly reachable today.

---

## Order lifecycle rules

- Only an authenticated **Customer** may create an order (`/order/new`). *Not implemented.*
- An order must have: appliance, problem description, address, schedule slot before it can be submitted from `/order/confirm`. *Implied by UI (four required rows), not enforced.*
- After submission the order enters `Searching` and is broadcast to eligible technicians. *Implied by `/order/waiting`.*
- A **Customer** can cancel an order while status ∈ {Draft, Searching, OfferReceived, Accepted, EnRoute}. Cancelling after **InProgress** requires admin dispute. *Not implemented.*
- A **Customer** can edit an order (appliance/description/photos/address/schedule) only while status = Draft or Searching. *Not implemented.*
- Only the **assigned Technician** or the **Customer** may mark chat messages read on that order thread. *Not implemented.*

## Offer rules

- A **Technician** may submit an offer for a request only while the request is in status `Searching`. *Implied by `/tech/offer/$id`.*
- One offer per technician per order. Re-submitting replaces the previous quote until customer accepts.
- Offer fields: `price` (> 0), `eta_minutes` (> 0), optional note.
- Offers expire after the request's TTL (e.g. 5 minutes since broadcast) — *Not implemented.*
- Customer selects exactly one offer via `/technician/$id` → Accept. All other offers are automatically declined. *Implied by flow, not enforced.*

## Payment rules

- Payment is required **after** status = `Completed`. `/tracking/$id` only exposes "Pay" once the technician marks the job done. *Implied.*
- Supported methods (from `/payment/$id`): saved card, Apple/Google Pay, cash. *Implied by UI.*
- Amount = final offer price + platform service fee. Fee %: *Not implemented.*
- Refunds are only issued by an Administrator through `/admin/payments` / `/admin/disputes`. *Not implemented.*

## Review rules

- A **Customer** may submit exactly one review per completed order via `/review/$id`.
- Review requires 1–5 star rating; tag chips and comment are optional.
- Reviews are visible on `/technician/$id` and `/tech/reviews`.
- Review cannot be edited after submission. *Not implemented.*
- A technician cannot review a customer in the current design.

## Technician availability & assignment rules

- A technician receives a request only if:
  - `availability_today = on` (see `/tech/availability`),
  - current time within their working hours,
  - the order's category matches their `specialties`,
  - the customer's address is within their service radius.
- *All not implemented.*

## Priority / matching rules (implied by "Best match" badge on `/order/offers`)

- "Best match" is assigned to the offer that optimises weighted score of: rating, distance/ETA, price, completed jobs. Exact formula: *Not implemented.*

## Notification rules

See `08_NOTIFICATIONS.md`. High-level: transactional notifications on every status change; marketing broadcasts only from `/admin/notifications`.

## Wallet / withdrawal rules

- A technician may request a withdrawal only if `balance ≥ min_payout` (min payout: *Not implemented*).
- Withdrawals go to a verified card only.
- Platform holds funds until the customer completes payment and the anti-fraud hold window elapses. *Not implemented.*

## Moderation rules

- Only administrators may:
  - approve/reject technician verification (`/admin/technicians`),
  - resolve disputes (`/admin/disputes`),
  - issue refunds (`/admin/payments`),
  - edit categories (`/admin/categories`),
  - send broadcasts (`/admin/notifications`).
- *All UI present, none enforced.*

## Data-visibility rules

- A customer sees only their own orders, payments, reviews.
- A technician sees only orders assigned or offered to them, and their own earnings/reviews.
- Admin sees everything.
- *Not implemented (no row-level authorization).*
