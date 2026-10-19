I opened draft PR **endojs/endo-but-for-bots#1508**, which builds phase 1 of `ocapn-noise-session-reconnect`. All 20 CI checks pass on the final head `88fb7ea1b9` (the rest were skipped as not applicable).

- **PR:** head branch `llm-ocapn-session-heartbeat-phase-1`, base the frozen snapshot `llm-92b91a7` (the same commit as `llm` at claim time). It isn't stacked on anything in flight.
- **New operations:** `op:ping <epoch sequence>` and `op:pong <epoch sequence last-acked-recv-nonce>` now go over the wire in both the Syrup and CBOR codecs (`packages/ocapn/src/codecs/operations.js`). Their fields use a new `Uint64Codec` that rejects values outside the unsigned 64-bit range.
- **Heartbeat:** the new `packages/ocapn/src/client/heartbeat.js` follows the design:
  - Each side sends a ping and a pong on its own clock (defaults 5 s / 30 s).
  - Any incoming message resets the timeout. A timeout shorter than three intervals is rejected.
  - The acknowledged nonce carried in `op:pong` can only go up, so a replayed pong can't lower it.
- **Opt-in switch:** a new experimental `makeOcapn({ heartbeat })` option, off by default because the two operations are still awaiting OCapN review.
  - When the peer goes silent, the session is aborted through the existing abort path; reconnecting is phase 2+.
  - The epoch is always 0 in this phase.
  - Without a Noise cipher, the acknowledged nonce defaults to a count of incoming messages; a Noise network can supply the real one through `getLastAckedRecvNonce`.
- **Tests:**
  - Both codecs round-trip the new operations, including the 64-bit maximum, and reject out-of-range values.
  - Unit tests drive the heartbeat with a manual clock.
  - Two integration tests on the tcp-test-only transport: an idle session stays up when both sides send heartbeats, and a silent peer is detected in about 1 s.
- **Changeset:** `@endo/ocapn` minor.
- **CI fix:** the first push failed the `cover (24.x)` check. The idle-session test used a 100 ms timeout and a fixed sleep, which the slower coverage run overran. The second commit widens the timings and polls for the heartbeat messages instead of sleeping.
- **Snapshot workaround:** on this host, `ses-ava --update-snapshots` writes the binary `.snap` file in a form that won't read back. I regenerated `operations.test.js.snap` and re-encoded its byte data with a throwaway script outside the repo. The readable `.md` snapshot diff only adds six entries. Anyone else regenerating ocapn snapshots on this host will hit the same thing.

**Follow-ups:**
- The gauntlet should now run automatically on completion.
- Phases 2–5 are still to do: session epoch and outbound queue, reconnect with a fresh handshake, reconnect with the existing cipher state (blocked on the design's open question C1), and the tiebreaker when both sides reconnect at once.
- The heartbeat capability flag in the handshake is deferred to the network-layer phases.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-ocapn-noise-session-reconnect-phase-one.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 158 tokens (10326655 cached reads)
- Output: 42969 tokens
- Cost: $4.242502999999999
- Wall-clock: 2933s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
