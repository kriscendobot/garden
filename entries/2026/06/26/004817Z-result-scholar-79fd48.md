---
ts: 2026-06-26T00:48:17Z
kind: result
role: scholar
project: cask
refs:
  - jobs/tada/scholar-ingest-cask-18.md
---

# Scholar cycle 18 — cask `net/` comment-fragment lane: peer.go completed, noise.go ingested, relay.go below-bar

Job `scholar-ingest-cask-18`, follow-on to `scholar-ingest-cask-16` (cycle 17). Continued the cask `net/` comment-fragment ingest. The net Go source files still share the file-specific commit `cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4` (verified against the sparse scratch clone under the bot home); `cask--net-peer-go`'s recorded anchor matched, so the peer.go work is an in-place extension of an existing source, not a re-ingest.

## Sources ingested / extended

- **`cask--net-peer-go`** (extended in place, anchor unchanged `cdb975d8`; `section_count` 4 → 7). Added the three deferred Server/Peer clusters:
  - `cask--net-peer-go--server-receive-loop-and-encrypted-dispatch` (topics: networking) — `Start`/`handle`/`handleEncrypted`: the single read goroutine, the first-four-bytes plaintext-handshake-vs-encrypted fork, graceful-shutdown handler tracking, `ErrReplayDetected` log suppression, decrypt → `UpdatePeerAddr` mobility → inner-command dispatch.
  - `cask--net-peer-go--responder-handshake-consistency-and-authorization` (topics: networking, capability-security) — `Server.handleInit`: the ed25519↔x25519 consistency check, the `statusNotAuthorized` member-table gate, the 24h TTL cap, the responder mutual `MemberAdd`. Responder counterpart to cycle-17's `session-renewal-single-flight`. Carries the cycle-16 `DefaultBestTrafficClass` TODO as a known unfinished feature (not stale comment).
  - `cask--net-peer-go--encrypted-acknowledge-batching` (topics: networking) — `noteEncryptedAcknowledge`/`flushEncryptedAcknowledgesLocked`: per-session grouping, batch-or-deadline flush, average-holdback computation folded into the store-ack so the remote keeps its RTT sample honest.
  - `net/peer.go` is now **complete** for the comment-fragment lane.
- **`cask--net-noise-go`** (new source; 3 sections; anchor `cdb975d8`). The `Noise_IK_25519_ChaChaPoly_BLAKE2b` implementation, ingesting only the implementation-specific clusters that add over the design-doc / concept coverage (soft-flag check passed: cross-referenced rather than restated):
  - `cask--net-noise-go--noise-ik-handshake-state-machine` (networking) — the IK token ladder, `noiseState` (ck/h/k), `mixHash`/`mixKey`, `encryptAndHash`/`decryptAndHash` transcript discipline, directional `split` (reversed on responder).
  - `cask--net-noise-go--noise-hkdf-and-aead` (networking) — the Noise two-output HKDF from three HMAC-BLAKE2b invocations, the hand-rolled HMAC-BLAKE2b, the ChaCha20-Poly1305 little-endian-counter nonce. Flags the handshake nonce vs the big-endian transport replay counter distinction.
  - `cask--net-noise-go--ed25519-x25519-key-conversion` (networking, capability-security) — private via SHA-512-of-seed + clamp, public via the birational `u=(1+y)/(1-y)` Montgomery-u map (`edwards25519.BytesMontgomery`).

## Surveyed below-the-add-bar (recorded so the next cycle does not re-survey)

- **`net/relay.go`** (~239 lines) — the loss/delay test relay (opaque encrypted-traffic forwarder). Longest consecutive `//` run is the 5-line `Relay` type comment (lines 14-18); everything else is short per-method godoc. **Below the ≥8-consecutive-line longform bar.** Joins `blob/chunker.go` and `sendbuffer/buffer.go` as recorded-below-bar.

## Indexes updated

- `sources/README.md`: peer-go row 4 → 7 sections + subject; new noise-go row.
- `sources/cask--net-peer-go.md`: `section_count` 4 → 7, 3 new rows, notes/abstract/provenance updated to "complete".
- `sources/cask--net-noise-go.md`: new.
- `topics/README.md`: networking 50 → 56, capability-security 187 → 189; networking abstract extended.
- `topics/networking.md`: +6 rows. `topics/capability-security.md`: +2 rows.
- `concepts/README.md`: cycle-18 deepening notes on `noise-ik-session-establishment`, `casknet-wire-protocol`, `member-table-authorization`.
- `concepts/noise-ik-session-establishment.md`: +5 section rows (3 noise + responder-handshake + receive-loop), +~30 aliases.
- `concepts/member-table-authorization.md`: +1 section row (responder-handshake), +aliases.
- `concepts/casknet-wire-protocol.md`: +2 section rows (receive-loop, ack-batching), +aliases.
- `keywords.md`: +47 keyword lines (append-only union).

## Drift watch

No new comment-vs-code drift found. Two pre-existing items remain as recorded: the cycle-16 `buildInitPacket` 144B-vs-176B layout-comment lag (in `cask--net-crypto-go`, candidate upstream comment-fix) and the explicit `handleInit` `DefaultBestTrafficClass` TODO (known unfinished feature, now captured in `cask--net-peer-go--responder-handshake-consistency-and-authorization`). The scholar does not push upstream.

## Corpus state and remaining work

Cask corpus now **43 sources / 173 sections** (was 42 / 167: +1 source `cask--net-noise-go`, peer-go extended in place not added; +6 sections — 3 peer-go + 3 noise-go). The cask comment-fragment `net/` lane is **complete**: crypto.go (cycle 16), peer.go (cycles 17-18), noise.go (cycle 18) ingested; relay.go below-bar; chunker.go and buffer.go below-bar. No follow-on `net/`-lane job posted — the lane is drained. Any future cask comment-fragment work would survey non-`net/` packages fresh.

Self-improvement: nothing this time. The cycle followed the established comment-fragment conventions and the carried working-note discipline (uniquely-suffixed worktree, idempotency anchor check, in-place source extension) without friction.
