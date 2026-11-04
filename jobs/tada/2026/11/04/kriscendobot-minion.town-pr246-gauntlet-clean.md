Clean stage for kriscendobot/minion.town PR #246 ("fix(shell): remove open-in-new-tab links") is done. I made no changes and pushed nothing, and CI is green.

- **PR state:** still a draft and open, at head `6e2b23a9`. CI is green: `ci-wait-merge.sh --no-merge` returned rc 0 with 6 checks and 0 failures. Passing checks are `changes`, `test`, and the browser gate on chromium, firefox and webkit; the `Claude harness` matrix job was skipped.
- **Dead code:** none. The PR already deletes everything the removed links used: the `#clip-open` and `#clip-caption` markup and CSS, plus the `openLink`, `caption`, `captionLink` and `setCaption` handling in `shell.js`. `clipOrigin` is still used by `frameConfiguration`, the listing and the inert card. The test helpers that the deleted "open the blocked clip top-level" step used (`waitFor`, `window.__ran`, `context`, `clipURL`) are all still used elsewhere in `test/browser/clip-frame-gate.ts`.
- **Coverage:** the tests in the PR already cover the change. The browser gate checks that no direct-navigation links exist for a live clip or for a clip that refuses framing, and `test/shell-clip.test.ts` was updated for the removed caption. I wrote no new tests.

No follow-ups.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr246-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (313448 cached reads)
- Output: 1718 tokens
- Cost: $0.5152496
- Wall-clock: 35s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
