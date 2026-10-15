---
role: orchestrator
split_eligible: true
split_reason: deadline-overrun
split_source_role: ordinary
split_source_handler_timeout: 2400
split_orchestration: endojs-endo-but-for-bots-pr1394-shepherd-20261015-split
reposted_by: reaper:endolin-garden-ece02cb4
reposted_at: 2026-10-15T17:23:21Z
---

# Deliberate overrun decomposition for `endojs-endo-but-for-bots-pr1394-shepherd-20261015`

This ordinary job hit its applied 2400s handler wall once without productive progress. That one deterministic overrun is sufficient cause to split; do **not** continue implementing the original work in this claim.

Read `roles/orchestrator/AGENT.md` and `skills/orchestration/SKILL.md`. Your first and only substantive act is to decide whether the original work genuinely decomposes, then use the existing journal primitives:

- **Divisible:** create at least two self-contained child jobs, declare each child execution budget with `--role`, leading `role:` / `handler-budget-role:`, or a positive `handler-timeout:`, park every child with `post-plan.sh --orchestrated --orchestrated-by endojs-endo-but-for-bots-pr1394-shepherd-20261015-split`, then record `endojs-endo-but-for-bots-pr1394-shepherd-20261015-split` with `post-orchestration.sh`.
- **Indivisible:** choose a concrete reason and a timeout strictly greater than 2400 and no greater than 14339; park exactly one child with `post-plan.sh --orchestrated --orchestrated-by endojs-endo-but-for-bots-pr1394-shepherd-20261015-split --split-indivisible-reason REASON --split-indivisible-handler-timeout SECONDS endojs-endo-but-for-bots-pr1394-shepherd-20261015-expanded-window BODY-FILE` so both child fields land atomically. Record the same reason as `split-indivisible-reason:` and the same timeout as `split-indivisible-handler-timeout:` in the orchestration description, then record the single-child orchestration. Do not hand-author the child fields; a generic "too large" assertion is not a reason.
- In either case, finish only after the parked child set and orchestration record exist durably. Declare the exact handoff `<<<GARDEN-JOB-HANDED-OFF: endojs-endo-but-for-bots-pr1394-shepherd-20261015-split>>>` immediately before the completion signal so completion verifies the successor.
- Do not apply this split protocol to any gauntlet stage; gauntlet retries belong exclusively to its driver.

## Original job specification

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Wear the shepherd role. Drive CI green on https://github.com/endojs/endo-but-for-bots/pull/1394 (head build/sturdyref-captp-wire, base build/sturdyref-marshal-representation-6976bb0). The predecessor restack job rebased it, fixed the TS6307 composite-build failure, and fixed package uniformity (renamed the ocapn declarations to *.types.d.ts). Remaining failures from earlier runs (viable-release smoke publish, test, cover, matrix.check, compare/format-ironhorse, test-async-hooks) may have cascaded from the declaration build; triage whatever is still red on the latest head. Do not rebase or change the base.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-15T18:09:38Z
