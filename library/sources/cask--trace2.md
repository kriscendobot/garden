---
source: doc/design/trace2.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
section_count: 7
status: current
supersedes_source: cask--trace
notes: The comprehensive casktel design; supersedes the trace.md sketch (sources/cask--trace.md, now status superseded). §6 restates trace.md's priority model with a `<<`/`>>` shift-operator slip noted in the traffic-class-and-priority section.
---

> Abstract: The comprehensive design for CASK's telemetry packages `casktel`, `nopcasktel`, and `buffercasktel`, and the structural changes that let storage systems use `casktel.Span` to track completion of large fire-and-forget tasks. casktel defines the **Tracer** (`Trace`/`Nice`) and the **Span**: identity (Trace, SpanID, TrafficClass, Priority), cancellation, **numerator/denominator progress** (`Add`/`Progress`/`Done`-finalizes-on-first-call), error recording, and optional Zap-style logging. **nopcasktel** is the no-allocation/no-goroutine path; **buffercasktel** is a fixed-size parallel-array sampling buffer with priority eviction (high-priority spans parasitically evict low-priority spans and their log blocks) and an aggregator `Flush`. The storage integration names two layered store methods, sync `Store` and async `StoreWithSpan`, with sync stores gaining the async path by embedding `casktel.SpanDriver` (or via the `StoreWrapper` fallback); Peer, dir, blob, and io all drive the Span. §6 restates the TrafficClass/Priority model; §8 makes a Span mandatory for `dir.Store`. This document supersedes the `trace.md` interface sketch.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [casktel-package-interfaces](../sections/cask--trace2--casktel-package-interfaces.md) | networking | current |
| [nopcasktel-no-cost-tracer](../sections/cask--trace2--nopcasktel-no-cost-tracer.md) | networking | current |
| [buffercasktel-sampling-buffer-and-eviction](../sections/cask--trace2--buffercasktel-sampling-buffer-and-eviction.md) | networking, data-structures | current |
| [span-as-storage-completion-abstraction](../sections/cask--trace2--span-as-storage-completion-abstraction.md) | networking, content-addressed-storage | current |
| [traffic-class-and-priority](../sections/cask--trace2--traffic-class-and-priority.md) | networking | current |
| [file-layout-and-implementation-order](../sections/cask--trace2--file-layout-and-implementation-order.md) | networking | current |
| [dir-store-span-contract-and-test](../sections/cask--trace2--dir-store-span-contract-and-test.md) | networking, content-addressed-storage | current |

## Provenance

- Repository default branch `main`; file last modified 2026-02-14 by Kris Kowal, sharing the corpus-wide `doc/design/` commit `cdb975d8`.
- **Supersedes** `doc/design/trace.md` (source-index `cask--trace`, now `status: superseded`): trace2.md is the polished, comprehensive successor to that raw notes sketch. Its §1 interface material supersedes the sketch's `tracer-interface-and-telemetry-buffer` section's interface half; its `buffercasktel` section supersedes the buffer half; its §6 supersedes the sketch's `traffic-class-and-priority` section.
- The `<<` vs `>>` shift-operator discrepancy between §6 and trace.md is documented in [cask--trace2--traffic-class-and-priority](../sections/cask--trace2--traffic-class-and-priority.md) (the right-shift form is canonical).

Source: [doc/design/trace2.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/trace2.md) at commit `cdb975d8`.
