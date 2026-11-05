---
withdrawn: true
withdrawn_reason: superseded by minion-town-coupon-flip-and-mint-20261104 (maintainer 2026-11-04: no air-drop; panel the unreviewed fix-6 first)
withdrawn_by: producer
withdrawn_at: 2026-11-05T00:00:23Z
withdrawn_from_gate: blocked-failed
---

---
gate: blocked-failed
blocked_failed_reason: blocker 'kriscendobot-minion.town-pr199-conduct-20261103' completed but declined its gated outcome; held for a human decision
blocked_on: kriscendobot-minion.town-pr199-conduct-20261103
priority: normal
posted_by: gardener
posted_at: 2026-11-03T06:04:44Z
---

---
requires: aws
role: gardener
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Flip minion.town to guest coupon admission (closed beta)

**Authorization:** maintainer (kriskowal, liaison session 2026-10-19) authorized this flip in production, with initial **pool capacity 25** and an **air-drop of 2 coupons per existing guest** (round-robin if the pool runs short). kriskowal gave the go-ahead on 2026-11-03, "I would like this feature enabled": https://github.com/kriscendobot/minion.town/pull/199#pullrequestreview-5747577467. This job succeeds the parked `minion-town-coupon-admission-flip-20261019`, and lifts the earlier "no garden job may flip GUEST_ADMISSION" restriction for THIS job only. It runs only after conductor job `kriscendobot-minion.town-pr199-conduct-20261103` merges #199.

**Preconditions (verify each; if any fails, stop and message the maintainer inbox, change nothing):**
1. kriscendobot/minion.town PRs #144 (design), #199 (coupons, default-off), #198 (landing and waitlist) are MERGED and deployed to production (latest `deploy.yml` run on main is green and includes them).
2. #200 (settings) is merged AND the maintainer has run `deploy-accounts-store.sh`, or this job reports that it has not.
3. `https://minion.town/` serves the closed-beta splash for a visitor with no guest id, and the clip shell for one with an id.

**Procedure:** follow `deploy/aws/README.md` § Guest coupons exactly, in order: (a) set pool capacity to 25 with the `coupon-*` verbs of `endo-root-ctl`; (b) air-drop 2 coupons to every existing guest handle on the root; (c) the production smoke check (step 3) BEFORE the flip; (d) set `GUEST_ADMISSION=coupon` and `COUPON_STORE` per the README; (e) verify: `POST /api/guest` returns 403, a coupon-redeeming newcomer is admitted and spends one unit, exhaustion refuses, a federated invitation passes ungated, an existing guest is unaffected. Secrets only in Secrets Manager.
**Rollback** (state it in the report and exercise nothing destructive): set `GUEST_ADMISSION=open`. Report pool state before and after, the number of guests air-dropped, and every verification result to the maintainer inbox. Leave the one anonymous probe guest alone.
