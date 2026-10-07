---
role: orchestrator
split_eligible: true
split_reason: deadline-overrun
split_source_role: ordinary
split_source_handler_timeout: 2400
split_orchestration: improve-journal-deepen-retry-split
reposted_by: reaper:endolin-garden2-5bcdff64
reposted_at: 2026-10-07T16:33:24Z
---

# Deliberate overrun decomposition for `improve-journal-deepen-retry`

This ordinary job hit its applied 2400s handler wall once without productive progress. That one deterministic overrun is sufficient cause to split; do **not** continue implementing the original work in this claim.

Read `roles/orchestrator/AGENT.md` and `skills/orchestration/SKILL.md`. Your first and only substantive act is to decide whether the original work genuinely decomposes, then use the existing journal primitives:

- **Divisible:** create at least two self-contained child jobs, park every child with `post-plan.sh --orchestrated --orchestrated-by improve-journal-deepen-retry-split`, then record `improve-journal-deepen-retry-split` with `post-orchestration.sh`.
- **Indivisible:** choose a concrete reason and a timeout strictly greater than 2400 and no greater than 14339; park exactly one child with `post-plan.sh --orchestrated --orchestrated-by improve-journal-deepen-retry-split --split-indivisible-reason REASON --split-indivisible-handler-timeout SECONDS improve-journal-deepen-retry-expanded-window BODY-FILE` so both child fields land atomically. Record the same reason as `split-indivisible-reason:` and the same timeout as `split-indivisible-handler-timeout:` in the orchestration description, then record the single-child orchestration. Do not hand-author the child fields; a generic "too large" assertion is not a reason.
- In either case, finish only after the parked child set and orchestration record exist durably. Declare the exact handoff `<<<GARDEN-JOB-HANDED-OFF: improve-journal-deepen-retry-split>>>` immediately before the completion signal so completion verifies the successor.
- Do not apply this split protocol to any gauntlet stage; gauntlet retries belong exclusively to its driver.

## Original job specification

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/common.sh
scripts/jobs/common.sh:5086 performs one local `--unshallow` fetch, then leaves readers shallow after the 2026-10-07T14:53:23Z failure. Add bounded, jittered retries for transient root-repository lock/contention failures before retaining the existing shallow fallback, and log the final Git diagnostic.
