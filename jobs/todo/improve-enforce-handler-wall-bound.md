---
role: orchestrator
split_eligible: true
split_reason: deadline-overrun
split_source_role: ordinary
split_source_handler_timeout: 2400
split_orchestration: improve-enforce-handler-wall-bound-split
reposted_by: reaper:endolin-garden-ece02cb4
reposted_at: 2026-10-27T15:03:33Z
---

# Deliberate overrun decomposition for `improve-enforce-handler-wall-bound`

This ordinary job hit its applied 2400s handler wall once without productive progress. That one deterministic overrun is sufficient cause to split; do **not** continue implementing the original work in this claim.

Read `roles/orchestrator/AGENT.md` and `skills/orchestration/SKILL.md`. Your first and only substantive act is to decide whether the original work genuinely decomposes, then use the existing journal primitives:

- **Divisible:** create at least two self-contained child jobs, declare each child execution budget with `--role`, leading `role:` / `handler-budget-role:`, or a positive `handler-timeout:`, park every child with `post-plan.sh --orchestrated --orchestrated-by improve-enforce-handler-wall-bound-split`, then record `improve-enforce-handler-wall-bound-split` with `post-orchestration.sh`.
- **Indivisible:** choose a concrete reason and a timeout strictly greater than 2400 and no greater than 14339; park exactly one child with `post-plan.sh --orchestrated --orchestrated-by improve-enforce-handler-wall-bound-split --split-indivisible-reason REASON --split-indivisible-handler-timeout SECONDS improve-enforce-handler-wall-bound-expanded-window BODY-FILE` so both child fields land atomically. Record the same reason as `split-indivisible-reason:` and the same timeout as `split-indivisible-handler-timeout:` in the orchestration description, then record the single-child orchestration. Do not hand-author the child fields; a generic "too large" assertion is not a reason.
- In either case, finish only after the parked child set and orchestration record exist durably. Declare the exact handoff `<<<GARDEN-JOB-HANDED-OFF: improve-enforce-handler-wall-bound-split>>>` immediately before the completion signal so completion verifies the successor.
- Do not apply this split protocol to any gauntlet stage; gauntlet retries belong exclusively to its driver.

## Original job specification

---
posted_at: 2026-10-27T14:20:49Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/gardener.sh
scripts/jobs/gardener.sh:131-140 promises a handler cannot exceed its budget plus 60s, but the 2026-10-27T14:04:07Z progress entry records a 7,200s-budget handler lasting 10,265s. Harden the watchdog fail-closed path so an overdue handler that remains live cannot leave the parent blocked; terminate the complete handler cgroup/tree and record watchdog evidence with the failure. Add a regression fixture that holds a descendant past TERM and asserts the gardener returns within the configured wall bound.
