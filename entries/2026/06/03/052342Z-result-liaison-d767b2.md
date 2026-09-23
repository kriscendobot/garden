---
ts: 2026-06-03T05:23:42Z
host: endolin
role: liaison
kind: result
dispatch_id: liaison--d767b2
cycle: 141
---

# Cycle 141 — daemon-cas-management.md (Kris Kowal, endo-but-for-bots) — fifth daemon-* after endopi closure

Ingested `designs/daemon-cas-management.md` (398 lines, *In
Progress* status, Phases 1-4 implemented) from
`endojs/endo-but-for-bots@100774ffa` (branch `origin/llm`).
**Thirty-second-comment-style design ingest.** One cohesion-
honest section:

- **content-address-store-as-supervisor-owned-subsystem-with-
  typed-content-retain-release-and-background-mark-sweep-gc** —
  makes the daemon's content-addressable store a *first-class
  subsystem of endor* (cycle 119's Rust supervisor).

## The single most structurally interesting move

The §supervisor-owned-vs-worker-owned decision. The supervisor
wins because:

1. CAS is a shared resource — a worker would double envelope-
   bus latency
2. Supervisor already owns the filesystem paths
3. GC requires handle-liveness knowledge supervisor has
4. Supervisor can run GC on a background thread

§Future-worker-option preserved (envelope verbs identical;
only handler location differs).

## §Four-requirements frame

1. Typed content (blob / snapshot / tree / archive)
2. Read/write envelope verbs
3. Retain/release reference-counting protocol
4. Off-thread garbage collection

## §Seven envelope verbs

All control messages (handle 0): `cas-store` / `cas-fetch` /
`cas-has` / `cas-retain` / `cas-release` / `cas-store-tree` /
`cas-gc`. Plus §streaming-variants `cas-store-stream` and
`cas-content-stream` for large content.

## §Mark/sweep GC

§Hybrid ref-counting + JS-manager-roots; §off-thread execution;
§new-stores-are-safe-during-GC (refs=0 on store; missed content
caught next cycle — the §eventual-consistency-of-GC pattern).

## §Five Design Decisions

1. Supervisor-owned, not a worker
2. Sidecar `.meta` files, not a database
3. Reference counting, not tracing GC
4. Type field is advisory
5. Tree entries use flat paths with hash references

## Rotation note

Cycle 141 was nominally **papers-lane** (cycle 140 was
comments). Papers-lane has been blocked for **35+ consecutive
cycles**. Cycle 141 pivoted to designs-lane. **Fifth daemon-*
design after endopi-* family closure** (cycles 133 + 135 + 137
+ 139 + 141).

## Counts

- 644 → **645** sections (+1).
- 185 → **186** source documents (+1).
- Topic pages updated: `daemon.md` (+1 row).
- Keywords index extended with ~37 CAS-specific keywords.
- Sources/README.md updated (+1 row).
- Sections/README.md updated (+1 group; total adjusted).

## Next cycle

Cycle 142 wakes in 1500s. Rotation lands on **chat-lane**
nominally (still exhausted at 20/20). Many candidate paths
remain (daemon-* family still has ~20 unexplored designs;
familiar-* + gateway-* + hardened-* clusters partially
explored).
