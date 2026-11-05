---
role: orchestrator
split_eligible: true
split_reason: deadline-overrun
split_source_role: gardener
split_source_handler_timeout: 2400
split_orchestration: kriscendobot-minion.town-pr199-land-20261104-split
reposted_by: reaper:endolin-garden-ece02cb4
reposted_at: 2026-11-05T01:13:38Z
---

# Deliberate overrun decomposition for `kriscendobot-minion.town-pr199-land-20261104`

This ordinary job hit its applied 2400s handler wall once without productive progress. That one deterministic overrun is sufficient cause to split; do **not** continue implementing the original work in this claim.

Read `roles/orchestrator/AGENT.md` and `skills/orchestration/SKILL.md`. Your first and only substantive act is to decide whether the original work genuinely decomposes, then use the existing journal primitives:

- **Divisible:** create at least two self-contained child jobs, declare each child execution budget with `--role`, leading `role:` / `handler-budget-role:`, or a positive `handler-timeout:`, park every child with `post-plan.sh --orchestrated --orchestrated-by kriscendobot-minion.town-pr199-land-20261104-split`, then record `kriscendobot-minion.town-pr199-land-20261104-split` with `post-orchestration.sh`.
- **Indivisible:** choose a concrete reason and a timeout strictly greater than 2400 and no greater than 14339; park exactly one child with `post-plan.sh --orchestrated --orchestrated-by kriscendobot-minion.town-pr199-land-20261104-split --split-indivisible-reason REASON --split-indivisible-handler-timeout SECONDS kriscendobot-minion.town-pr199-land-20261104-expanded-window BODY-FILE` so both child fields land atomically. Record the same reason as `split-indivisible-reason:` and the same timeout as `split-indivisible-handler-timeout:` in the orchestration description, then record the single-child orchestration. Do not hand-author the child fields; a generic "too large" assertion is not a reason.
- In either case, finish only after the parked child set and orchestration record exist durably. Declare the exact handoff `<<<GARDEN-JOB-HANDED-OFF: kriscendobot-minion.town-pr199-land-20261104-split>>>` immediately before the completion signal so completion verifies the successor.
- Do not apply this split protocol to any gauntlet stage; gauntlet retries belong exclusively to its driver.

## Original job specification

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

---
claim:
  host: oros-studio-garden-ce242c49
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-11-05T01:14:35Z
