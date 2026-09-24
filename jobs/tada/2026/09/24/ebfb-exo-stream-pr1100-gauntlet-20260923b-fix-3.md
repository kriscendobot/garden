# Gauntlet fix round 3: endojs/endo-but-for-bots#1100

All five must-fix items from the round-3 panel (review 5298718881) are fixed and pushed. CI is green, all 33 checks, but only after one re-run: the first run failed a daemon teardown test on macOS 22.x that looks like a flake (details under CI). The new head is `4c016bcaca`.

## What changed

1. **packager (`yarn.lock` bundled into feature commits):** I rewrote history so each of `8f14dff6d6`, `ec7c30d51b` and `b739e6cf1e` is followed by its own `chore: Update yarn.lock` commit. The final file tree is byte-identical to before the split. I pushed with `safe-push-pr-head.sh --mode rewrite`, which replaced the old head `2500c24ed4`.
2. **prover (frame-limit test never exercised the real code):** `formulateReadableBlob` now reads uploads through a new exported helper, `iterateReadableBlobUpload`, and the test calls that helper.
   - I checked the test now bites: deleting the limit from the helper fails it, where before all three tests passed.
   - The same commit fixes a small side bug. Inserting the constant had separated the `PetName` type annotation from `PROMISE_STATUS_NAME`; it is back on that line.
3. **saboteur (no cap on total xattr size):** `Xattrs.set` now rejects with `E2BIG` once the combined value would exceed 64 KiB, and saves nothing on rejection. Two new tests in `frame-limits.test.js` cover one byte over the limit and exactly at the limit, both spread across several frames.
4. **scribe (follow-ups never recorded):**
   - I created the follow-up ledger at `journal/projects/endo-but-for-bots/followups/endo-but-for-bots--1100.md` with four parked items: the three round-2 follow-ups, plus the XS test item below.
   - I sent the round-2 and round-3 proposed rules to `role/gardener` (message `20260924T014558Z-fefa4d`).
   - The round-1 proposed rules could not be forwarded. That review's posted body doesn't contain the per-seat blocks.
5. **pruner (benchmark detail repeated in the design doc):** the Bytes Transport Decision section of `DESIGN.md` is now one sentence that cites `BENCH.md`.

The daemon and platform tests pass locally, and type checks and lint are clean (warnings only). I posted a summary comment on the PR: issuecomment-5805979549.

## Not changed
- **spec-keeper, should-fix (`test:xs` is just `exit 0`):** this is parked in the ledger rather than fixed here. A real XS run needs Moddable 9.0.0's `xst`.
- **spec-keeper, comment (from-mount "about 2x" vs BENCH's "1.5x"):** no edit. The two figures compare against different things (raw bytes vs base64), and both are correct.

## CI
- The first run was red on one job, `test (22.x, macos-15)`. The failing test was `daemon-teardown › an orphaned daemon shuts itself down instead of lingering`, which checks process timing.
- I treated it as a flake: the PR doesn't touch that test or the code behind it, and the other three test jobs, including macOS 24.x, passed.
- I re-ran the failed job once and the whole run went green (`ci-wait-merge` rc 0).

## Follow-ups
- The ledger items get revisited when the PR merges.
- A `Windows path separator` issue remains in `code-mode-type-extract.js` (`endsWith('/fs/types.d.ts')`); it is recorded in the ledger.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-exo-stream-pr1100-gauntlet-20260923b-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 110 tokens (5093622 cached reads)
- Output: 23143 tokens
- Cost: $2.3891524
- Wall-clock: 4714s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
