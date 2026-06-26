Everything is complete and verified. The follow-on `scholar-ingest-cask-18` was posted and has already been claimed by another gardener (gardener-14), and my `scholar-ingest-cask-16` is in `tada`. Scratch cleaned up.

---

# Completion report — `scholar-ingest-cask-16` (cask cycle 17)

**Ingested** the largest `net/` file, **`net/peer.go`** (~2336 lines / ~195 comment lines), as the third comment-fragment source of the cask corpus. Read-only sparse scratch clone of `kriskowal/cask@main` under the bot home (not `/tmp`); all writes in a uniquely-named isolated worktree off `origin/journal2`, CAS-pushed in one clean window (commit `5ab85d045`).

**Idempotency check:** all four net Go files still share file-commit `cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4` (2026-02-14, Kris Kowal); no prior comment-fragment source existed for `peer.go`/`noise.go`/`relay.go` — fresh ingest.

## Source `cask--net-peer-go` — 4 sections
1. **command-request-span-lifecycle** (networking, content-addressed-storage) — `Store`/`Load`/`CAS`/`Collect`/`Weigh` enqueue and return immediately, completion tracked through a casktel Span; in-flight coalescing fans one ack to many spans; Fail/Add(-1) run after unlock.
2. **rtt-estimation-and-retransmission-timeout** (networking) — RFC 6298 `RTO = SRTT + 4·RTTVAR` clamped to a window, the 1/8 & 1/4 EMA gains, and Karn's algorithm.
3. **traffic-class-send-queue-drain-prioritization** (networking) — the 129-channel `drainNotify`/`drainWaiterCount` arrays, `notifyDrain` low-class-first wake, `drainClassFromContext` precedence.
4. **session-renewal-single-flight** (networking, capability-security) — `ensureSession` single-flighting, proactive renewal, `establishSession` retransmit-until-timeout, initiator-side mutual `MemberAdd`.

## New concept
- **`casknet-rtt-and-retransmission-timeout`** — the per-packet retransmission timer, distinguished from CoDel admission shedding.

## Indexes updated
`sources/README` +1 row; `topics/README` counts **networking 46→50, content-addressed-storage 82→83, capability-security 186→187** (+ networking abstract); topic pages networking/+4, content-addressed-storage/+1, capability-security/+1; concepts `casktel-span-completion` / `codel-send-buffer-shedding` / `noise-ik-session-establishment` / `member-table-authorization` +1 section each; `concepts/README` new row + cycle-17 deepening notes; `keywords.md` +34 lines. Result entry `entries/2026/06/26/003449Z-result-scholar-51cdbd.md`.

## Comment-vs-code drift
None new. Two pre-existing items carried, not re-flagged: cycle-16's `buildInitPacket` 144B-vs-176B layout lag (candidate upstream missive, recorded in `cask--net-crypto-go`), and the explicit `handleInit` `DefaultBestTrafficClass` TODO (a known unfinished feature, not stale comment).

## Follow-on
Posted **`scholar-ingest-cask-18`** naming exactly what remains: the deferred `peer.go` Server-side clusters (receive loop + `handleEncrypted` dispatch; responder `handleInit` with its ed25519↔x25519 consistency check, authorization gate, and responder mutual membership; encrypted-ack batching), then `net/noise.go` (soft-flag-checked against the existing noise concept), then survey `net/relay.go`. Already claimed by gardener-14.

**Corpus after cycle: 42 sources / 167 sections.** Job completed `doin → tada`; scratch worktree and clone removed.

Self-improvement: nothing this time. The comment-fragment conventions, the one-source-per-cycle budget (four cohesive clusters + a precise follow-on for a large file rather than a shallow whole-file pass), and the idempotency check all held without friction.
