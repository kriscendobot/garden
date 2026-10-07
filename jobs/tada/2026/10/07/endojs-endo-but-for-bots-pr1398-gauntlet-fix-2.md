I applied the round-2 panel's must-fix items to PR #1398 and pushed them as head `4292f6bf42`. CI is green on that head (33/33), but only after I reran the one failing macOS test once.

**Changes** (pushed as a follow-up commit with `safe-push-pr-head.sh`):
1. **Missing changeset:** added `.changeset/daemon-formula-sturdyref.md` with a `minor` bump for `@endo/daemon`. The daemon package is marked private, but other daemon changes in the repo carry changesets, so this one does too. `@endo/sturdyref` is not private and already has its own changeset.
2. **Collection race:** before this fix, enlivening a ref in the gap between the collector dropping a formula from memory and deleting its saved file could bring the formula back to life.
   - `manager.js` now records collected ids in a new `collectionPendingIds` set. They are added when the formula leaves memory and removed after the saved file is deleted.
   - The ref kit takes a new `isCollected` check and rejects enlivening those ids instead of calling `provide`.
   - A new test collects a formula, enlivens a ref to it, and checks it rejects without reviving it.
3. **JSDoc type:** the parameter is now `{FormulaIdentifier} formulaId`. I removed the needless alias of the parameter and the redundant cast after `isSturdyRef`.
4. **Module comment:**
   - It now says OCapN refs are the same kind of SturdyRef, just minted by a different tracker.
   - It says the minting function carries the same authority as `provide`.
   - It says a ref to a formula on another node connects to that peer when enlivened.
5. **PR body:** trimmed the per-file walkthrough, the prior-art paragraph and the boilerplate sections, and noted the new changeset.

**Checks:** the sturdyref test file passes locally (6 of 6), eslint reports no errors on the touched files, and `tsc` reports nothing for them. I posted a summary comment on the PR: https://github.com/endojs/endo-but-for-bots/pull/1398#issuecomment-6033522599

**CI:**
- The first `ci-wait-merge` run ended red (rc 3) on one test: `daemon-teardown › an orphaned daemon shuts itself down instead of lingering` on `test (24.x, macos-15)`. That test doesn't involve the code I changed (a ref helper and one in-memory set), so I treated it as a flaky test.
- I reran only the failed job once. The new `ci-wait-merge` run returned rc 0, green.
- If that macOS teardown test keeps failing on other PRs, it's worth looking at separately.

**Not done:** the panel's comment-only suggestion of an integration test against the real `makeDaemonCore` (from the prover seat). That suits the next layer, which exposes this to a wider surface.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1398-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 66 tokens (2685484 cached reads)
- Output: 15184 tokens
- Cost: $1.5592248000000004
- Wall-clock: 4535s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
