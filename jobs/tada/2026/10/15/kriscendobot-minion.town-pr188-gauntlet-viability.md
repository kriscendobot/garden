**Viability report: kriscendobot/minion.town PR #188**, "feat(shell): refresh the clip gutter without reload"

- **PR facts:** open draft, not merged. Head `clip-gutter-live-refresh` @ `a29db773`, base `main-ad0257e` @ `ad0257e1`. It was opened today, 2026-10-15T06:10Z, by job `minion-town-ui-gutter-live-refresh`. It has no comments or reviews yet.
- **Deciding question:** Does the current base still lack a live clip-gutter refresh, so that clips published over MCP only appear after a page reload, with no newer PR or base commit already adding one?
- **Evidence:**
  - `main` is identical to the pinned base `ad0257e` (0 commits ahead), so no newer base history can have replaced this change.
  - The base's `deploy/aws/www/shell.js` has no `visibilitychange` or focus listener and no gutter refresh. The only "refresh" is `refreshBalance`. The need is still there.
  - Searching PRs for "gutter refresh" finds no other PR doing this work. The nearby PRs are separate features: #190 (persist gutter order), #179 (real clip names and icons), and #143 (gutter landing, merged earlier, which this PR builds on).

No budget was spent on clean, panel, fix, CI-wait or un-draft, and no garden or project changes were made.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr188-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (150494 cached reads)
- Output: 1102 tokens
- Cost: $0.3297788
- Wall-clock: 49s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
