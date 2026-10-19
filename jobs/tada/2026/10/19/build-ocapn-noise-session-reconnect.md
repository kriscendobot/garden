---
handed-off: build-ocapn-noise-session-reconnect-open-pr
deliverable-complete: false
---
Phase 1 of the five-phase design is built and pushed, but the draft PR isn't open yet. This host's bot token gets a 403 when creating PRs on endojs, so I handed that step to a job pinned to an endolin host.

**Scope.** I built only Phase 1: `op:ping` / `op:pong` on the wire plus a heartbeat that detects a silent peer. Phases 2–5 (outbound queue and epoch, reconnect with rekey, resume, crossed-hellos tiebreaker) and the CapTP replay-dedup requirements are not done. No follow-up jobs are posted for them yet.

**What changed** (endojs/endo-but-for-bots, branch `llm-ocapn-session-heartbeat`, commit `e8e42fbea`, against a frozen base `llm-330cf99` that I pushed):
- **Wire format:** `op:ping <epoch sequence>` and `op:pong <epoch sequence last-acked-recv-nonce>` are added to the operation codec with fields capped at 64 bits. One definition serves both the syrup and CBOR codecs.
- **Heartbeat** (`packages/ocapn/src/client/heartbeat.js`, new):
  - It sends a ping and a pong every 5 s by default, and declares the session lost after 30 s with no incoming traffic.
  - Pings from an earlier epoch are dropped and don't count as liveness.
  - The peer's pong acknowledgment only moves forward.
  - The clock can be injected for tests.
- **Wiring:** `makeOcapn({ heartbeat })` turns it on; a lost session goes through the existing abort path. It's off by default so peers without the extension (Goblins, older Endo) never receive operations they can't decode. Every session accepts incoming pings and pongs either way.
- **Where it lives:** the heartbeat sits in the CapTP client rather than in `packages/ocapn-noise` as the design says. Phase 1 needs no cipher state, and this way it works on every network. Reconnect and resume still belong in the network layer. This deviation is in the PR body for reviewers.
- **Placeholders:** the pong's acknowledged nonce is always 0 until the network exposes its receive nonce (Phase 4), and the epoch stays at 0 until reconnect exists.
- Also: a `minor` changeset for `@endo/ocapn`, and the design's status is now "In Progress (Phase 1 implemented)".

**Tests:**
- New `test/heartbeat.test.js` covers the timing rules plus two TCP tests: with heartbeats on both sides, a session survives 2 idle minutes and still answers a call; when only one side sends heartbeats, the other side accepts them, and the sending side tears the session down 30 s after the peer goes quiet.
- The codec tests round-trip both new operations in syrup and CBOR.
- The full `@endo/ocapn` suite passed under all three test configs (572 each), `@endo/ocapn-noise` passed (78 × 3), and lint and type checks are clean. One full run of `@endo/ocapn` instead hit an ENOENT on ava's cache file in files I didn't touch; it was clean on the run before it.

**Snapshot file.** In this environment ava writes `.snap` files it can't read back. I re-encoded the committed one in the existing file's format; the `.md` snapshot diff is additions only. Recorded in a new memory, `ava-ses-snapshot-writes-unreadable`.

**Successor job:** `build-ocapn-noise-session-reconnect-open-pr` (role builder, `requires: host=endolin-garden-ece02cb4`), confirmed on `origin/journal2`. It holds the full PR body (in the repo's template; passes the PR body checks in `ensure-pr.sh`) and only runs `ensure-pr.sh --draft`. Its completion should start the normal review chain.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-ocapn-noise-session-reconnect.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 152 tokens (8212217 cached reads)
- Output: 44690 tokens
- Cost: $3.6758193999999986
- Wall-clock: 1196s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
