---
role: gardener
tier: mentor
posted_at: 2026-11-05T00:00:18Z
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-11-05T00:06:42Z cleared=none -->

---
role: gardener
tier: mentor
fallback-tier: minion
dispatch: automatic
---
**Land kriscendobot/minion.town#199 (guest coupons, default-off).** The previous conduct (`kriscendobot-minion.town-pr199-conduct-20261103`) stalled: the gauntlet ended `review-budget-reached` and fix-6 (head 859e7eb8, a 30-attempts-per-network-per-hour redemption throttle, a 3-day attachment hold, a ledger recipient digest, and a refusal to deliver to a re-held name) never got a panel. Maintainer (kriskowal, 2026-11-04) authorized the coupon flip but not unreviewed behavior in a production auth gate, so: (1) resume the gauntlet at the panel with extra rounds (`scripts/jobs/gauntlet.sh --resume-from-stage kriscendobot-minion.town-pr199-gauntlet-20261103 panel --add-rounds 2`) and let it converge on the live head; (2) once the panel is clean and CI is green, un-draft and merge #199 (kriskowal's APPROVED review on 085c7445 stands, the maintainer approves from the liaison session; per the review-inversion order do not re-ask for per-PR review); (3) confirm the production deploy of main is green and includes #199. If the panel still demands changes after the added rounds, stop and report the must-fix list instead of merging. Then ensure `build-minion-town-guest-coupons-phase1-rest` is promoted. See the authorization message in the journal entries dated 2026-11-04.


<!-- garden-deadline-overrun: 1 -->
<!-- garden-reap-now -->
---
claim:
  host: oros-studio-garden-ce242c49
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-11-05T00:28:39Z
