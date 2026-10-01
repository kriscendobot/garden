The panel round 2 on endojs/endo-but-for-bots PR #1394 came back **must-fix**, and I posted the verdict as a review on the PR.

**How it ran**
- Isolated checkout of the PR head (`endojs`/`build/sturdyref-captp-wire` at `1ff926bc52a2`) at `scratch/project-wt-ebfb-st-0f112ec2f05d-be0bf55b`.
- Ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh <wt> 1394 36c4f40bcde8…`. I passed the base commit from the PR record rather than the branch name, since the base is a frozen stacked branch (`build/sturdyref-marshal-representation-36c4f40`).
- All 33 seats returned a status of ok, so there were no seat or decider errors.
- The script ran in the background, so I couldn't read its exit code. It printed the single-round result line, which `panel.sh` follows with `exit 0`, and it saved the run to `panel-runs/endojs-endo-but-for-bots-1394/84735efa9504.md`.

**Review posted:** review 5374480276 on head `1ff926bc`. It's a plain comment because GitHub refuses a "request changes" review on the bot's own PR; rounds 1 and 1-rerun had the same state. The body opens with "Gauntlet panel — round 2: **must-fix**". The full panel report is 83 KB, too big for one review, so I trimmed it to about 62 KB: all must-fix and comment-only seat reports are kept in full. Eleven approving seat reports were left out, and the review names them and points to the saved run.

**Must-fix items**
1. **Version bump:** the changeset files `@endo/ocapn` as `minor`, but its own compatibility notes describe breaking changes, so it should be `major`. Five seats flagged this (curator, migrator, changeset-auditor, releaser, packager). The changes: `SturdyRef` moves from the tagged-record type to the realm `SturdyRef`, and `passStyleOf` now returns `'sturdyRef'` instead of `'tagged'`.
2. **JSDoc import (typist):** `packages/ocapn/src/client/sturdyrefs.js:21` uses an inline `import()` type. It should use an aliased `@import` at the top of the file.
3. **Missing summary comment (scribe):** neither of the earlier fix rounds posted the required top-level comment summarizing what they changed in response to review.
4. **PR description (pruner):** remove the test-count tallies and the paragraph about editing the snapshot by hand.

**Should-fix and comment-only items**
- The `@endo/sturdyref` shim does its install and `harden` setup before lockdown, and that path has no XS test coverage.
- A new enliven object is created on every call instead of being cached.
- Rename `opts` to `options` in a test.

I didn't fix anything or take the PR out of draft; the gauntlet's next stage owns that.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer5-captp-wire-20260930-gauntlet-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (983522 cached reads)
- Output: 6171 tokens
- Cost: $0.8220044
- Wall-clock: 676s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
