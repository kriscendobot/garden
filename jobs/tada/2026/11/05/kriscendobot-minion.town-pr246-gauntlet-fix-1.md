Panel-1's findings on PR #246 are fixed and pushed as `93329d9f` on `garden/remove-open-in-new-tab`, and CI is green. `ci-wait-merge` returned rc 0. Both Actions workflows passed: `test (typecheck + vitest)` and `clip frame browser gate` on Chromium, Firefox and WebKit. The bot token can't read commit statuses or non-Actions checks, so CI covers Actions runs only.

**Fixes by finding:**
- **Stale design claims (assessor, locksmith, saboteur, breaker, purist, spec-keeper, surfacer, corner-prober):**
  - `designs/clip-shell-framework.md` no longer promises a top-level link, either in the browser gate list or in the rollback fallback.
  - The failure section now says a refused clip stays in the pane with no link around it.
  - I also renamed the leftover "open-link origin" test title.
- **Tests only checked three old IDs (breaker, corner-prober):**
  - The unit test now rejects any anchor, button or form in `#main`, plus any `href`, `target` or `onclick` attribute.
  - A new unit test checks the inert card the same way.
  - The browser gate has a new `countDirectNavigationControls` helper covering `#main` and any inert card, run for live, refused and hung clips.
- **Missing changeset (changeset-auditor, migrator, releaser):** added `.changeset/remove-open-in-new-tab.md`. It says nothing replaces the links.
- **Regression evidence (prover):**
  - I temporarily added a link to `#main` under an unknown ID. The unit test failed with `expected '<main id="main"><a id="renamed-escape…' not to match /<(a|area|button|form)\b/i`, and three browser-gate checks failed (26/29 on Chromium).
  - After reverting, results were 98/98 unit tests and 29/29 gate checks. The PR body now records this.
- **Removal lacked maintainer approval (decomplector):**
  - The request is real. The journal job `build-minion-town-remove-open-in-new-tab-20261104` records it as a maintainer ask from kriskowal's 2026-11-04 session.
  - I didn't stop or restore the link. The design and PR body now record the decision as a deliberate reversal of #197 and the #189 approval.

**Judgment calls:**
- The changeset auditor asked for a `major` bump and two other jurors asked for `minor`. I used `minor`, which matches how the repo's existing changesets record removals (`account-deletion.md`).
- The migrator asked for a migration path. The changeset gives none, because the maintainer's request names no replacement.

**Checks before pushing:** pre-push gates and typecheck passed. The gates gave one non-blocking pruner warning, on the existing comment at `deploy/aws/www/shell.js:17`, which I left alone.

**Follow-ups:**
- **Conflict with draft #247:** its design proposes an "Open in new tab" item in the gutter's right-click menu. That is a different control, but it sits awkwardly with this removal, so #247's review should settle it. The viability stage flagged this too.
- **Next stage:** per this stage's instructions I didn't re-run the panel; the driver posts panel-2.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr246-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (981762 cached reads)
- Output: 13022 tokens
- Cost: $1.0871844000000002
- Wall-clock: 652s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
