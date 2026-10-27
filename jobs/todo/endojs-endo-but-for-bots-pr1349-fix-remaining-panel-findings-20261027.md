---
role: orchestrator
split_eligible: true
split_reason: deadline-overrun
split_source_role: fixer
split_source_handler_timeout: 7200
split_orchestration: endojs-endo-but-for-bots-pr1349-fix-remaining-panel-findings-20261027-split
reposted_by: reaper:endolin-garden-ece02cb4
reposted_at: 2026-10-27T14:13:09Z
---

# Deliberate overrun decomposition for `endojs-endo-but-for-bots-pr1349-fix-remaining-panel-findings-20261027`

This ordinary job hit its applied 7200s handler wall once without productive progress. That one deterministic overrun is sufficient cause to split; do **not** continue implementing the original work in this claim.

Read `roles/orchestrator/AGENT.md` and `skills/orchestration/SKILL.md`. Your first and only substantive act is to decide whether the original work genuinely decomposes, then use the existing journal primitives:

- **Divisible:** create at least two self-contained child jobs, declare each child execution budget with `--role`, leading `role:` / `handler-budget-role:`, or a positive `handler-timeout:`, park every child with `post-plan.sh --orchestrated --orchestrated-by endojs-endo-but-for-bots-pr1349-fix-remaining-panel-findings-20261027-split`, then record `endojs-endo-but-for-bots-pr1349-fix-remaining-panel-findings-20261027-split` with `post-orchestration.sh`.
- **Indivisible:** choose a concrete reason and a timeout strictly greater than 7200 and no greater than 14339; park exactly one child with `post-plan.sh --orchestrated --orchestrated-by endojs-endo-but-for-bots-pr1349-fix-remaining-panel-findings-20261027-split --split-indivisible-reason REASON --split-indivisible-handler-timeout SECONDS endojs-endo-but-for-bots-pr1349-fix-remaining-panel-findings-20261027-expanded-window BODY-FILE` so both child fields land atomically. Record the same reason as `split-indivisible-reason:` and the same timeout as `split-indivisible-handler-timeout:` in the orchestration description, then record the single-child orchestration. Do not hand-author the child fields; a generic "too large" assertion is not a reason.
- In either case, finish only after the parked child set and orchestration record exist durably. Declare the exact handoff `<<<GARDEN-JOB-HANDED-OFF: endojs-endo-but-for-bots-pr1349-fix-remaining-panel-findings-20261027-split>>>` immediately before the completion signal so completion verifies the successor.
- Do not apply this split protocol to any gauntlet stage; gauntlet retries belong exclusively to its driver.

## Original job specification

---
posted_at: 2026-10-27T10:55:24Z
arc: unallocated
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Fix `endojs/endo-but-for-bots` PR #1349 on `build/hardened-text-codecs-shim` by addressing the remaining actionable panel findings for the M2 `hardened-text-codecs-shim` design. Preserve the pending maintainer decision as unresolved and verify the resulting head.
