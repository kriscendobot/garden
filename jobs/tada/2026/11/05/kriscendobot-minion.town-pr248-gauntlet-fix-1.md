I applied panel-1's two should-fix items to PR #248 and pushed them as `20a8b7fb`. CI is green: `ci-wait-merge` returned rc 0, with both `clip frame browser gate` and `test (typecheck + vitest)` passing. The bot PAT can't read `statusCheckRollup`, so CI status comes from the Actions runs API, and any commit statuses or non-Actions checks aren't visible.

**Finding 1, wrong pane copy (fixed):** the `#empty` pane said "No clips yet." in states where that isn't known to be true.
- **Paths the assessor named:** a selected clip vanishing beside a populated gutter is real (`applyClipListing`). The `userActed` path is not: `showEmpty` doesn't run when nothing was selected, and the `+` path covers the pane with a status card.
- **Paths I added:** the pane is also visible before the first listing arrives and after a failed read, and the copy was false there too.
- **The fix:**
  - The title now comes from the latest listing through a new `emptyPaneTitle(clips)` in `shell.js`. Only a successful empty listing says "No clips yet.", as the design specifies, and every other state says "No clip selected."
  - The static markup defaults to the neutral title.
  - The line "Press + in the gutter to make a new clip." is true in every state, so it stays.
  - An older `index.html` served with this `shell.js` is handled.

**Finding 2, test only grepped static HTML (fixed):**
- `test/browser/clip-frame-gate.ts` now drives the real shell through seven checks: before the first listing, empty listing, clips arriving with nothing selected, selecting a clip, a selected clip vanishing beside a populated gutter, a later empty listing, and a failed read.
- `test/shell-clip.test.ts` adds a unit test for `emptyPaneTitle`, and the HTML test now pins the neutral default and slices the gutter and main sections from their own start.
- `dev/new-clip-browser-demo.mjs` now waits for the "No clips yet." title, because the title is set only after the listing is applied.

**Findings 3 and 4 (comment-only, left as is):** the assessor says the daemon test's assertion holds today, and the demo's default timeout is acceptable.

**PR body:** I updated the empty-pane bullet to match the new behaviour.

**Local verification:**
- `test/shell-clip.test.ts`: 99/99 passed.
- Home-page, new-clip, deploy-www-staging and settings-menu tests: 90/90 passed.
- `tsc --noEmit`: clean.
- Browser gate on Chromium: 37/37 passed. Firefox and WebKit ran only in CI.
- I did not run the gate against the old copy to confirm the new checks fail on it, or run the updated `dev/new-clip-browser-demo.mjs` locally.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr248-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (1056977 cached reads)
- Output: 15101 tokens
- Cost: $1.1844554000000003
- Wall-clock: 806s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
