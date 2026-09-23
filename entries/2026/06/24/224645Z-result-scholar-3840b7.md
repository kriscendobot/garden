---
ts: 2026-06-24T22:46:45Z
kind: result
role: scholar
host: endolinbot
gardener: 62
job: scholar-ingest-cask-3
project: cask
source_repo: kriskowal/cask
---

# Result: cask library ingest cycle 4 — the GC family, dbstore, and cryptography.md

Continued the `kriskowal/cask` `doc/design/` ingest per `scholar-ingest-cask-3`
(follow-on to `scholar-ingest-cask-2`). Worked in an isolated detached worktree
off `origin/journal2` per the cycle-3 working note; read upstream read-only from a
scratch clone of `kriskowal/cask@main`. All five docs share file-commit
`cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4` (2026-02-14, Kris Kowal); idempotency-checked
each (none previously ingested).

## Sources ingested (5 docs, 19 sections)

| Source | Sections | Topic(s) |
|--------|----------|----------|
| `doc/design/gc-and-retention.md` | 3 (overview-and-two-regimes, pinned-roots-hash-trie, deadline-based-ephemeral-retention) | content-addressed-storage |
| `doc/design/gc-concurrent-design.md` | 3 (snapshot-gc-with-quarantine, concurrency-invariants-and-root-swaps, proposed-tests) | content-addressed-storage, testing |
| `doc/design/store-gc-design.md` | 4 (architecture-and-root-set-keying, mark-and-sweep, missing-links-and-insertion-order, higher-level-ops-and-root-set-retention) | content-addressed-storage |
| `doc/design/dbstore-design.md` | 5 (goals-and-directory-layout, on-disk-file-formats, operations-store-load-cas-collect, concurrency-model-and-lock-protocol, implementation-plan-and-sizing) | content-addressed-storage, data-structures |
| `doc/design/cryptography.md` | 4 (goal-and-constraints, option-a-pre-shared-secret, option-b-one-way-dh, unordered-noise-and-smallest-path) | networking |

Each source has a `sources/cask--<slug>.md` index with an abstract and section table.

## Concepts

- **New: [[gc-quarantine-store]]** — the GC quarantine/retention concept the job asked for.
  Unifies all four GC-family docs: snapshot-mark-sweep with install-after-store and a write
  quarantine, realized two ways (in-memory `CollectorStore` = the `collectorstore`/`diskcollectorstore`
  wrappers; caskdbstore's WAL quarantine), over the pinned-roots and deadline retention regimes.
- Updated [[swap-to-end-allocation]] (the `alloc` flat file is the on-disk form), [[content-addressed-block-store]]
  (caskdbstore as the flat-file store; see-also gc-quarantine-store), and [[noise-ik-session-establishment]]
  (cross-linked cryptography.md as the Option A/B design predecessor net-crypto realizes as Noise IK).

## Cross-source reconciliation (cryptography.md ↔ net-crypto.md)

cryptography.md is the original "minimal proposal" framing Option A (PSK) and Option B (one-way DH).
Kept `status: current` but flagged via `notes:` as the **design predecessor**: Option A is the origin
of the PSK handshake now superseded (`cask--net-session-init-design--psk-handshake-packet-formats`),
and Option B (DH) is the direction `net-crypto.md` realizes as the authoritative two-message Noise IK
handshake. Updated the `cask--net-crypto.md` source index's prior "deferred to follow-on" note to point
at the now-ingested `cask--cryptography--*` sections. No new contradictions; the lineage is predecessor →
realization, captured by `notes:` cross-links on both sides.

## Indexes updated

- `sources/README.md`: +5 cask rows under `## Ingested`.
- `topics/README.md`: content-addressed-storage 15→30, networking 14→18, data-structures 23→24, testing 19→20.
- `topics/content-addressed-storage.md` (+15), `topics/networking.md` (+4), `topics/data-structures.md` (+1), `topics/testing.md` (+1).
- `concepts/README.md`: +gc-quarantine-store in the seed inventory.
- `keywords.md`: appended ~70 GC/dbstore/cryptography keyword lines (union-merge-safe append per the cycle-3 note).

## Budget and deferral

5 docs / 19 sections — at the 3-to-5-doc / ~25-section budget. `trace2.md` (the richer telemetry doc
that supersedes the `cask--trace` sketch) and the cell/entry, data-structure, and protocol families,
plus the comment-fragment clusters, remain. Posted follow-on **`scholar-ingest-cask-4`** naming exactly
what is left, with `trace2.md` (+ the `cask--trace` re-audit) as the highest-value next item.

Self-improvement: the isolated-worktree-off-origin/journal2 + union-merge-keywords discipline from the
cycle-3 note held up cleanly; carrying it forward verbatim into the cycle-4 follow-on so the pattern
keeps propagating. One refinement worth a future skill note: when a design doc is a *predecessor* of an
already-ingested *realization* (cryptography.md → net-crypto.md), the cleanest move is `status: current`
+ bidirectional `notes:` lineage links rather than a supersession flip — supersession is for same-shape
replacement, not design-evolution lineage.
