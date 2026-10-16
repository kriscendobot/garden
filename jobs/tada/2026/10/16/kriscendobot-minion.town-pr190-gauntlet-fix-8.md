## Fix round 8 — kriscendobot/minion.town PR #190

I applied the round-8 panel's concrete must-fix items to `clip-gutter-reorder`, and CI is green on the new head `c6a7623`. I did not apply the two seats asking for a capability redesign; that decision is with the maintainer. I pushed three follow-up commits on top of `fdf2503` with `safe-push-pr-head.sh`.

**Commits**
- **`ee2c0c6` (gateway):** the fs store now checks a saved order file with `isClipOrder`, the same check the route uses (purist, saboteur, breaker). A bad file counts as malformed, and the listing falls back to default order. `isClipOrder` also rejects sparse arrays (corner-prober). I added a fast-check property for `orderClips` (fast-checker), cited the Fetch keepalive limit next to `MAX_CLIP_ORDER_LENGTH` (spec-keeper), and moved the store tests to canonical labels.
- **`f534acd` (shell):**
  - A new check, `isPersistableReorder`, refuses any reorder that changes a position at or past the 1,000-clip limit, so a move can't be silently lost on reload (assessor, saboteur).
  - `createOrderSaver` (breaker):
    - It marks a save as running before `save` runs, so a save that calls back in can't start a second one.
    - An error reporter that throws no longer wedges the queue.
    - It gains a `flush` that sends the waiting order right away when the page is closing (`pagehide`) (engine-realist).
  - The gutter now saves through the real route by default, and a test asserts the `PUT /account/clips/order` a reorder sends (prover).
  - Another test checks that 1,000 full-length labels stay under the 64 KiB keepalive limit (spec-keeper).
  - Renamed the drag variables to `draggedIdentifier` and similar (stylist).
  - Replaced JSDoc blocks that only restated signatures with inline types (pruner).
- **`c6a7623` (design doc):** the clip-id dependency is stated once, the self-justifying sentence is gone, and the order limit is documented (pruner).

**On the PR**
- Posted the round-6 summary the scribe found missing, and a round-8 summary that maps each finding to its commit.
- Changed the Verification paragraph in the PR description to a CI link.

**Verification**
- `tsc` is clean. The two changed test files pass (57 tests).
- The full local run has one failing test, in `test/git-remote/capability.test.ts`, which depends on the host's git setup and is unrelated to this PR. Two `tools/claude-harness/*.test.mjs` files also fail to load as test files.
- `ci-wait-merge` returned rc 0: GREEN, read through the Actions runs API because this token can't read the PR's check status. My first wait call was killed by my own 590s wrapper before it reported; the re-run returned GREEN.

**Not done here**
- **locksmith, decomplector:** both want the per-owner order facet built on a capability (or the existing publish facet) instead of being looked up by OAuth `iss+sub`. They cite the maintainer's rulings on #50 and #85. This is an architecture decision, so I sent it to the maintainer as an a/b/c choice and changed no code.
- **integrator:** asks to squash the 16-commit history. I suggested doing that at retcon or ferry time.
- **purist:** suggests switching to `@endo/sha256`/`@endo/hex`. This was a should-fix, and I deferred it because it adds dependencies.
- **spec-keeper:** asks for evidence that drag-and-drop behaves the same in Chromium, Firefox and Safari. This repo has no browser test harness, so that wasn't possible.
- **Remaining risk:** the page-close flush can still lose the newest order if the older request lands last. Preventing that needs a server-side revision, which round 5 removed on purpose.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr190-gauntlet-fix-8.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 62 tokens (2735781 cached reads)
- Output: 26205 tokens
- Cost: $1.8862802
- Wall-clock: 1116s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
