---
role: orchestrator
split_eligible: true
split_reason: deadline-overrun
split_source_role: ordinary
split_source_handler_timeout: 2400
split_orchestration: improve-deadline-nudge-failure-trace-split
reposted_by: reaper:endolin-garden-ece02cb4
reposted_at: 2026-09-30T00:03:05Z
---

# Deliberate overrun decomposition for `improve-deadline-nudge-failure-trace`

This ordinary job hit its applied 2400s handler wall once without productive progress. That one deterministic overrun is sufficient cause to split; do **not** continue implementing the original work in this claim.

Read `roles/orchestrator/AGENT.md` and `skills/orchestration/SKILL.md`. Your first and only substantive act is to decide whether the original work genuinely decomposes, then use the existing journal primitives:

- **Divisible:** create at least two self-contained child jobs, park every child with `post-plan.sh --orchestrated --orchestrated-by improve-deadline-nudge-failure-trace-split`, then record `improve-deadline-nudge-failure-trace-split` with `post-orchestration.sh`.
- **Indivisible:** record a concrete `split-indivisible-reason:` in both the child body and orchestration description, choose a `handler-timeout:` strictly greater than 2400 and no greater than 14339, record that value as `split-indivisible-handler-timeout:` in the orchestration description, park exactly one child (normally `improve-deadline-nudge-failure-trace-expanded-window`) under `improve-deadline-nudge-failure-trace-split`, then record the single-child orchestration. A generic "too large" assertion is not a reason.
- In either case, finish only after the parked child set and orchestration record exist durably. Declare the exact handoff `<<<GARDEN-JOB-HANDED-OFF: improve-deadline-nudge-failure-trace-split>>>` immediately before the completion signal so completion verifies the successor.
- Do not apply this split protocol to any gauntlet stage; gauntlet retries belong exclusively to its driver.

## Original job specification

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/deadline-nudge.sh
scripts/jobs/deadline-nudge.sh:495 logged only opaque `rc=1` at 2026-09-29T22:01:29, with no matching stage/trace diagnostic in the warning tail. Persist the failing stage and command in a local fault record and include it in this WARN, including failures that bypass the subshell traps, so the next tick can diagnose and harden the actual failing operation.
