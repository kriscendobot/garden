---
ts: 2026-06-26T00:34:49Z
kind: result
role: scholar
project: cask
refs:
  - library/sources/cask--net-peer-go.md
---

# Scholar cycle 17 — cask `net/peer.go` comment-fragment ingest (job `scholar-ingest-cask-16`)

Continued the comment-fragment lane of the cask ingest with the largest `net/` file, `net/peer.go` (the casknet `Peer`/`Server`, ~2336 lines / ~195 comment lines). The four net Go files still share the file-specific commit `cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4` (2026-02-14, Kris Kowal); idempotency-checked against `origin/journal2` — no prior comment-fragment source existed for `peer.go`, `noise.go`, or `relay.go`, so this was a fresh ingest. Because the file is large, this cycle ingested four cohesive Peer-side comment clusters and posted a follow-on (`scholar-ingest-cask-18`) naming exactly what remains, per the "first faithful pass, defer the rest" budget rule.

## Source ingested

`cask--net-peer-go` (kriskowal/cask, `net/peer.go`, commit `cdb975d8`) — **4 sections**:

1. `cask--net-peer-go--command-request-span-lifecycle` (networking, content-addressed-storage) — the Peer's public operations (`Store`/`Load`/`CAS`/`Collect`/`Weigh`) enqueue and return immediately, tracking completion through a casktel Span (`Add(1)` on enqueue, `Add(-1)` on ack, `Fail(err)+Add(-1)` on error); duplicate in-flight stores of one hash coalesce so one ack fans out to many spans; request/response ops block on a per-`spanID` channel; the Fail/Add(-1) callbacks run after the peer lock releases.
2. `cask--net-peer-go--rtt-estimation-and-retransmission-timeout` (networking) — the RFC 6298 retransmission timer: SRTT/RTTVAR exponential moving averages with the canonical 1/8 and 1/4 gains, `RTO = SRTT + 4·RTTVAR` clamped to a configured `[min,max]` window, and Karn's algorithm excluding samples from retransmitted packets.
3. `cask--net-peer-go--traffic-class-send-queue-drain-prioritization` (networking) — a full send queue blocks `Store` callers per TrafficClass on 129 per-class `drainNotify` channels + `drainWaiterCount` atomics; `notifyDrain` scans class 0 upward and wakes the highest-priority blocked waiter; `DefaultDrainTrafficClass = 64`; `drainClassFromContext` precedence (explicit TrafficClass → Span.TrafficClass → default); notify-after-unlock ordering.
4. `cask--net-peer-go--session-renewal-single-flight` (networking, capability-security) — `ensureSession` single-flights concurrent callers (one performs the Noise IK handshake, the rest wait on a channel and retry), renews proactively before expiry (default TTL 1h, margin 1m), and `establishSession` retransmits the init packet every 500ms over unreliable UDP until a response or a 10s timeout, then adds the responder to the member table (initiator-side mutual membership).

`peer.go` is the implementation-side **orchestration** around the casknet protocol; sections cross-reference the design-doc concepts and the sibling `cask--net-crypto-go` rather than restating the handshake or the wire formats.

## New concept

- `concepts/casknet-rtt-and-retransmission-timeout.md` — the RFC 6298 + Karn's-algorithm per-peer retransmission timer. New material with no prior concept page: the design docs describe protocol reliability but do not pin the timer algorithm. Distinguished from `codel-send-buffer-shedding` (the other casknet timer: admission shedding vs per-packet retransmission).

## Indexes touched

- `sources/README.md` — new `cask--net-peer-go` row.
- `topics/README.md` — counts: networking 46 → 50, content-addressed-storage 82 → 83, capability-security 186 → 187; networking abstract extended.
- `topics/networking.md` (+4 rows), `topics/content-addressed-storage.md` (+1: span-lifecycle), `topics/capability-security.md` (+1: session-renewal).
- `concepts/casktel-span-completion.md` — +1 section (the Peer consumer).
- `concepts/codel-send-buffer-shedding.md` — +1 section (the enqueue-side drain machinery, the implementation source-of-truth for its `drainNotify`/`notifyDrain` keywords).
- `concepts/noise-ik-session-establishment.md` — +1 section (initiator-side orchestration).
- `concepts/member-table-authorization.md` — +1 section (initiator side of mutual `MemberAdd`).
- `concepts/README.md` — new `casknet-rtt-and-retransmission-timeout` row + cycle-17 deepening notes on the four touched concepts.
- `keywords.md` — appended 34 keyword lines (RFC 6298 / RTO / SRTT / RTTVAR / Karn's algorithm / `RTTStats` / `retransmissionTimeoutLocked`; `drainClassFromContext` / `DefaultDrainTrafficClass`; `ensureSession` single-flight / `establishSession` / session renewal margin / `sessionInitTimeout`; mutual membership initiator; in-flight coalescing / fire-and-forget UDP store).

## Comment-vs-code drift

None new in the four ingested clusters; the comments match the code. One pre-existing **explicit TODO** noted but not flagged as drift: `Server.handleInit` hardcodes `casksessiontable.DefaultBestTrafficClass` with a `// TODO: look up the member's best traffic class from the member table.` — a known unfinished feature, not a stale comment. The cycle-16 `buildInitPacket` 144B-vs-176B drift remains the open candidate missive (recorded in `cask--net-crypto-go`); not re-surfaced here.

## Remaining net/ material (follow-on `scholar-ingest-cask-18` posted)

Deferred to cycle 18:
- The remaining `peer.go` clusters: the `Server` receive loop + `handleEncrypted` dispatch; the responder-side `handleInit` (the ed25519↔x25519 consistency check, the member-table authorization gate, and the responder-side mutual `MemberAdd`); the encrypted-acknowledge batching (`noteEncryptedAcknowledge` / `flushEncryptedAcknowledgesLocked`).
- `net/noise.go` (~395 lines / ~53 comment lines) — soft-flag-check the Noise IK implementation against the existing `noise-ik-session-establishment` concept and the `cask--net-crypto` / `cask--net-session-init-design` design-doc sources before ingesting; take only the implementation-specific clusters that add over those (the `NoiseIKInitiator`/`NoiseIKResponder` state machine, `encryptAndHash`/`decryptAndHash`, `Split()`, the ed25519↔x25519 conversion).
- `net/relay.go` (~239 lines / ~10 comment lines) — survey for any ≥8-consecutive-line comment block; otherwise record as below-bar.

`blob/chunker.go` and `sendbuffer/buffer.go` remain confirmed below-bar (cycle 15); `cask.go` (cycle 15) and `net/crypto.go` (cycle 16) already ingested. Do not re-survey.

Corpus after this cycle: **42 sources / 167 sections**. Topic counts: content-addressed-storage 83, data-structures 54, capability-security 187, networking 50, repository-governance 52.

Self-improvement: nothing this time. The comment-fragment conventions, the one-source-file-per-cycle budget (split a large file into four cohesive clusters + a precise follow-on rather than a shallow whole-file pass), and the idempotency check all held without friction.
