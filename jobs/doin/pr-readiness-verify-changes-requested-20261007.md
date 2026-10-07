---
role: fixer
tier: mentor
arc: garden-upkeep
handler-timeout: 7200
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-10-07T16:42:03Z cleared=none -->

---
role: fixer
tier: mentor
fallback-tier: minion
arc: garden-upkeep
handler-timeout: 7200
dispatch: automatic
---
**Role: fixer.** Child 3/3 of orchestration `pr-readiness-arc-plan-20261007`: **verify CHANGES_REQUESTED PRs were addressed and return them for review.**

**Context.** On 2026-10-06 the readiness audit (`design-pr-gauntlet-coverage-audit.sh`) filed one `watchdog-pr-gauntlet-readiness-<repo>-pr<N>-<sha>.md` maintainer notice for each of 115 bot-authored PRs that are OPEN, NOT draft, and have no gauntlet review staged. The liaison verified on 2026-10-07 that all 115 are still open and still on the head the audit saw. Maintainer directive (kriskowal, liaison muster 2026-10-07): classify each PR by the milestone/arc it serves so its review can be charged to a budget; for every PR that has not had a gauntlet, **plan** one at the foreman's discretion under that arc's budget; for every PR with CHANGES_REQUESTED, verify the requested changes were applied and bring it back to the maintainer inbox as a review request.

Arcs are the active schema-2 slices in journal `config/arc-budgets/` (minion-town-mcp-ocapn, minion-town-git-remote, minion-town-ui, endo-ocapn-background, moonshots, garden-upkeep, garden-book, endo-backlog, unallocated); their order and wording live in `config/apportionment` and `config/foreman-mandate`, which also names the current milestones (M2, M3, …). This orchestration is `pr-readiness-arc-plan-20261007`; the shared classification table is journal `projects/garden/pr-readiness-arc-classification-20261007.md`.

**Task.** Read journal `projects/garden/pr-readiness-arc-classification-20261007.md`. For each row with `disposition: verify-changes` (26 expected):
1. Fetch the latest CHANGES_REQUESTED review(s) and their inline threads (`gh api` reviews + review comments). List each requested change.
2. Check the commits after that review and the current diff. Decide per request: **applied** (cite commit/file), **partly**, or **not applied**. Also note any reply thread where the bot pushed back instead of changing code.
3. If every request is applied: send ONE maintainer message for the PR requesting re-review (`scripts/jobs/send-msg.sh maintainer`, keyed `review-request-<owner>-<repo>-pr<N>`). Give the PR URL, arc and milestone, a checklist mapping each request to the commit that addressed it, and current CI state. Do not request review on GitHub and do not approve anything.
4. If anything is partly or not applied: send no review request. Instead park a fixer plan carrying the row's arc (`post-plan.sh --deferred --arc <arc> <owner>-<repo>-pr<N>-address-review-20261007`) that lists the unaddressed requests.
5. Either way, archive that PR's `watchdog-pr-gauntlet-readiness-…` notice.

Rows flagged `superseded?`: verify nothing; list them for the close-or-keep decision.

**Report:** counts (returned for review / fixer planned / superseded), and the list of review-request message keys sent.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-07T16:42:31Z
