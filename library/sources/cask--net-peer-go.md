---
source_kind: comment-fragment
source_repo: kriskowal/cask
source_path: net/peer.go
source_line_range: "1-2336"
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
comment_subject: The casknet Peer and Server — the span-tracked request lifecycle, the RFC 6298 / Karn's-algorithm retransmission timer, the traffic-class send-queue drain prioritization, and the single-flight session-renewal handshake
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-26
ingested_by: scholar
section_count: 4
status: current
notes: |
  Third comment-fragment source of the cask `net/` package (cycle 17), following
  the root `cask.go` (cycle 15) and `net/crypto.go` (cycle 16). `net/peer.go` is
  the largest net file (~2336 lines, ~195 comment lines); this cycle ingested
  four cohesive clusters from the Peer's outbound-flow machinery. The remaining
  clusters (the Server receive loop and handleEncrypted dispatch, the
  responder-side handleInit ed25519<->x25519 consistency check + authorization +
  responder mutual membership, the encrypted-acknowledge batching) plus
  net/noise.go and net/relay.go are deferred to follow-on job
  scholar-ingest-cask-18.
---

> Abstract: `net/peer.go` is the outbound-flow and server-dispatch core of the `casknet` package — the largest file in `net/` (~2336 lines). The `Peer` controls the flow of encrypted messages to one remote address; the `Server` listens, decrypts, and dispatches inbound commands. This cycle ingested four cohesive comment clusters from the `Peer` side: (1) the **span-tracked request lifecycle** — `Store`/`Load`/`CAS`/`Collect`/`Weigh` enqueue and return immediately, tracking completion through a casktel Span, with in-flight coalescing and a Fail-outside-lock rule; (2) the **RFC 6298 retransmission timer** — smoothed RTT and variance EMAs, `RTO = SRTT + 4·RTTVAR` clamped to a configured window, and Karn's algorithm excluding retransmitted-packet samples; (3) the **traffic-class send-queue drain prioritization** — a 129-channel per-class drain-notify array that wakes the highest-priority blocked writer when a slot frees; and (4) the **single-flight session renewal** — `ensureSession` serializes concurrent callers so one handshake runs while the rest wait, renews proactively before expiry, retransmits the init packet over unreliable UDP, and adds the responder to the member table for mutual membership.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [command-request-span-lifecycle](../sections/cask--net-peer-go--command-request-span-lifecycle.md) | networking, content-addressed-storage | current |
| [rtt-estimation-and-retransmission-timeout](../sections/cask--net-peer-go--rtt-estimation-and-retransmission-timeout.md) | networking | current |
| [traffic-class-send-queue-drain-prioritization](../sections/cask--net-peer-go--traffic-class-send-queue-drain-prioritization.md) | networking | current |
| [session-renewal-single-flight](../sections/cask--net-peer-go--session-renewal-single-flight.md) | networking, capability-security | current |

## Provenance

- Fetched 2026-06-26 from `kriskowal/cask@main` (file-specific commit `cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4`, 2026-02-14, Kris Kowal) via a sparse scratch clone under the bot home.
- Third comment-fragment ingest of the cask corpus and the second of the `net/` package; follows the root `cask.go` (cycle 15) and `net/crypto.go` (cycle 16).
- The `peer.go` comments are the implementation-side orchestration around the casknet protocol the design docs (`cask--net-design`, `cask--net-crypto`, `cask--net-session-init-design`) describe in prose; the sections cross-reference those and the sibling `cask--net-crypto-go` rather than restating them.
- Deferred to follow-on `scholar-ingest-cask-18`: the remaining `peer.go` clusters (Server receive loop + `handleEncrypted` dispatch; responder-side `handleInit` with its ed25519↔x25519 consistency check, authorization, and responder mutual membership; the encrypted-acknowledge batching) and the unstarted `net/noise.go` and `net/relay.go`.
