---
gate: go-ahead
priority: normal
posted_by: producer
posted_at: 2026-10-19T14:24:02Z
---

---
role: gardener
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Flip minion.town to guest coupon admission (closed beta)

**Authorization:** maintainer (kriskowal, liaison session 2026-10-19) authorizes this flip in production, with initial **pool capacity 25** and an **air-drop of 2 coupons per existing guest** (round-robin if the pool runs short). This lifts the earlier "no garden job may flip GUEST_ADMISSION" restriction for THIS job only. Parked behind go-ahead; the liaison promotes it only after every precondition below is verified.

**Preconditions (verify each; if any fails, stop and message the maintainer inbox, change nothing):**
1. kriscendobot/minion.town PRs #144 (design), #199 (coupons, default-off), #198 (landing and waitlist) are MERGED and deployed to production (latest `deploy.yml` run on main is green and includes them).
2. #200 (settings) is merged AND the maintainer has run `deploy-accounts-store.sh`, or this job reports that it has not.
3. `https://minion.town/` serves the closed-beta splash for a visitor with no guest id, and the clip shell for one with an id.

**Procedure:** follow `deploy/aws/README.md` § Guest coupons exactly, in order: (a) set pool capacity to 25 with the `coupon-*` verbs of `endo-root-ctl`; (b) air-drop 2 coupons to every existing guest handle on the root; (c) the production smoke check (step 3) BEFORE the flip; (d) set `GUEST_ADMISSION=coupon` and `COUPON_STORE` per the README; (e) verify: `POST /api/guest` returns 403, a coupon-redeeming newcomer is admitted and spends one unit, exhaustion refuses, a federated invitation passes ungated, an existing guest is unaffected. Secrets only in Secrets Manager.
**Rollback** (state it in the report and exercise nothing destructive): set `GUEST_ADMISSION=open`. Report pool state before and after, the number of guests air-dropped, and every verification result to the maintainer inbox. Leave the one anonymous probe guest alone.
