---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Validate minion.town guest-coupon daemon adapter against a real Endo daemon

Follow-up to `build-minion-town-guest-coupons-closed-beta`, whose draft PR on
kriscendobot/minion.town (head `feat/guest-coupons`, title "feat(guest): closed
beta through guest coupons (default-off)") ships the coupon issuer with an
in-memory daemon stand-in only. `src/coupons/daemon-socket.ts` (bind via
`evaluate` with a result path, `makeDirectory`, `storeIdentifier`, `send` of a
book directory by path, `remove`, `provideGuest` + `identify`) has never run
against the pinned daemon.

Add a same-daemon integration test in the existing `ENDO_CHECKOUT` style
(`test/web/guest-web-daemon.test.ts`): root issues a coupon, air-drops a book to
a web guest (the guest's inbox shows the book), the coupon redeems into a
`coupon-<serial>` guest through `POST /api/guest/coupon`, and the sweep removes a
day-old terminal name. Fix any adapter defect it finds, pushing to the same PR
head as review-feedback follow-up commits. Do NOT flip `GUEST_ADMISSION` in
production.
