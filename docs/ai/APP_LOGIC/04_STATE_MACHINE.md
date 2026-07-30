# 04 — State Machine

Formal state model for the core entities in ELService. Derived from the screens present in `src/routes/`. Transitions marked **Not implemented** have no runtime code today.

---

## Order

States:

| State | Enter by | Screen | Allowed actions | Next states |
|---|---|---|---|---|
| `Draft` | Customer starts `/order/new` | `/order/new` | edit fields, submit, discard | `Searching`, `Cancelled` |
| `Searching` | Customer confirms on `/order/confirm` | `/order/waiting` | cancel; wait for offers | `OfferReceived`, `Cancelled`, `Expired` |
| `OfferReceived` | ≥ 1 technician submitted an offer | `/order/offers` | pick offer, keep waiting, cancel | `Accepted`, `Cancelled`, `Expired` |
| `Accepted` | Customer accepts an offer on `/technician/$id` | `/tracking/$id` | cancel (with penalty rules), chat, call | `EnRoute`, `Cancelled` |
| `EnRoute` | Technician taps "On my way" (`/tech/orders/$id`) | `/tracking/$id` | chat, call, cancel-late | `Arrived`, `Cancelled` |
| `Arrived` | Technician taps "Arrived" | `/tracking/$id` | start work, cancel | `InProgress`, `Cancelled` |
| `InProgress` | Technician taps "Start" (`/tech/active`) | `/tech/active` + `/tracking/$id` | complete, request more parts (**Not implemented**), open dispute | `Completed`, `Disputed` |
| `Completed` | Technician taps "Mark complete" | `/tracking/$id` → payment CTA | pay, dispute | `Paid`, `Disputed` |
| `Paid` | Payment success on `/payment/$id` | `/order/completed/$id` | leave review | `Reviewed`, `Disputed` |
| `Reviewed` | Review submitted on `/review/$id` | `/home` | none — terminal | — |
| `Cancelled` | any cancel action | `/orders` | none — terminal | — |
| `Expired` | no offers within TTL | `/order/waiting` timeout | retry (creates new order) | — |
| `Disputed` | opened via `/help` or `/admin/disputes` | `/admin/disputes` | resolve → refund, resolve → uphold | `Paid`, `Refunded` |
| `Refunded` | Admin issues refund | `/admin/payments` | terminal | — |

Notes:
- **Terminal states:** `Reviewed`, `Cancelled`, `Expired`, `Refunded`.
- All transitions except UI navigation are **Not implemented** at runtime.

### Order transition diagram (textual)
```
Draft → Searching → OfferReceived → Accepted → EnRoute → Arrived → InProgress → Completed → Paid → Reviewed
             │            │             │          │          │          │             │
             └────────────┴─────────────┴──────────┴──────────┴── Cancelled            └── Disputed → Refunded
```

---

## Offer (per technician per order)

| State | Enter by | Allowed actions | Next states |
|---|---|---|---|
| `Requested` | order broadcast reaches technician (`/tech/offer/$id`) | submit offer, ignore | `Submitted`, `Ignored`, `Expired` |
| `Submitted` | technician sends price+ETA | withdraw before customer picks | `Accepted`, `Declined`, `Expired`, `Withdrawn` |
| `Accepted` | customer picks this offer | — | terminal — becomes the order's technician |
| `Declined` | customer picks a different offer or cancels order | — | terminal |
| `Expired` | request TTL exceeded | — | terminal |
| `Withdrawn` | technician cancels their own offer before selection | — | terminal |
| `Ignored` | technician never responded | — | terminal |

*Not implemented — no offer entity exists in code.*

---

## Technician availability

| State | Enter by | Allowed actions |
|---|---|---|
| `Offline` | default / manually toggled off in `/tech/availability` | switch on |
| `Online-Idle` | toggle on, no active job | receive requests |
| `Online-Busy` | assigned an order in `Accepted`..`InProgress` | finish current job before new requests |

---

## Payment

| State | Enter by | Next |
|---|---|---|
| `Pending` | `/payment/$id` open | `Authorising` |
| `Authorising` | user taps Pay | `Succeeded`, `Failed`, `RequiresAction` (3-DS) |
| `RequiresAction` | issuer 3-DS challenge | `Succeeded`, `Failed` |
| `Succeeded` | gateway confirms | terminal → order becomes `Paid` |
| `Failed` | decline / network error | retryable → back to `Pending` |
| `Refunded` | admin action | terminal |

*Not implemented — no payment client exists.*

---

## User account

| State | Notes |
|---|---|
| `Unverified` | after `/register`, before `/otp` success |
| `Active` | after OTP or successful login |
| `Suspended` | admin action from `/admin/customers` or `/admin/technicians` |
| `Deleted` | user requested from `/settings` — self-service delete |

*Not implemented.*

---

## Technician verification

| State | Enter | Next |
|---|---|---|
| `Pending` | technician signs up | `UnderReview`, `Rejected` |
| `UnderReview` | admin opens profile in `/admin/technicians` | `Approved`, `Rejected` |
| `Approved` | admin confirms | can receive requests |
| `Rejected` | admin denies | technician can reapply |

*Not implemented — no signup flow exists for technicians.*

---

## Dispute

| State | Enter | Next |
|---|---|---|
| `Open` | customer or technician files from order screen or `/help` | `InReview` |
| `InReview` | admin picks it up from `/admin/disputes` | `ResolvedRefund`, `ResolvedUpheld`, `Escalated` |
| `ResolvedRefund` | admin refunds | order → `Refunded` |
| `ResolvedUpheld` | admin sides with technician | order stays `Paid` |
| `Escalated` | requires manual/legal action | terminal-for-app |

*Not implemented.*
