---
role: orchestrator
split_eligible: true
split_reason: deadline-overrun
split_source_role: fixer
split_source_handler_timeout: 7200
split_orchestration: retire-gardener-clone-alias-verify-deploy-reaper-retry-20261006-split
reposted_by: reaper:endolin-garden2-5bcdff64
reposted_at: 2026-10-06T19:43:16Z
---

# Deliberate overrun decomposition for `retire-gardener-clone-alias-verify-deploy-reaper-retry-20261006`

This ordinary job hit its applied 7200s handler wall once without productive progress. That one deterministic overrun is sufficient cause to split; do **not** continue implementing the original work in this claim.

Read `roles/orchestrator/AGENT.md` and `skills/orchestration/SKILL.md`. Your first and only substantive act is to decide whether the original work genuinely decomposes, then use the existing journal primitives:

- **Divisible:** create at least two self-contained child jobs, park every child with `post-plan.sh --orchestrated --orchestrated-by retire-gardener-clone-alias-verify-deploy-reaper-retry-20261006-split`, then record `retire-gardener-clone-alias-verify-deploy-reaper-retry-20261006-split` with `post-orchestration.sh`.
- **Indivisible:** choose a concrete reason and a timeout strictly greater than 7200 and no greater than 14339; park exactly one child with `post-plan.sh --orchestrated --orchestrated-by retire-gardener-clone-alias-verify-deploy-reaper-retry-20261006-split --split-indivisible-reason REASON --split-indivisible-handler-timeout SECONDS retire-gardener-clone-alias-verify-deploy-reaper-retry-20261006-expanded-window BODY-FILE` so both child fields land atomically. Record the same reason as `split-indivisible-reason:` and the same timeout as `split-indivisible-handler-timeout:` in the orchestration description, then record the single-child orchestration. Do not hand-author the child fields; a generic "too large" assertion is not a reason.
- In either case, finish only after the parked child set and orchestration record exist durably. Declare the exact handoff `<<<GARDEN-JOB-HANDED-OFF: retire-gardener-clone-alias-verify-deploy-reaper-retry-20261006-split>>>` immediately before the completion signal so completion verifies the successor.
- Do not apply this split protocol to any gauntlet stage; gauntlet retries belong exclusively to its driver.

## Original job specification

---
arc: garden-upkeep
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Fixer on kriscendobot/garden (main2): do the last unfinished regression check for 70b6d1e3d42, the commit that retired the GARDEN_GARDENER_CLONE alias. It is the only sibling not yet in tada; the parked `retire-gardener-clone-alias-verify-deploy-reaper` was doomed after two transient timeouts. Run the deploy-garden, reaper-requeue-cap, reaper-live-handler-guard, reaper-doom-park, deadline-nudge and fetch-timeout suites with a scrubbed env (`env -i HOME=$HOME PATH=$PATH TMPDIR=$TMPDIR GARDEN_TEST=1`), diff their FAIL lines against an extract of 70b6d1e3d42^, fix and land only failures that the commit caused, and withdraw the doomed plan entry. fetch-timeout takes over 15 minutes, so run it detached with a long timeout.
