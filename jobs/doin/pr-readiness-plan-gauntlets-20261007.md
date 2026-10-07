---
role: fixer
tier: mentor
arc: garden-upkeep
handler-timeout: 7200
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-10-07T16:05:02Z cleared=none -->

---
role: fixer
tier: mentor
fallback-tier: minion
arc: garden-upkeep
handler-timeout: 7200
dispatch: automatic
---
**Role: fixer.** Child 2/3 of orchestration `pr-readiness-arc-plan-20261007`: **plan a budgeted gauntlet for every classified PR that has not had one.**

**Context.** On 2026-10-06 the readiness audit (`design-pr-gauntlet-coverage-audit.sh`) filed one `watchdog-pr-gauntlet-readiness-<repo>-pr<N>-<sha>.md` maintainer notice for each of 115 bot-authored PRs that are OPEN, NOT draft, and have no gauntlet review staged. The liaison verified on 2026-10-07 that all 115 are still open and still on the head the audit saw. Maintainer directive (kriskowal, liaison muster 2026-10-07): classify each PR by the milestone/arc it serves so its review can be charged to a budget; for every PR that has not had a gauntlet, **plan** one at the foreman's discretion under that arc's budget; for every PR with CHANGES_REQUESTED, verify the requested changes were applied and bring it back to the maintainer inbox as a review request.

Arcs are the active schema-2 slices in journal `config/arc-budgets/` (minion-town-mcp-ocapn, minion-town-git-remote, minion-town-ui, endo-ocapn-background, moonshots, garden-upkeep, garden-book, endo-backlog, unallocated); their order and wording live in `config/apportionment` and `config/foreman-mandate`, which also names the current milestones (M2, M3, …). This orchestration is `pr-readiness-arc-plan-20261007`; the shared classification table is journal `projects/garden/pr-readiness-arc-classification-20261007.md`.

**Task.** Read journal `projects/garden/pr-readiness-arc-classification-20261007.md` (written by child 1). For each row with `disposition: gauntlet` and **not** flagged `superseded?`:
1. Park a foreman-selectable plan with the row's arc:
   `scripts/jobs/post-plan.sh --deferred --arc <arc> <owner>-<repo>-pr<N>-gauntlet-plan-20261007 <body>`
   The body names the PR URL, its arc and milestone, and the action: on promotion, run
   `scripts/jobs/post-gauntlet.sh --arc <arc> <owner>-<repo>-pr<N>-gauntlet-20261007 <pr-url>`
   (verify first that the PR is still OPEN and not draft; if it merged, closed, or went draft, complete as a no-op).
   Use `--deferred` only: the foreman decides when, within the arc's budget. **Do not** post any gauntlet directly.
2. Archive that PR's readiness notice: `scripts/jobs/maintainer-archive.sh watchdog-pr-gauntlet-readiness-<repo>-pr<N>-<sha>.md` (match by PR number in `inbox/maintainer/unread/`).

For rows flagged `superseded?`, plan nothing and leave the notice; list them in your report for a close-or-keep decision.

**Report:** per-arc counts of plans parked, the superseded list, and any PR skipped and why. The five APPROVED PRs are in this set too; note them, since an approved PR may only need a conduct (merge) rather than a gauntlet.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-07T16:05:25Z
