---
handed-off: build-ocapn-noise-session-reconnect-phase-two-open-pr
deliverable-complete: false
---
Phase 2 (session epoch and send queue, with the simulated-stall fault injector) is built and pushed, but the draft PR is not open yet. This host's bot token is refused when it tries to create PRs on endojs (403), so I handed the PR opening to a successor job pinned to an endolin host.

**Where the work is**
- Head branch `llm-ocapn-session-send-queue` (commit `df210891a`), stacked on #1502's head.
- Base branch `llm-ocapn-session-heartbeat-e8e42fb`, a frozen snapshot of #1502's head (`e8e42fbea`). `ensure-pr.sh` required a frozen base rather than #1502's branch. #1502 is still an open draft, so no rebase was needed.

**What changed in `@endo/ocapn`**
- **New send queue** (`src/client/send-queue.js`). Every outbound operation in a session goes through a queue that also holds the session's epoch number.
  - While the connection writes immediately, the queue does nothing extra, and a write error still reaches the caller.
  - When a write stalls (returns a pending promise), later operations wait behind it in order and are sent once it completes. A write that fails while the queue is catching up aborts the session.
  - `advanceEpoch(write)` switches to the next connection and resends everything not known to have gone out, including the write that was mid-flight. Nothing calls it yet; Phase 3's reconnect will.
- **Heartbeat** now reads the epoch from the session through `getEpoch` instead of a private constant.
- **`ocapn.js`** sends through the queue, closes it on abort, and exposes it as `_debug.sendQueue` (debug mode only).
- **Test helpers:** `test/_stall-injector.js` makes a connection's writes hang until released, the way a TCP write blocks on a full buffer. `test/_manual-timer.js` is the manual test clock, moved out of `heartbeat.test.js` so both test files can use it.
- **Tests** in `test/send-queue.test.js`: 8 unit tests and 2 integration tests on the real TCP test transport.
  - A 20 s stall (longer than the 5 s heartbeat interval, shorter than the 30 s session timeout): a call made during the stall resolves after release, and the session survives.
  - A 35 s stall: the heartbeat declares the session lost, both sides tear down, and the queue is emptied.
- Added a Phase 2 status note to the design doc and a patch changeset, `.changeset/ocapn-session-send-queue.md`.

**Checks:** all 582 `@endo/ocapn` tests pass under `yarn test`, `yarn lint:types` is clean, and eslint reports no errors.

**Follow-up**
- Posted job `build-ocapn-noise-session-reconnect-phase-two-open-pr`, pinned with `requires: host=endolin-garden-ece02cb4`. It runs `ensure-pr.sh` with the full PR body embedded, opens the PR as a DRAFT, and names it in its report so the review gauntlet gets staged.
- The lasting fix is to give the bot's token pull-request write access on endojs.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-ocapn-noise-session-reconnect-phase-two.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 74 tokens (2794974 cached reads)
- Output: 26795 tokens
- Cost: $1.8493987999999997
- Wall-clock: 1208s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
