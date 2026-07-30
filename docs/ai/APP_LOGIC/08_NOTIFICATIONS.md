# 08 — Notifications

The `/notifications` screen displays a static feed. No actual dispatcher exists. The following table is the required notification matrix.

Channels: **push** (mobile), **in_app** (feed), **email**, **sms**. Every event should fan out to the channels marked.

---

## Customer-side

| Event | Trigger | Channels | Message (example) |
|---|---|---|---|
| OTP code | `POST /auth/register` or resend | sms | "Your ELService code is 482145. Expires in 5 min." |
| Password reset | forgot-password request | email | "Reset your ELService password" (link) |
| Order created | `orders.status → searching` | in_app, push | "We're finding a technician for your fridge repair." |
| First offer received | first `offers.status = submitted` | push, in_app | "You have a new offer — 18 500 ₸, arrives in 25 min." |
| More offers | subsequent offers within 60 s | in_app only | "2 more offers received." |
| No offers timeout | `orders.status → expired` | push, in_app | "No technicians available. Try changing time slot." |
| Offer accepted (self) | customer accepts | in_app | "Dmitry Volkov accepted. Track your order." |
| Technician en route | tech marks `en_route` | push, in_app | "Dmitry is on the way — ETA 20 min." |
| Technician arrived | tech marks `arrived` | push, in_app | "Your technician has arrived." |
| Job in progress | `in_progress` | in_app | "Repair started." |
| Job completed | `completed` | push, in_app | "Repair complete. Please review the invoice." |
| Payment succeeded | `payments.status = succeeded` | push, in_app, email (receipt) | "Payment of 18 500 ₸ received. Receipt attached." |
| Payment failed | `payments.status = failed` | push, in_app | "Payment failed — please try another method." |
| Review reminder | 1 h after `paid` if no review | push | "How was your experience with Dmitry?" |
| Order cancelled by tech | tech cancels | push, sms | "Your technician cancelled. Choose another offer." |
| Refund issued | admin refunds | push, email | "Refund of 18 500 ₸ issued to your card." |
| Dispute update | admin action on dispute | push, in_app, email | "Your dispute was resolved." |
| Chat message | `POST /chats/:id/messages` while app backgrounded | push | Sender name + preview |
| Broadcast (marketing) | admin sends broadcast | push (if opted in), in_app | Custom |

## Technician-side

| Event | Trigger | Channels | Message |
|---|---|---|---|
| New request nearby | order matches tech and is `searching` | push, in_app | "New refrigerator job · 3.2 km · Est. 15 000–25 000 ₸" |
| Offer accepted | customer accepts your offer | push, in_app | "Aigerim accepted your offer. Head to Respublika Ave 14." |
| Offer declined | customer picked another | in_app | — |
| Offer expired | request TTL elapsed | in_app | — |
| Customer cancelled | customer cancels post-accept | push, in_app | "Order cancelled by customer." |
| Payment received | `paid` | push, in_app | "You earned 18 500 ₸ — added to wallet." |
| Withdrawal paid | withdrawal.status = paid | push, email | — |
| New review | `reviews` INSERT | push, in_app | "Aigerim rated you 5 stars." |
| Verification decision | admin approves/rejects | push, email, in_app | — |
| Availability reminder | daily 08:00 local if `is_online = false` | push (opt-in) | "Turn on availability to receive requests." |
| Dispute filed on your order | dispute created | push, email | — |

## Admin-side

| Event | Trigger | Channels |
|---|---|---|
| New dispute filed | `disputes` INSERT | in_app (admin console badge), email |
| Technician verification pending | `technician_profiles.verification = under_review` | in_app |
| Payment webhook failure | gateway webhook error | email |
| Unusual activity (KPI thresholds) | server rule | email |

---

## Rules

- **Deduplication:** within 30 s window, collapse repeat events by (user, event_type, order_id).
- **Quiet hours:** customer push disabled 23:00–07:00 unless order state ∈ {`en_route`,`arrived`}.
- **Preferences:** each user has notification_preferences with per-channel + per-category toggles. `/settings` "Push notifications" toggle is the master switch.
- **Opt-in required** for marketing/broadcast. Transactional notifications are non-opt-out.
- **Localisation:** message templates keyed by `locale` from `users.locale`.
- **Delivery:** push via FCM/APNs, SMS via provider, email via provider; retries with exponential backoff on transient errors; hard bounces disable the channel for that user.
- **Storage:** every dispatched notification writes a row in `notifications` for the in_app feed regardless of channel.
