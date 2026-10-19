---
arc: endo-ocapn-background
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
requires: host=endolin-garden-ece02cb4
---
Open the DRAFT PR for the already-pushed builder work of job `build-ocapn-noise-session-reconnect-phase-two` (session-reconnect Phase 2: session epoch and send queue, stacked on endojs/endo-but-for-bots#1502). Host oros-studio-garden-ce242c49 cannot create PRs on endojs (PAT 403 on createPullRequest), hence this host pin. No code work is needed.

- repo: endojs/endo-but-for-bots
- head: `llm-ocapn-session-send-queue` (commit df210891a, already pushed)
- base: `llm-ocapn-session-heartbeat-e8e42fb` (frozen snapshot of #1502's head e8e42fbea, already pushed)

Steps: get a project checkout with `ensure-project-worktree.sh <this-job-base> endojs/endo-but-for-bots llm-ocapn-session-send-queue`, cd into it (the phase-evidence gate resolves designs from cwd), write the PR body below verbatim to a file, and run:

    ensure-pr.sh build-ocapn-noise-session-reconnect-phase-two endojs/endo-but-for-bots llm-ocapn-session-send-queue llm-ocapn-session-heartbeat-e8e42fb --title "feat(ocapn): session send queue and epoch (session-reconnect Phase 2)" --body-file <file>

It must be a DRAFT. Name the opened PR URL in your completion report so the gauntlet is staged.

----- PR BODY -----
Refs: #1502

## Description

Phase 2 of `designs/ocapn-noise-session-reconnect.md`: the session epoch and send queue, with the simulated-stall fault consumer. Stacked on #1502 (Phase 1 heartbeat), against the frozen base `llm-ocapn-session-heartbeat-e8e42fb`.

- **`packages/ocapn/src/client/send-queue.js`** (new, the file to review most closely). Every serialized CapTP operation a session sends passes through a session-level outbound queue that also owns the session epoch.
  - It is transparent while the transport writes synchronously: the operation goes straight to `write`, and a synchronous failure still reaches the caller.
  - When `write` returns a pending promise (a stalled transport), later operations wait behind it in order and drain one write at a time when it settles. A failed drain write aborts the session. Liveness is still the heartbeat's decision.
  - `advanceEpoch(write)` binds the next transport instance and replays every operation not known to have left, including the one in flight (at-least-once, with dedupe per design § 4). Nothing calls it yet; Phase 3's reconnect will.
- The **heartbeat** now reads its epoch from the session (`getEpoch`) instead of a private constant.
- **`ocapn.js`** sends through the queue, closes it on abort, and exposes it as `_debug.sendQueue` (debug mode only) for fault injection.
- The **fault injector**, `test/_stall-injector.js`, wraps a transport write so it holds the bytes and returns a pending promise until `release()`, the way a TCP write blocks on a full send buffer.
- `test/_manual-timer.js` is the heartbeat tests' manual clock, moved out so both test files can use it.
- The design doc gets a Phase 2 status note.

### Security Considerations

There are no new authorities and no new trust boundaries. Queued bytes are the same plaintext CapTP serialization the session already wrote, held in the session's own memory. The epoch-advance replay is at-least-once, so Phase 3 must land with the receiver-side dedupe the design requires before anything calls `advanceEpoch`.

### Scaling Considerations

The queue is unbounded during a stall, but a stall is bounded by `SESSION_TIMEOUT`, after which the heartbeat aborts the session and drops the queue. Without a heartbeat, a transport that never settles a write would let the queue grow; today's netlayers write synchronously, so this does not happen.

### Documentation Considerations

The Phase 2 status is in the design doc. There is no user-facing API change: `sendQueue` appears only on the experimental `_debug` surface.

### Testing Considerations

`packages/ocapn/test/send-queue.test.js` adds:
- Unit tests: write-through, synchronous failure propagation, ordered accumulation and replay, enqueueing during a drain, a drain failure closing the queue once, close dropping pending work and ignoring late settlements, an epoch advance replaying on the next instance, and `interposeWriter`.
- Integration tests on the real TCP test netlayer, with manual heartbeat clocks:
  - A 20 s write stall (longer than `HEARTBEAT_INTERVAL`, 5 s, but shorter than `SESSION_TIMEOUT`, 30 s): an `op:deliver` and the heartbeats pile up in A's queue and both sessions stay up. On release the call resolves and the session continues.
  - A 35 s stall: B's heartbeat declares loss, both sides tear down, and A's queue is dropped.

The full `@endo/ocapn` suite passes (582 tests). `yarn lint:types` is clean and eslint reports no errors.

### Compatibility Considerations

Nothing changes on the wire, and with synchronous netlayers the behavior is the same as before.

### Upgrade Considerations

None. The queue is per session and in memory only, with no persisted state.

<!-- garden-job: build-ocapn-noise-session-reconnect-phase-two -->

🤖 Generated with [Claude Code](https://claude.com/claude-code)
----- END PR BODY -----

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-19T22:41:18Z
