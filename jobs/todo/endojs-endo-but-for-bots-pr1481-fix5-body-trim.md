---
role: gardener
requires: host=endolin-garden-ece02cb4
tier: mentor
pr: https://github.com/endojs/endo-but-for-bots/pull/1481
fallback-tier: minion
dispatch: automatic
---

# Apply the pruner's PR-body trim to endojs/endo-but-for-bots #1481

The fix-5 gauntlet stage (host oros-studio, whose PAT cannot edit endojs PRs)
prepared a trimmed PR body per the panel-5 pruner seat: it drops the Scaling,
Documentation and Compatibility sections, cuts Testing to the flake note, folds
Upgrade to one sentence, and adds a Security bullet for the new per-peer resume
handshake cap. Replace the body of
https://github.com/endojs/endo-but-for-bots/pull/1481 with EXACTLY the text
between the BEGIN/END markers below (`gh pr edit 1481 -R endojs/endo-but-for-bots
--body-file <file>`). Only do this if the live body still has a
`### Scaling Considerations` section; otherwise it was already applied — no-op.
Do nothing else to the PR.

----- BEGIN BODY -----
Refs: #252, #1476, #1478

## Description

Phase 3 of `designs/ocapn-noise-session-reconnect.md`, stacked on the Phase 2 PR #1478 (base: frozen head `build/ocapn-noise-session-queue-2a16357`). A session whose transport instance is lost reconnects on a fresh Noise IK handshake (Rekey); the CapTP layer sees one continuous session, and every unacknowledged frame is replayed exactly once, in order.

`@endo/ocapn` adds the proposed `op:session-hello` and `op:session-end` records; the design's new § 7 specifies them, and the changesets describe the API. The dialing side redials; a responder that no longer holds the session refuses, and the dialer aborts at once. `test/_loss-injector.js` partitions a transport's open streams to drive the loss.

**Wire break:** every OCapN-Noise handshake now sends `op:session-hello`, even with heartbeat and reconnect off, so this version does not interoperate with older OCapN-Noise peers (pre-1.0, minor bump).

<!-- garden-phase-evidence-ledger:v1 -->
## Phase and evidence ledger

Design: `designs/ocapn-noise-session-reconnect.md`
Disposition: orchestrated-slice
Successor: endo-but-for-bots-ocapn-noise-session-reconnect-phases-3-5
Phase 1: satisfied | op:ping/op:pong in every codec plus heartbeat liveness, #1476
Phase 2: satisfied | session outbound queue + stall fault injector, #1478 (this PR's base)
Phase 3: satisfied | reconnect with Rekey: a partitioned session reconnects on a fresh handshake, the epoch advances, frames written into the partition arrive exactly once and in order on both sides, across successive reconnects, with both codecs (`packages/ocapn-noise/test/reconnect.test.js`); a CapTP call made into the partition is answered once on the new instance (`packages/ocapn-noise/test/integration.test.js`); hard-timeout abort, fail-fast writes, refusal by a peer that dropped the session, and graceful close without reconnect; a lost resume reply retried at the same epoch
Phase 4: deferred | reconnect with Resume; gated on Open question C1 and the cryptographic review (#1475), not settled by the maintainer
Phase 5: not-started | crossed-hellos tiebreaker on reconnect; stacked follow-up PR from the same job
Acceptance: partial | the design's reconnect, nonce-monotonicity (by Rekey), replay-idempotence, stale-epoch, cross-session RESUME refusal, and hard-timeout tests hold; crossed-hellos belongs to Phase 5
<!-- /garden-phase-evidence-ledger -->

### Security Considerations

- No `(key, nonce)` reuse: each transport instance has its own handshake and CipherStates.
- Resuming requires both the authenticated peer key and the session token (the opening handshake's transcript hash), sent inside the new encrypted channel. A hello from one session cannot resume another.
- A SYN for a peer with a resumable session cannot be refused before its hello, so each such peer holds at most one unproven inbound handshake; a replayed SYN cannot fill the inbound budget.
- The replay buffer holds about one heartbeat interval of traffic while connected, plus what the local side writes during a reconnect. The peer cannot grow it.

### Testing Considerations

Locally, concurrent ses-ava configs can hit an intermittent `ENOENT .cache/ava/import-from-project.mjs`; the affected files pass when run alone.

### Upgrade Considerations

Reconnect stays opt-in; without it a lost instance ends the session as in Phase 2. Honoring the hello's `features` bitset by default and the daemon wiring follow in a stacked PR.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

<!-- garden-job: endo-but-for-bots-ocapn-noise-session-reconnect-phases-3-5-phase-3 -->



----- END BODY -----
