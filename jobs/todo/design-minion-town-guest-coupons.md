---
role: designer
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Design: guest-account coupons carried by invitations (minion.town growth governance)

Repo: kriscendobot/minion.town (primary). The daemon hook, if one is needed, goes in endojs/endo-but-for-bots against base `llm`.
Origin: kriskowal's review of endojs/endo-but-for-bots#1116 (guest-native invitations), inline comment
https://github.com/endojs/endo-but-for-bots/pull/1116#discussion_r4140186381 (Open Question 6, rate limiting).
That design does NOT depend on this work. It is a separate follow-up.

Maintainer intent (paraphrased from the review):
- An invitation can also carry the formula identifier of a **coupon**: a capability to create a new minion.town guest.
  If the accepter has no agent, they can redeem the coupon to get a minion.town guest account and accept the invitation from it.
  An accepter who accepts on another federated instance, with a Familiar, or with their own pet daemon does not need to use the coupon.
- The root account holds a **growable pool of coupons** for guest accounts.
  They can be given to minion.town users, for example by an air-drop that sends each guest a coupon book (a directory or set formula of coupons) in a message.
- Coupons **expire**, so unused ones return to the pool.
- Purpose: minion.town operators can limit growth to the scale they are ready to handle.

Design the coupon formula, the pool, the air-drop, expiry and return, how an invitation carries a coupon, and how redeeming a coupon provisions a guest.
The newcomer-provisioning path is described in designs/guest-native-invitations.md § 2 *Onboarding a newcomer*.
Say which parts need daemon support (for example, an invitation that carries an extra formula identifier) and which are minion.town-only.
Open the design as a DRAFT PR through ensure-pr.sh.

<!-- garden-reaped: 1 -->
<!-- garden-plain-retry-not-before: 2026-09-30T05:23:04Z -->
