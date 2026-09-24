# Gauntlet 20260923b fix round 5: endojs/endo-but-for-bots#1100

I applied all five items from the round-5 panel review (5299740264) and pushed them to the PR head. CI is green: all 33 checks finished, with 25 passing and 8 skipped. The first CI run failed one macOS cell, and a re-run of that job passed.

**What changed.** Three commits, pushed with `safe-push-pr-head.sh` (`9936fb1488` → `860574a2bd`):
1. **Breaker must-fix, and purist's shared-helper suggestion (`fca0b5fbec`).**
   - `OpenFile.write` and `File.write` now cap the total bytes they buffer before committing. A write that goes past 256 MiB fails with `E2BIG` and discards the buffer. The 256 MiB default can be changed with a new `wrapBackend` option, `writeByteLengthLimit`.
   - `Xattrs.set` and both file writers now use one shared helper, `shared/buffered-bytes-writer.js`. It holds the per-frame limit, the total limit, and the rule that an abort discards the buffer while a normal close commits it. `Xattrs.set` keeps its 64 KiB limit.
   - `frame-limits.test.js` has four new cases: for each of `File.write` and `OpenFile.write`, one byte over the total is rejected and leaves the file unchanged, and exactly the total is accepted.
   - Stylist's renames are in the same test file: `oh` → `openHandle` and `off` → `offset`.
2. **Purist's base64 point (`63a3c3cd7c`).** I rewrote the comments in `clone.js` and `layer.js` rather than converting the payloads to `M.byteArray()`. The comments now say why the payloads stay base64: converting them would break peers that still send base64, so it belongs in a separate breaking change.
3. **Releaser (`860574a2bd`).** The changeset now describes what actually changed in each package:
   - `host-shell`, `claude-sandbox` and `cli` have no source change.
   - `sandbox` changes a doc comment and a test.
   - `codex-sandbox` changes a test fixture.

   It also notes the new total limit on the platform writers.

**Scribe items.**
- I posted a completion-summary comment covering rounds 4 and 5: https://github.com/endojs/endo-but-for-bots/pull/1100#issuecomment-5807611895
- I sent the round-4 and round-5 proposed rules to `role/gardener` (message `20260924T042038Z-851823`).

**Local checks.** In `@endo/platform`, the type check passes and all 390 `ava` tests pass. ESLint shows warnings but no errors.

**CI.** On the first run, `test (22.x, macos-15)` failed in one test outside this change: `@endo/daemon`'s `daemon-teardown` test ("an orphaned daemon shuts itself down…"). It depends on process timing and doesn't touch the write paths I changed. I re-ran the failed job, it passed, and `ci-wait-merge.sh --no-merge` then returned rc 0 at head `860574a2bd`.

**Not done (the panel marked these non-blocking).** Folding the fixup commits into the logical commits, the `minor` bumps in two changesets that conflict with a `major` bump elsewhere, the missing `types` condition on the `./fs/lite` export, and splitting commit `1d8733df77`. The PR comment lists these for the maintainer to decide before merge.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-exo-stream-pr1100-gauntlet-20260923b-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 100 tokens (4101371 cached reads)
- Output: 21118 tokens
- Cost: $2.0463222
- Wall-clock: 4612s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
