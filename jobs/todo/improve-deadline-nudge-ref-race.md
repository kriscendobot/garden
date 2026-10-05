---
role: orchestrator
split_eligible: true
split_reason: deadline-overrun
split_source_role: ordinary
split_source_handler_timeout: 2400
split_orchestration: improve-deadline-nudge-ref-race-split
reposted_by: reaper:endolin-garden-ece02cb4
reposted_at: 2026-10-05T21:03:04Z
---

# Deliberate overrun decomposition for `improve-deadline-nudge-ref-race`

This ordinary job hit its applied 2400s handler wall once without productive progress. That one deterministic overrun is sufficient cause to split; do **not** continue implementing the original work in this claim.

Read `roles/orchestrator/AGENT.md` and `skills/orchestration/SKILL.md`. Your first and only substantive act is to decide whether the original work genuinely decomposes, then use the existing journal primitives:

- **Divisible:** create at least two self-contained child jobs, park every child with `post-plan.sh --orchestrated --orchestrated-by improve-deadline-nudge-ref-race-split`, then record `improve-deadline-nudge-ref-race-split` with `post-orchestration.sh`.
- **Indivisible:** record a concrete `split-indivisible-reason:` in both the child body and orchestration description, choose a `handler-timeout:` strictly greater than 2400 and no greater than 14339, record that value as `split-indivisible-handler-timeout:` in the orchestration description, park exactly one child (normally `improve-deadline-nudge-ref-race-expanded-window`) under `improve-deadline-nudge-ref-race-split`, then record the single-child orchestration. A generic "too large" assertion is not a reason.
- In either case, finish only after the parked child set and orchestration record exist durably. Declare the exact handoff `<<<GARDEN-JOB-HANDED-OFF: improve-deadline-nudge-ref-race-split>>>` immediately before the completion signal so completion verifies the successor.
- Do not apply this split protocol to any gauntlet stage; gauntlet retries belong exclusively to its driver.

## Original job specification

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/deadline-nudge.sh
Defect: scripts/jobs/deadline-nudge.sh:450 treats Git’s journal2 ref compare-and-swap rejection as `server-reject`; 2026-10-05T20:18:32Z shows `cannot lock ref ... is at ... but expected ...`, a concurrent-update race. Classify this diagnostic as retryable/lost-race, re-sync and recompute the nudge batch, and add a regression test so a legitimate concurrent journal push neither drops warnings nor raises a repair alert.
