**PR #248 fix round 4: fix pushed and CI is green.** The head is now `d6d855da`, pushed with `safe-push-pr-head.sh`.

**Panel findings (review 5780382873)**
- **decomplector 1 (must-fix) and typist 1 and 3:** I removed the WeakSet. `load` now returns a `ClipListing` value, `{ clips, accountEmpty }`, and `clipRecordsFromListing` is back to its base form. A new private `clipListingFromBody` sets the flag, and denied or non-JSON answers give `{ clips: [], accountEmpty: false }`.
- **decomplector 2 (must-fix):** the title now goes through `applyClipListing` and `clearClipListing`, using a new `titleEmpty` callback alongside `showEmpty`, so `emptyPaneTitle` and the separate DOM writes are gone. The two functions stay separate because the title must also change without revealing the pane, for example while a New Clip status card is showing.
- **decomplector 3 (should-fix), partly done:** the property test that copied the production predicate is gone, and a table test now checks `accountEmpty` directly. A second new test covers the title path. I kept the browser gate because it is the only check of the real `bootstrap` wiring.
- **typist 2:** the test's declarations now use a shared `ClipRecord`/`ClipListing` type, and the `load` casts are gone. `createClipRefresher` is generic over the listing type, and `onClips` is renamed `onListing`.
- **pruner 1–3:** the repeated rationale is cut, the changeset is shortened, and the comment that restated its assertion is deleted.
- **pruner 4–5:** I cut the PR body's duplicate `Design:` line, the demo justification sentence and the "Real-daemon…" bullet. The ledger and CI link stay.
- **Comment-only items left as they were:** decomplector 4 and 5, and typist 4 and 5.

**Verification**
- **Local:**
  - `test/shell-clip.test.ts`: 100/100 passed.
  - `tsc --noEmit`: clean.
  - `clip-frame-gate.ts` on Chromium: 38/38 passed.
  - I did not run the full `npm test` locally; CI covers it.
- **CI:** `ci-wait-merge` returned 0 (2 runs, 0 failed). The typecheck + vitest job and the browser gate on Firefox, WebKit and Chromium all passed, and the Claude harness job was skipped. On this host the PAT can't read the status rollup, so this comes from the Actions runs API, and commit statuses and non-Actions checks weren't visible.

**Follow-ups:** none from this stage; panel-5 is re-posted by the driver.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr248-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (1211016 cached reads)
- Output: 20715 tokens
- Cost: $1.4371991999999998
- Wall-clock: 1724s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
