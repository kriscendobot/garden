---
role: orchestrator
split_eligible: true
split_reason: deadline-overrun
split_source_role: builder
split_source_handler_timeout: 7200
split_orchestration: build-daemon-rename-to-manager-split
reposted_by: reaper:endolin-garden-ece02cb4
reposted_at: 2026-10-31T15:03:18Z
---

# Deliberate overrun decomposition for `build-daemon-rename-to-manager`

This ordinary job hit its applied 7200s handler wall once without productive progress. That one deterministic overrun is sufficient cause to split; do **not** continue implementing the original work in this claim.

Read `roles/orchestrator/AGENT.md` and `skills/orchestration/SKILL.md`. Your first and only substantive act is to decide whether the original work genuinely decomposes, then use the existing journal primitives:

- **Divisible:** create at least two self-contained child jobs, declare each child execution budget with `--role`, leading `role:` / `handler-budget-role:`, or a positive `handler-timeout:`, park every child with `post-plan.sh --orchestrated --orchestrated-by build-daemon-rename-to-manager-split`, then record `build-daemon-rename-to-manager-split` with `post-orchestration.sh`.
- **Indivisible:** choose a concrete reason and a timeout strictly greater than 7200 and no greater than 14339; park exactly one child with `post-plan.sh --orchestrated --orchestrated-by build-daemon-rename-to-manager-split --split-indivisible-reason REASON --split-indivisible-handler-timeout SECONDS build-daemon-rename-to-manager-expanded-window BODY-FILE` so both child fields land atomically. Record the same reason as `split-indivisible-reason:` and the same timeout as `split-indivisible-handler-timeout:` in the orchestration description, then record the single-child orchestration. Do not hand-author the child fields; a generic "too large" assertion is not a reason.
- In either case, finish only after the parked child set and orchestration record exist durably. Declare the exact handoff `<<<GARDEN-JOB-HANDED-OFF: build-daemon-rename-to-manager-split>>>` immediately before the completion signal so completion verifies the successor.
- Do not apply this split protocol to any gauntlet stage; gauntlet retries belong exclusively to its driver.

## Original job specification

---
posted_at: 2026-10-31T12:51:33Z
arc: unallocated
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Build `daemon-rename-to-manager` in endojs/endo-but-for-bots on a fresh `llm`-based branch, implementing the design’s Daemon/Mignonic-to-Manager/Worker rename as a mergeable draft PR.
