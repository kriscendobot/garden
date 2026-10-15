---
role: orchestrator
split_eligible: true
split_reason: deadline-overrun
split_source_role: ordinary
split_source_handler_timeout: 2400
split_orchestration: endojs-endo-but-for-bots-pr1392-parcel-restack-20261015-r5527149922-split
reposted_by: reaper:endolin-garden-ece02cb4
reposted_at: 2026-10-15T11:43:13Z
---

# Deliberate overrun decomposition for `endojs-endo-but-for-bots-pr1392-parcel-restack-20261015-r5527149922`

This ordinary job hit its applied 2400s handler wall once without productive progress. That one deterministic overrun is sufficient cause to split; do **not** continue implementing the original work in this claim.

Read `roles/orchestrator/AGENT.md` and `skills/orchestration/SKILL.md`. Your first and only substantive act is to decide whether the original work genuinely decomposes, then use the existing journal primitives:

- **Divisible:** create at least two self-contained child jobs, park every child with `post-plan.sh --orchestrated --orchestrated-by endojs-endo-but-for-bots-pr1392-parcel-restack-20261015-r5527149922-split`, then record `endojs-endo-but-for-bots-pr1392-parcel-restack-20261015-r5527149922-split` with `post-orchestration.sh`.
- **Indivisible:** choose a concrete reason and a timeout strictly greater than 2400 and no greater than 14339; park exactly one child with `post-plan.sh --orchestrated --orchestrated-by endojs-endo-but-for-bots-pr1392-parcel-restack-20261015-r5527149922-split --split-indivisible-reason REASON --split-indivisible-handler-timeout SECONDS endojs-endo-but-for-bots-pr1392-parcel-restack-20261015-r5527149922-expanded-window BODY-FILE` so both child fields land atomically. Record the same reason as `split-indivisible-reason:` and the same timeout as `split-indivisible-handler-timeout:` in the orchestration description, then record the single-child orchestration. Do not hand-author the child fields; a generic "too large" assertion is not a reason.
- In either case, finish only after the parked child set and orchestration record exist durably. Declare the exact handoff `<<<GARDEN-JOB-HANDED-OFF: endojs-endo-but-for-bots-pr1392-parcel-restack-20261015-r5527149922-split>>>` immediately before the completion signal so completion verifies the successor.
- Do not apply this split protocol to any gauntlet stage; gauntlet retries belong exclusively to its driver.

## Original job specification

---
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-10-15T08:39:04Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Reconcile and restack endojs/endo-but-for-bots PR #1392

Wear the fixer role and use the weaver procedure. Re-fetch PR #1460 and apply
its accepted Parcel design, including commit
`6973c078f6318335ec64de5ff611f77637ef4dfa` or its rebased equivalent, to the
pass-style recognition in PR #1392. Preserve the brand-check-before-remotable
ordering and the literal `'parcel'` pass style.

Restack on the current head of predecessor PR #1391 after its child finishes.
Snapshot that exact head as
`build/sturdyref-ses-accommodation-<short-sha>`, rebase only #1392's own commits
from its old frozen base onto the new one with an explicit `--onto`, honor both
parent histories in conflicts, force-push with lease, and update #1392's base.
Run affected tests and gates, drive CI green, and post the required summary.
