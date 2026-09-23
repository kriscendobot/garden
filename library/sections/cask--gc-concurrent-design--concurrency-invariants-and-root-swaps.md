---
title: Concurrency, Invariants, Root Swaps, and the GC API
source: doc/design/gc-concurrent-design.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [content-addressed-storage]
status: current
---

> Abstract: The safety contract for concurrent GC under live root swaps. Root swaps are allowed at any time: a new root installed during GC is **not part of this cycle** unless it was already reachable from the snapshot root `Rs`, and safety is preserved by install-after-store plus quarantine. Seven invariants govern the system: **I1 root atomicity** (no torn root values), **I2 install-after-store** (publish a root only after all its reachable blocks are stored, including quarantine flush), **I3 snapshot GC safety** (never delete a block reachable from `Rs`), **I4 operation stability** (an operation from a valid root completes using only that root's reachable blocks, even during GC), **I5 epoch monotonicity** (root epochs strictly increase per swap), **I6 link integrity** (blocks are immutable and fully written before visible), and **I7 quarantine visibility** (blocks written during GC are invisible to sweep until the quarantine flushes). GC passes are mutually exclusive and idempotent: a request while a pass runs returns the same completion channel. The idiomatic-Go API is `Collect(ctx, root) <-chan struct{}`, closed when the pass ends; if a pass is already running, `Collect` returns the existing channel.

## Concurrency & Root Swaps

Root swaps are allowed at any time. If a new root `R1` is installed during GC, it is **not part of this cycle** unless it is reachable from `Rs`. Safety is preserved by **I2 (install-after-store)** and **quarantine**.

## Invariants

- **I1. Root atomicity** — Root is read and written atomically; no torn or mixed values.
- **I2. Install-after-store** — A new root may be published only after all blocks reachable from that root are fully stored (including quarantine flush).
- **I3. Snapshot GC safety** — GC must not delete any block reachable from the snapshot root `Rs`.
- **I4. Operation stability** — Any operation that starts from a valid root must complete using only blocks reachable from that root, even during GC.
- **I5. Epoch monotonicity** — Root epochs strictly increase with each swap.
- **I6. Link integrity** — Stored blocks are immutable and fully written before becoming visible.
- **I7. Quarantine visibility** — Blocks written during GC must not be visible to sweep; they are only visible after the GC pass completes and the quarantine flushes.

## GC Pass Coordination

GC passes are **mutually exclusive**. Any GC request while a pass is in flight returns the **same** completion channel. GC requests return a `chan struct{}` that is **closed** when the pass ends. This makes GC calls idempotent and easy to synchronize in Go.

## GC API (idiomatic Go)

Provide a method named **Collect** (or **GC**) that returns the completion channel and accepts the snapshot root to collect from:

```
Collect(ctx, root) <-chan struct{}
```

If a pass is already running, `Collect` returns the existing channel.

Source: [doc/design/gc-concurrent-design.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/gc-concurrent-design.md) at commit `cdb975d8`.
