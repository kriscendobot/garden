# Gauntlet FIX round 1: endojs/endo-but-for-bots#1476

I applied the panel's must-fix items in two follow-up commits and pushed them to `build/ocapn-noise-session-reconnect-heartbeat` (`9175a5b5bb..b393a2002b`, fast-forward via `safe-push-pr-head.sh`). CI is green: 35/35 checks after one rerun of a failed macOS leg (details below).

## Must-fix items fixed

1. **Negative `op:pong` nonce and an uncaught throw in the heartbeat timer.** Raised by assessor, typist, archivist, saboteur, purist, spec-keeper, wire-watcher, engine-realist and breaker.
   - Before the peer's first frame is decrypted, a heartbeat tick now sends `op:ping` alone; the `op:pong` waits until there is a nonce to acknowledge.
   - The timer body is now wrapped (`tick`), so an encode or encrypt failure closes the session with an error instead of escaping `setInterval`.
   - `getLiveness().lastAckedRecvNonce` is now `bigint | undefined`. The doc comments in `types.d.ts` and on `countReceivedNonces` cover the nothing-received-yet case, and note that the session must decrypt through the wrapped `decrypt`.
2. **Malformed heartbeat frames were passed up as data** (spec-keeper). A frame labelled `op:ping` or `op:pong` that fails to parse, or has trailing bytes, now aborts the session with a "malformed heartbeat operation" error. Label peeking is split out into `isHeartbeatFrame`, with a comment on how Syrup and CBOR each lay out a record label.
3. **The changeset left out `@endo/ocapn-noise`** (curator). It now lists that package as `minor` and describes the `heartbeat` option, `HeartbeatOptions`, and `getLiveness()`, noting that anything implementing `OcapnNoiseSession` must add it. It also lists `OcapnHeartbeatOperationsCodecs` among the exports.
4. **The "close stops timers" test couldn't catch a timer leak** (prover). New serial tests wrap the global timer functions and check that every heartbeat and liveness timer is cleared on `close()`, on `reader.return`, and when the peer ends the stream. To check the test, I removed `stopHeartbeat()` from `fireOnClose`: the suite then hung until it was killed rather than passing. That is a failure, but not a clean assertion failure.

## Should-fix items also done
- In the heartbeat branch, `reader.return` and `reader.throw` now also release the transport reader, so the pump stops (breaker).
- New tests check that a malformed heartbeat aborts the session, that non-heartbeat frames (another record, raw bytes) still reach the session, and that `getLiveness` reports nonce 0 after the peer's greeting (prover).

## Local checks
In `@endo/ocapn-noise`: 90 tests pass in each of the three test configurations, and `tsc`, eslint and prettier are clean. The repo-root `tsc -p tsconfig.json` shows no ocapn errors.

## CI
- The first wait returned rc 3. The only failure was `test (24.x, macos-15)`, in `@endo/daemon`'s `test/http-content-plane.test.js`: an unhandled rejection, "Cannot assign to read only property 'message' of object 'ClientDestroyedError'", during HTTP client teardown.
- That test doesn't touch ocapn-noise, the Linux legs passed, and the same macOS leg passed on the previous head. So I took it for a flake and reran just the failed job once.
- The second wait returned rc 0: 35/35 green.

## Follow-ups
- That `http-content-plane` failure on macOS may be a recurring flake in the daemon's tests and could be worth its own look.
- Should-fix items left for a later round:
  - renaming `peerAckedRecvNonce`
  - typing the heartbeat read/write helpers instead of `any`
  - a bound on the `inbound` queue
  - checking the peer's acknowledged nonce against what this side actually sent

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1476-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 86 tokens (3787945 cached reads)
- Output: 21081 tokens
- Cost: $1.9802330000000004
- Wall-clock: 5156s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
