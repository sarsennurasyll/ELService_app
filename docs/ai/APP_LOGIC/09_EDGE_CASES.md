# 09 — Edge Cases

Failure and boundary situations the app must handle. None are handled in the current codebase.

---

## Discovery / matching

- **No technicians online in the area.** After request TTL (e.g. 5 min) with zero offers → order → `expired`. Show `/order/waiting` empty state with CTAs: change slot, expand radius, notify me when available.
- **Only one offer, priced above estimate.** Show warning banner on `/order/offers`.
- **All offers withdrawn before customer picks.** Auto-return order to `searching`; keep waiting.
- **Customer never opens offers list.** Silent auto-expire after 30 min → `expired`.

## Order creation

- **Duplicate submission.** Same customer submits identical order twice within 60 s → server dedupes by `(customer_id, category, address, slot)` hash, returns existing order.
- **Address outside service area.** Reject with `TECHNICIAN_UNAVAILABLE`, suggest waitlist.
- **Slot in the past.** Reject with `VALIDATION` (`scheduledFor.date`).
- **Overlapping active order.** Warn customer they already have one in the same slot.

## Payment

- **Card declined.** `payments.status = failed`; keep order in `completed`, allow retry with different method.
- **3-DS challenge cancelled.** `failed`; retry.
- **Partial payment / not enough balance.** Show clear error, do not consume attempt count.
- **Duplicate pay tap.** Idempotency key on `POST /orders/:id/payment`.
- **Gateway webhook late.** Poll status; reconcile via cron.
- **Cash payment reconciliation.** Technician marks cash-collected; admin can dispute.

## Technician actions

- **Technician cancels after accept.** Order → `searching` again if within grace period; strike counted against technician.
- **Technician goes offline mid-job.** Show "connection lost" banner in `/tracking/$id`; keep timer via server clock; auto-timeout after 15 min triggers admin alert.
- **Late arrival.** If `en_route` for > 2× ETA and not yet `arrived`, push customer with option to cancel penalty-free.
- **Job never marked complete.** After scheduled slot end + N hours, auto-open dispute (`disputes.status = open`).

## Customer actions

- **Customer cancels post-accept.** If cancel < 1 h before slot, apply cancellation fee (platform setting).
- **Customer unreachable at address.** Technician taps "customer no-show" after wait timer → job billed as visit fee.

## Payments — refunds

- **Refund larger than payment.** Reject.
- **Refund after chargeback.** Reject; escalate to admin.

## Reviews

- **Review submitted before payment succeeded.** Reject.
- **Attempt to re-review.** Reject with 409.
- **Abusive review content.** Admin can hide via `/admin/disputes`; original still stored.

## Chat

- **Message sent after order terminal state.** Reject with 403.
- **Photo too large.** Reject, show inline error.
- **Message arrives while chat closed.** Push notification + in-app badge.

## Session / auth

- **Expired access token.** Silent refresh via refresh token; if refresh also expired → redirect to `/login`.
- **Concurrent sessions on multiple devices.** Allowed; logout from one device does not affect others unless "log out everywhere" chosen.
- **OTP brute force.** Lock account after 5 wrong codes for 15 min.
- **Password reset link reuse.** Single-use; second use returns `TOKEN_EXPIRED`.

## Network / device

- **Offline.** Show global offline banner; queue non-critical writes (chat messages) locally; disable "Find technician" and "Pay" while offline.
- **Slow network.** Show skeleton loaders on lists (currently **Not implemented**); optimistic UI on status marks with rollback on server error.
- **App backgrounded mid-payment.** Resume from `/payment/$id` on foreground with server-authoritative status.
- **Push permission denied.** Fall back to in-app + SMS for critical events.
- **Location permission denied.** Address flow requires manual entry; matching still works.

## Data integrity

- **Attempt to accept an already-accepted offer.** 409 `CONFLICT`.
- **Race between two customers on the same tech slot.** Row-level lock on `offers.status = accepted` transition.
- **Category deleted while order draft references it.** Soft-delete categories only; mark `active = false`, keep FK valid.

## Admin

- **Simultaneous admins editing same dispute.** Optimistic concurrency via `updated_at`; second save rejected.
- **Broadcast to zero recipients.** Reject.
- **Refund without associated payment.** Reject.

## Localisation / currency

- **Unsupported locale in `users.locale`.** Fall back to `en`.
- **Prices displayed in ₸ (KZT) only** in mockups; adding currencies requires FX conversion — **Not implemented.**

## Time zones

- All timestamps stored UTC; displayed in user's device time zone. Scheduled slots stored with the address's local time zone to survive DST.
