Round-5 fix for endojs/endo-but-for-bots#1476 is pushed and CI is green: 35 checks, 0 failed, at head `3a1750f777`. One macOS leg failed the first time and passed when re-run (details below).

**Panel must-fix items applied** (two commits on top of `6ef59e4f32`, pushed with `safe-push-pr-head.sh` in advance mode):

- **breaker: timer kept running after a transport failure.** The heartbeat code in `packages/ocapn-noise/src/network.js` is now a `makeHeartbeat` factory, as the decomplector suggested. Every way the session ends from inside goes through one `close(failure?)`, and a failure is reported once by the next read.
  - A rejected `stream.reader.next` now closes the session and stops the heartbeat, with or without heartbeats on.
  - A rejected heartbeat `writer.next` closes the session with that error. Before, the error was swallowed.
  - This also removes the `let` rebinding of `readPeerFrame`/`absorbHeartbeat` and the separate `heartbeatFailure` slot.
- **breaker: liveness limit undocumented.** The README now says a consumer that stops reading does not notice a lost peer until it reads again, and the session keeps sending heartbeats meanwhile. It also says a failed transport read or heartbeat write closes the session. It now says an `op:pong` acknowledges received frames rather than answering one ping (duality-auditor).
- **coverage-auditor: missing tests.**
  - A new integration test runs one peer with heartbeats and one without, so the OCapN client's `op:ping`/`op:pong` no-op handlers get exercised.
  - New heartbeat tests use a transport that can be made to fail. They cover a failed read and a failed heartbeat write (session closes, no timers left), and a rejecting `writer.return` (the rejection surfaces and the session is still forgotten, so `provideSession` returns a new session).
- **pruner: too much text.**
  - Deleted the wrong `HEARTBEAT_INTERVAL` comment and the epoch comment.
  - Trimmed the `isHeartbeatFrame` JSDoc and the `ocapn.js` comment.
  - Removed the duplicate `types.d.ts` sentences, the five narrating test comments and the README rationale clause.
  - Cut the PR body: shortened "Why this is needed", replaced Compatibility Considerations with "See the changeset", and the Testing section now says the `test:xs` stub is an existing deferral this PR keeps.

**Local checks:** all 97 `@endo/ocapn-noise` tests and 563 `@endo/ocapn` tests pass. ESLint has 0 errors, the package `tsc` shows nothing for ocapn-noise (the only errors it prints are in other packages), and the repo-root `tsc` shows nothing for ocapn.

**CI:** `test (24.x, macos-15)` failed first on `daemon › workers create workers; vat GC sweeps the unreachable`. That test is outside this PR's diff and looks like a flake. I re-ran the failed job and it passed, then `ci-wait-merge.sh` returned rc 0. I waited in 540-second foreground chunks because my first background wait hit its 10-minute cap and was stopped.

**Follow-ups:**
- The changeset doesn't mention that a failed transport read now closes the session in heartbeat-off mode too. The next panel may want a line for it.
- Decomplector item 3 (replace the abandon-set with one pending read raced against a close signal) was not done.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1476-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 90 tokens (4484487 cached reads)
- Output: 26123 tokens
- Cost: $2.3407093999999997
- Wall-clock: 4457s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
