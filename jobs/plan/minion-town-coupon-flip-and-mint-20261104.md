---
gate: orchestrated
orchestrated_by: minion-town-first-users-orchestration-20261104
priority: normal
posted_by: producer
posted_at: 2026-11-05T00:00:18Z
---

---
requires: aws
role: gardener
tier: mentor
fallback-tier: minion
dispatch: automatic
---
**Flip minion.town to coupon-only admission and mint the first coupons.** Supersedes the parked `minion-town-coupon-admission-flip-20261103` (withdrawn). Authorization: maintainer kriskowal, 2026-11-04 (see the journal message of that date): flip production to `GUEST_ADMISSION=coupon`; mint a pool of 25 coupons held by root; **NO air-drop to existing guests** (this differs from the old job); the maintainer hands the coupons out himself.

Preconditions (verify; if any fails, stop, message the maintainer inbox, change nothing): #199 is merged and deployed (latest `deploy.yml` on main green, includes it); `https://minion.town/` serves the closed-beta splash for a visitor with no guest id and the clip shell for one with an id; the maintainer-run `deploy-accounts-store.sh` question from the old job is answered (report it if not done).

Procedure: follow `deploy/aws/README.md` § Guest coupons in order: set pool capacity to 25 with the `coupon-*` verbs of `endo-root-ctl`; run the production smoke check BEFORE the flip; set `GUEST_ADMISSION=coupon` and `COUPON_STORE`; verify `POST /api/guest` returns 403, a coupon-redeeming newcomer is admitted and spends one unit, exhaustion refuses, and a federated invitation passes. Then produce the 25 redeemable coupon URLs/strings as the design specifies and store them where only the maintainer can read them (a secret in AWS Secrets Manager or a maintainer-only inbox message; NEVER in a public repo, PR, or log), and report only the location and count. Rollback: set `GUEST_ADMISSION=open`; state it in the report. Leave the anonymous probe guest alone.

