---
source: designs/daemon-cas-management.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 100774ffa0193df27dc87c7df6095afda419a57f
source_date: 2026-04-17
source_authors: [Kris Kowal]
ingested: 2026-06-03
ingested_by: scholar
section_count: 1
status: current
notes: |
  Thirty-second-comment-style design ingest. 398-line *In
  Progress* design (created 2026-04-17) by Kris Kowal in commit
  `100774ffa` (the same commit cycle 119's daemon-capability-bus
  references — *docs(designs): Endor architecture, SQLite,
  makeArchive, and supporting designs*). Phases 1-4 implemented
  in `rust/endo/src/cas.rs`; Phase 5 (JS manager integration)
  remains.

  Makes the daemon's content-addressable store (CAS) a *first-
  class subsystem of endor* (cycle 119's Rust supervisor).
  Replaces the current flat-directory-of-opaque-blobs CAS at
  `{statePath}/store-sha256/` with a typed, retain/release-
  managed, GC-collected subsystem.

  §Four-requirements frame:
    (1) typed content (blob/snapshot/tree/archive)
    (2) read/write verbs through the envelope bus
    (3) retain/release reference-counting protocol
    (4) off-thread garbage collection

  Single most structurally interesting move: §supervisor-owned
  vs worker-owned decision. Four reasons supervisor wins: shared
  resource (worker would double envelope-bus latency);
  supervisor owns filesystem paths; GC requires handle-liveness
  knowledge supervisor has; supervisor can run GC on background
  thread. §future-worker-option preserved as alternative
  (envelope verbs identical; only handler location differs).
  The §verbs-are-the-same-interface discipline.

  §Four content types: blob / snapshot (XS machine signature) /
  tree (JSON manifest + child hashes) / archive (compartment-
  map archive). §`.meta` sidecar JSON `{type, refs}`. §Type-
  field-is-advisory (Design Decision 4): content is self-
  describing; type avoids re-parsing but is not authoritative.

  §Tree representation as flat-entries-map with hash references
  (Design Decision 5): enables §structural sharing between
  archives that share dependencies; §stable hash (nested
  objects would change hashes based on internal structure).

  §Seven envelope verbs (all control messages to handle 0):
    cas-store / cas-fetch / cas-has / cas-retain / cas-release /
    cas-store-tree / cas-gc. Plus §streaming-variants
    cas-store-stream + cas-content-stream for large content
    (avoid buffering in single envelope). retain/release are
    fire-and-forget (nonce: 0). §Worker-lifecycle integration:
    supervisor auto-retains hashes for suspended workers,
    releases on resume/cancellation.

  §Mark/sweep GC algorithm: (1) Mark from suspended workers'
  snapshot hashes + explicit retain counts + JS manager formula
  store roots (via cas-gc-roots verb); (2) Sweep with
  tree-recurse-children-first; (3) Report. §Reference-counting-
  not-tracing (Design Decision 3): simple and deterministic;
  retain/release maps naturally to worker lifecycles. §Hybrid-
  shape: base mechanism ref-counting; JS side contributes roots.
  §New-stores-are-safe-during-GC: refs=0 on store, missed
  content caught in next cycle (§eventual-consistency-of-GC).

  §Three GC triggers: cas-gc control verb / configurable timer
  (e.g., every 10 min) / explicit `endor gc` CLI subcommand.

  §Off-thread GC: dedicated `std::thread` or
  `tokio::spawn_blocking` so the supervisor's routing loop
  doesn't block during GC sweeps.

  §ContentStore Rust struct: `refs: RwLock<HashMap<String,
  u32>>` for §in-memory-ref-count-cache-flushed-to-meta
  discipline (hot path doesn't touch filesystem; cold flushes
  are atomic write-rename).

  §Five Design Decisions codify: supervisor-owned / sidecar-not-
  database / reference-counting-not-tracing / type-field-
  advisory / flat-tree-paths-with-hash-references. Design
  Decision 2 names §sidecar-not-database: *a SQLite metadata
  table would be faster for large stores but adds a dependency
  and crash-recovery complexity. Sidecar files are atomic
  (write-rename), human-readable, and sufficient for the
  expected store size (thousands of entries, not millions)*.

  §Three Dependencies: daemon-content-store-gc (**supersedes**:
  this Rust-native replaces the earlier JS-side GC);
  daemon-xs-worker-snapshot (**integrates**: snapshots become
  typed CAS entries with retain/release); daemon-endor-
  architecture (**extends**: supervisor gains CAS management).

  Cycle 141 was nominally papers-lane (cycle 140 was comments).
  Papers-lane has been blocked for 35+ consecutive cycles. Cycle
  141 pivoted to designs-lane. Fifth daemon-* design after
  endopi-* family closure (cycles 133 + 135 + 137 + 139 + 141).
---

> Abstract: `daemon-cas-management.md` (398 lines, *In
> Progress*) makes the daemon's CAS a *first-class subsystem of
> endor*. §Four-requirements: typed content / read-write
> envelope verbs / retain-release protocol / off-thread GC.
>
> **The single most structurally interesting move**: the
> §supervisor-owned-vs-worker-owned decision. Supervisor wins
> because shared resource + filesystem paths + GC handle-liveness
> + background-thread feasibility. Worker option preserved (the
> §verbs-are-the-same-interface discipline lets the choice be
> operational, not architectural).
>
> §Four content types (blob / snapshot / tree / archive) with
> §`.meta` sidecar JSON. §Type-field-is-advisory (content self-
> describing). §Flat-entries-map tree representation enables
> §structural sharing + §stable hash.
>
> §Seven envelope verbs (all control to handle 0); §streaming-
> variants for large content; §fire-and-forget retain/release.
> §Mark/sweep GC: ref-counting + JS-manager-roots hybrid;
> §off-thread execution; §new-stores-are-safe-during-GC.
>
> §ContentStore Rust struct with `RwLock<HashMap>` in-memory
> ref-count cache, flushed to `.meta` sidecar (atomic
> write-rename).
>
> §Five Design Decisions codify the structural choices.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [content-address-store-as-supervisor-owned-subsystem-with-typed-content-retain-release-and-background-mark-sweep-gc](../sections/endo-but-for-bots--llm-designs-daemon-cas-management--content-address-store-as-supervisor-owned-subsystem-with-typed-content-retain-release-and-background-mark-sweep-gc.md) | daemon | current |

Tight 398-line *In Progress* design. The four-requirements +
supervisor-ownership-decision + seven-verbs + mark-sweep-GC
form one coherent CAS-subsystem story. One cohesion-honest
section.

## Provenance

- Fetched 2026-06-03 from
  `endojs/endo-but-for-bots@100774ffa` (the branch `origin/llm`)
  via the local bare-clone. Same commit as cycle 119's
  daemon-capability-bus.
- Created 2026-04-17 by Kris Kowal in commit `100774ffa`
  (*docs(designs): Endor architecture, SQLite, makeArchive,
  and supporting designs*).
- Status: *In Progress* (Phases 1-4 implemented; Phase 5
  remaining).
- **Thirty-second-comment-style design ingest.** Fifth daemon-*
  design after the endopi-* family closure (cycles 133 + 135 +
  137 + 139 + 141). Pairs with cycle 119's capability-bus
  (envelope-protocol substrate this CAS rides on), cycle 78's
  daemon-content-store-gc (the JS-side GC this design
  supersedes), and cycle 137's daemon-message-streaming
  (sibling §streaming-on-CapTP discipline).
- Cycle 141 was nominally **papers-lane** (cycle 140 was
  comments). Papers-lane has been blocked for **35+ consecutive
  cycles** due to lack of PDF-fetching infrastructure. Cycle 141
  pivoted to designs-lane.
- One cohesion-honest section.
