---
source: doc/design/trace.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
section_count: 2
status: current
---

> Abstract: An early design-notes sketch of CASK's telemetry and priority model. It outlines the `casktel` tracer interface (Trace/Nice, Span with TrafficClass/Priority/Cancel and Zap-style logging), a no-op `nopcasktel`, and a `buffercasktel` whose fixed-size parallel-array buffer lets high-priority spans parasitically evict lower-priority spans and their log blocks. It then defines the priority model that the README's load-shedding section references: TrafficClass is a one-byte (0–128) class, Priority is `Trace >> (128 - TrafficClass)`, and `(TrafficClass, Trace)` forms a 256-bit ordering key for queue and eviction decisions, with classes 0–5 reserved for acknowledgements (ack class = class − 5).

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [tracer-interface-and-telemetry-buffer](../sections/cask--trace--tracer-interface-and-telemetry-buffer.md) | networking | current |
| [traffic-class-and-priority](../sections/cask--trace--traffic-class-and-priority.md) | networking | current |

## Provenance

- Repository default branch `main`; file last modified 2026-02-14 by Kris Kowal. The file is a raw notes sketch, ingested as the current statement of the casktel design.
- A richer successor `doc/design/trace2.md` (22 KB) exists and is deferred to a follow-on `scholar-ingest-cask` job; when ingested it will likely supersede the interface sketch here while this priority-model section remains canonical.

Source: [doc/design/trace.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/trace.md) at commit `cdb975d8`.
