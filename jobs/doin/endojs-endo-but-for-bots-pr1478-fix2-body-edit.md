---
role: shepherd
tier: mentor
requires: host=endolin-garden-ece02cb4
dispatch: automatic
fallback-tier: minion
---
# Apply the round-2 pruner PR-body cuts to endojs/endo-but-for-bots PR #1478

https://github.com/endojs/endo-but-for-bots/pull/1478 — gauntlet fix-2 pushed the code
fixes (changeset + comment cuts, head c42a46273e5) but the oros-studio bot PAT gets 403 on
PR edits. Replace the PR body with EXACTLY the text between the markers below
(`gh pr edit 1478 -R endojs/endo-but-for-bots --body-file <file>`), first checking that the
live body still matches the old one apart from these edits (if someone else changed it,
apply only the four edits: drop the "Reconnection (Phases 3–5) belongs to…" sentence, drop
"That is what Phase 3 needs…", rewrite Documentation Considerations to name the new
changeset, drop the `_stall-injector.js` clause in Testing Considerations). Do nothing else.

----- BODY -----
<!-- garden-job: endo-but-for-bots-ocapn-noise-session-reconnect-phases-2-5 -->
Refs: #252, #1476

## Description

Phase 2 of `designs/ocapn-noise-session-reconnect.md` (on `llm`; design PR #252), stacked on the Phase 1 PR #1476: the session-level outbound queue and the simulated-stall fault injector, still on a single transport instance.

In heartbeat-enabled sessions only:
- The session queues plaintext frames and encrypts each one at hand-off to the transport, so Noise nonce order equals transport order however long a frame waits.
- `writer.next` resolves once the session accepts the frame, and waits only while the queue is at its 64-frame high-water mark. A transport write error ends the session and surfaces through the reader.
- A transport write held for less than `SESSION_TIMEOUT` is a stall, and the queue replays in order when it clears. A write held for `SESSION_TIMEOUT` is loss: the session fails with `transport write stalled for <n>ms; session lost`.

Sessions without heartbeats keep the direct write path.

<!-- garden-phase-evidence-ledger:v1 -->
## Phase and evidence ledger

Design: `designs/ocapn-noise-session-reconnect.md`
Disposition: orchestrated-slice
Successor: endo-but-for-bots-ocapn-noise-session-reconnect-phases-3-5
Phase 1: satisfied | #1476 (this PR's base)
Phase 2: satisfied | session outbound queue + stall fault injector; queued writes replay in order after a stall longer than HEARTBEAT_INTERVAL, and a stall longer than SESSION_TIMEOUT is reported as loss (`packages/ocapn-noise/test/session-queue.test.js`, both codecs)
Phase 3: not-started | owned by the successor
Phase 4: deferred | gated on Open question C1 and the cryptographic review (#1475); owned by the successor
Phase 5: not-started | owned by the successor
Acceptance: partial | Phase 2's own acceptance (stall-with-recovery vs. loss, in-order replay) holds; the reconnect-era tests belong to Phases 3–5
<!-- /garden-phase-evidence-ledger -->

### Security Considerations

The queue holds plaintext only in session memory and never consumes a nonce for a frame the transport has not taken in order. Its growth is bounded by writer backpressure at the high-water mark and in time by the write-stall timeout, so a peer that stops reading cannot exhaust memory.

### Scaling Considerations

One timer per in-flight write and one array per session; heartbeats coalesce, so a stall adds at most one ping/pong pair.

### Documentation Considerations

`.changeset/ocapn-noise-session-queue.md` records a `minor` bump for `@endo/ocapn-noise`: the heartbeat write semantics change and `SessionLiveness` gains two fields.

### Testing Considerations

See [`packages/ocapn-noise/test/session-queue.test.js`](https://github.com/endojs/endo-but-for-bots/blob/build/ocapn-noise-session-queue/packages/ocapn-noise/test/session-queue.test.js).

### Compatibility Considerations

The wire is unchanged from #1476, and heartbeats stay off by default.

### Upgrade Considerations

None. The capability bit, heartbeats on by default, and the daemon wiring stay with the successor job.

🤖 Generated with [Claude Code](https://claude.com/claude-code)


----- END BODY -----

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-16T22:28:14Z
