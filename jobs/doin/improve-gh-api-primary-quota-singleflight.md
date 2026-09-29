---
role: orchestrator
split_eligible: true
split_reason: deadline-overrun
split_source_role: ordinary
split_source_handler_timeout: 2400
split_orchestration: improve-gh-api-primary-quota-singleflight-split
reposted_by: reaper:endolin-garden-ece02cb4
reposted_at: 2026-09-29T21:43:08Z
---

# Deliberate overrun decomposition for `improve-gh-api-primary-quota-singleflight`

This ordinary job hit its applied 2400s handler wall once without productive progress. That one deterministic overrun is sufficient cause to split; do **not** continue implementing the original work in this claim.

Read `roles/orchestrator/AGENT.md` and `skills/orchestration/SKILL.md`. Your first and only substantive act is to decide whether the original work genuinely decomposes, then use the existing journal primitives:

- **Divisible:** create at least two self-contained child jobs, park every child with `post-plan.sh --orchestrated --orchestrated-by improve-gh-api-primary-quota-singleflight-split`, then record `improve-gh-api-primary-quota-singleflight-split` with `post-orchestration.sh`.
- **Indivisible:** record a concrete `split-indivisible-reason:` in both the child body and orchestration description, choose a `handler-timeout:` strictly greater than 2400 and no greater than 14339, record that value as `split-indivisible-handler-timeout:` in the orchestration description, park exactly one child (normally `improve-gh-api-primary-quota-singleflight-expanded-window`) under `improve-gh-api-primary-quota-singleflight-split`, then record the single-child orchestration. A generic "too large" assertion is not a reason.
- In either case, finish only after the parked child set and orchestration record exist durably. Declare the exact handoff `<<<GARDEN-JOB-HANDED-OFF: improve-gh-api-primary-quota-singleflight-split>>>` immediately before the completion signal so completion verifies the successor.
- Do not apply this split protocol to any gauntlet stage; gauntlet retries belong exclusively to its driver.

## Original job specification

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/common.sh
scripts/jobs/common.sh:5451 lets concurrent REST calls pass before the primary-quota latch is written; at 19:35:34–19:35:35 two comment sources were refused. Serialize gh-api admission with the cooldown lock, re-check the all-API marker under it, and latch primary-quota failures before releasing it so sibling watchers skip without another doomed request.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-29T21:54:47Z
