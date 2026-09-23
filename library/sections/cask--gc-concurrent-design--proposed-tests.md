---
title: Proposed Tests for Concurrent GC
source: doc/design/gc-concurrent-design.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [content-addressed-storage, testing]
status: current
---

> Abstract: The test plan that validates the concurrent-GC invariants. It needs general infrastructure (an instrumented store that can delay `Store`/`Load`/`List`/delete, an atomic root reference for concurrent swaps, and a `CollectorStore` wrapper that quarantines writes during GC into a separate quarantine store) and four cross-cutting tests applicable to every CASK structure: **install-after-store enforcement** (delay a leaf store, attempt an early root swap, expect an invariant violation), **snapshot GC under concurrent root swap** (start GC on `R0`, build and swap to `R1` mid-GC, verify all `R0`-reachable blocks survive and `R1` is readable after), **concurrent read during GC** (a read from `R0` completes without missing blocks while GC runs with snapshot `R0`), and **epoch monotonicity** (rapid parallel swaps assert strictly-increasing epochs and a consistent snapshot). Structure-specific tests then exercise blob (append), blob with CDC (byte insertion forcing new chunk boundaries), dir (add/remove entry), and array (Keep/Skip/Inject), each verifying `R0` access during GC and `R1` access after the swap.

## General infrastructure

- Instrumented store that can delay `Store`, `Load`, `List`, and delete.
- Atomic root reference for concurrent swaps.
- CollectorStore wrapper that quarantines writes during GC using a separate quarantine Store.

## Cross-cutting tests (all structures)

1. **Install-after-store enforcement** — Delay a leaf store. Attempt to swap root early; expect failure or invariant violation.
2. **Snapshot GC under concurrent root swap** — Start GC on `R0`. Build `R1` from `R0`, swap root during GC. Verify all blocks reachable from `R0` are retained. Verify `R1` is readable after swap.
3. **Concurrent read during GC** — Start read from `R0`. Run GC with snapshot `R0`. Read completes without missing blocks.
4. **Epoch monotonicity** — Swap roots rapidly in parallel with GC start. Assert epochs strictly increase and snapshot is consistent.

## Structure-specific tests

- **blob** — Append to create `R1` from `R0` while GC runs. Ensure `R0` load succeeds during GC, `R1` after swap.
- **blob (CDC)** — Apply a byte insertion to force new chunk boundaries. `ReadAt` on `R0` during GC succeeds; `ReadAt` on `R1` after swap succeeds.
- **dir** — Add/remove an entry to create `R1`. `ls` or `checkout` from `R0` during GC succeeds; `R1` after swap succeeds.
- **array** — Transform `R0` via Keep/Skip/Inject. `Get` from `R0` during GC succeeds; `Get` from `R1` after swap succeeds.

Source: [doc/design/gc-concurrent-design.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/gc-concurrent-design.md) at commit `cdb975d8`.
