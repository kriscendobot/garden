**Clean stage for PR #1476: coverage pass is finished and pushed, but CI is still pending, so this isn't `clean=done`.** The head is now `ef689c10e`, and the PR is still a draft.

**CI at 09:27Z**
- **Results:** 17 checks passed, 15 skipped, none failed, including `lint`, which failed on my first push.
- **Still running:** `test (22.x, ubuntu-latest)`, `test (22.x, macos-15)`, `test (24.x, ubuntu-latest)` and `test (24.x, macos-15)`.
- **Why I stopped waiting:** every `ci-wait-merge.sh` window ended with rc 4, and the last one ran 47 minutes after the push. I ran short windows rather than one 3600s wait, and the handler's 3-hour limit ends around 09:45Z. These jobs were still running over an hour after the previous push, so they may not finish before then.

**Dead code removed (`bcb60447d`)**
- **`lastAckedRecvNonce` is never undefined:** `exchangeIdentity` decrypts the peer's greeting before `buildSession` runs, so the received count is never zero. I removed the undefined case and the early return that skipped `op:pong`.
- **Docs and types updated:** `SessionLiveness.lastAckedRecvNonce` narrows to `bigint`, and the README now says every tick sends `op:pong`.
- **Redundant guard:** I also removed the `isClosed()` check in `sendFrame`, because `tick` already checks in the same turn.

**Tests added (`09425cabc`, `ef689c10e`)**
- **Failure paths:**
  - a heartbeat that can't be encoded
  - a tick firing while the transport is still closing
  - rejecting `reader.return`, `reader.throw` and `writer.throw`
- **Other behavior:**
  - a thrown cause reaching the peer
  - direct round trips of the heartbeat read and write helpers in `@endo/ocapn`
- **Do they catch regressions?** Yes. I temporarily broke the `tick` guard, the `tick` catch and the `throw` try/finally, and each break made tests fail or crash the run.
- **Coverage of `network.js`:** lines rose from 95.72% to at least 96.75%, and branches from 88.38% to at least 88.92%. I measured that just before one last assertion was added, using a narrower report than the baseline. The uncovered changed lines left are the `onClose` catch and the `[Symbol.asyncIterator]` returns, plus a `throw err` that last assertion should now reach (not re-measured).

**Local checks on the final code**
- **Tests:** `ocapn` passes all 580. `ocapn-noise` reached a clean 104 under each of its three configs, but not on every run (see below).
- **Static checks:** `tsc` is clean for both packages and prettier is clean on the changed test files. eslint shows no errors, only one unused-directive warning on a line this PR didn't change.

**Worth knowing**
- **My lint failure:** `09425cabc` failed `lint` because I had only type-checked `ocapn-noise`, not `ocapn`. `ef689c10e` fixes it, and that restarted CI.
- **Flaky local `ocapn-noise` runs:** some runs fail with `ENOENT` on `.cache/ava/import-from-project.mjs`, even though the file exists, and the affected test files change each run. It looks like the known virtiofs race on this host's scratch mount, though I didn't prove that. It only appeared in local runs on this host, not in CI.
- **For the panel:**
  - **Possible hang:** with heartbeats off, a `reader.next()` after `reader.throw` or `writer.throw` hung in one of my draft tests, apparently because `throw` closes only the write side. I rewrote the test to avoid it and didn't investigate further.
  - **Unreachable until reconnect:** `message.epoch < epoch` can't be true while `epoch` is fixed at `0n`. I kept it because it looks like groundwork for session-reconnect Phase 2.

<!-- gauntlet-stage-result: clean=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1476-gauntlet-20261102-e530cc47c626-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 84 tokens (4494098 cached reads)
- Output: 39134 tokens
- Cost: $2.755779599999999
- Wall-clock: 9643s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
