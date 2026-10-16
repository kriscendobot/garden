---
role: orchestrator
split_eligible: true
split_reason: deadline-overrun
split_source_role: ordinary
split_source_handler_timeout: 2400
split_orchestration: improve-comment-source-timeout-not-fatal-split
reposted_by: reaper:endolin-garden-ece02cb4
reposted_at: 2026-10-16T01:23:21Z
---

# Deliberate overrun decomposition for `improve-comment-source-timeout-not-fatal`

This ordinary job hit its applied 2400s handler wall once without productive progress. That one deterministic overrun is sufficient cause to split; do **not** continue implementing the original work in this claim.

Read `roles/orchestrator/AGENT.md` and `skills/orchestration/SKILL.md`. Your first and only substantive act is to decide whether the original work genuinely decomposes, then use the existing journal primitives:

- **Divisible:** create at least two self-contained child jobs, declare each child execution budget with `--role`, leading `role:` / `handler-budget-role:`, or a positive `handler-timeout:`, park every child with `post-plan.sh --orchestrated --orchestrated-by improve-comment-source-timeout-not-fatal-split`, then record `improve-comment-source-timeout-not-fatal-split` with `post-orchestration.sh`.
- **Indivisible:** choose a concrete reason and a timeout strictly greater than 2400 and no greater than 14339; park exactly one child with `post-plan.sh --orchestrated --orchestrated-by improve-comment-source-timeout-not-fatal-split --split-indivisible-reason REASON --split-indivisible-handler-timeout SECONDS improve-comment-source-timeout-not-fatal-expanded-window BODY-FILE` so both child fields land atomically. Record the same reason as `split-indivisible-reason:` and the same timeout as `split-indivisible-handler-timeout:` in the orchestration description, then record the single-child orchestration. Do not hand-author the child fields; a generic "too large" assertion is not a reason.
- In either case, finish only after the parked child set and orchestration record exist durably. Declare the exact handoff `<<<GARDEN-JOB-HANDED-OFF: improve-comment-source-timeout-not-fatal-split>>>` immediately before the completion signal so completion verifies the successor.
- Do not apply this split protocol to any gauntlet stage; gauntlet retries belong exclusively to its driver.

## Original job specification

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/comment-watcher.sh
The comment source's `gh api .../pulls?state=open...` call timed out (rc=124) at 18:28:35 and was logged as "definitive; not retrying". The watcher then died with FATAL rc=1 (18:28:44), which left `garden-comment-watcher@kriscendobot-garden.service` in a failed state. A timeout says nothing about the repo, so it should not be treated as definitive. Classify rc=124 as transient: retry once with backoff, and if it still fails, log a WARN and exit 0 with the cursor frozen. That matches how the rc=75 quota path behaves. This stops the failed-unit noise and the extra mentor and self-heal work it triggers.
