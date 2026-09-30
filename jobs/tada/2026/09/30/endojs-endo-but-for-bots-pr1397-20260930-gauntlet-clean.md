---
orchestration-failed: true
---
orchestration-failed: true

# Gauntlet CLEAN stage: endojs/endo-but-for-bots#1397 (layer 7, SturdyRef enliven)

The coverage pass is clean, but CI came back red (ci-wait-merge rc=3), so this stage fails. The main red check is a type error that comes from the layer-6 base (#1396), not from this PR's diff.

**What I did**
- **Coverage (skills/coverage-driven-testing):** ran the full `@endo/ocapn` suite under c8. All 571 tests pass. `src/client/sturdyrefs.js` is at 99.28% lines, 97.77% branches and 100% functions. Every line this PR changed is covered. The only uncovered lines are 247–248, the `SturdyRef details not found` guard in `enlivenSturdyRef`, and that code predates the PR (commit a4efc500c5b).
- **Dead code:** none. The ASCII-then-bytes lookup moved into a shared `lookupSwissnum` helper, which both the home path and the tracker's `lookup` use. Every import is still used. I made no code changes.
- **CI had never run on this head.** Head 267b1aa was force-pushed at 10:00:36Z and the base was re-pointed 9 seconds later. No workflow ran for that SHA, and the base-change event doesn't trigger `pull_request` CI. To get a run, I re-committed the same tree (tree 36e98395, no content change) as **77e2431254** and pushed it with `safe-push-pr-head.sh --mode rewrite`. All 33 checks then attached.
  - The layer-6 PR #1396 has the same problem: its head 7a341141ca also has no CI runs, and the last CI run on that branch (608307976c) failed.

**CI result at 77e2431254: RED, 2 of 33 checks failed**
1. **`lint`**, in the steps "Check the root TypeScript program" and "build API docs" (typedoc):
   `packages/captp/test/sturdyref.test.js:264:40 TS2339: Property 'locate' does not exist on type 'EMethods<Required<unknown>>'` at `E(locator).locate(1)`.
   - That file isn't in this PR's diff. The line comes from layer 6 (#1396, commits 205aa88ad5 and 7a341141ca), so #1397 inherits the error through its base.
   - The fix belongs on #1396: give the test's `locator` a type, or cast it, so `E(...)` sees a `locate` method. After that, restack #1397.
   - #1396's own gauntlet clean stage (`endojs-endo-but-for-bots-pr1396-20260930-gauntlet-clean`) is waiting in `jobs/todo/`. It will hit the same error, and it will also find no CI on its head (the same trigger fix works there).
2. **`test (24.x, macos-15)`**: `packages/daemon` `test/endo.test.js exited with a non-zero exit code: 1`, after about 25 minutes. It failed only on macOS 24.x; the other three test legs (22.x ubuntu/macOS, 24.x ubuntu) passed. This looks like a macOS daemon flake, not something caused by the ocapn change, but I didn't confirm it by re-running.

**Follow-ups**
- Fix the root-tsc error on layer 6 (#1396), then restack #1397 onto the new frozen base and re-run its gauntlet.
- Re-run the macOS 24.x leg to confirm the daemon failure is a flake.
- In the stacked-layer flow, CI can silently never start when a force-push and a base re-point happen together. The driver should check that a new head actually got a CI run.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1397-20260930-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 76 tokens (2548247 cached reads)
- Output: 12673 tokens
- Cost: $1.3566294
- Wall-clock: 2835s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
