---
title: TrafficClass and Priority
source: doc/design/trace.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [networking]
status: superseded
superseded_by: [cask--trace2--traffic-class-and-priority]
superseded_on: 2026-06-24
superseded_reason: trace2.md §6 restates this priority model and was ingested cycle 5. The successor section documents the `<<`/`>>` shift-operator discrepancy; this section's `>>` form is the canonical (internally consistent) one and is preserved here and in the codel-send-buffer-shedding concept.
---

> Abstract: CASK's scheduling/eviction priority model. **TrafficClass** is a one-byte number (0 to 128) classifying traffic. **Priority** is derived from the 128-bit (16-byte) Trace: `Trace >> (128 - TrafficClass)`. The two combine into a single 256-bit ordering key `(TrafficClass, Trace)` used for queueing and eviction: traffic with a *lower* TrafficClass and *lower* Trace is less likely to be superseded and evicted, maximizing overall system health (a lower TrafficClass means a larger shift, so the Trace occupies fewer significant bits). Traffic classes 0 through 5 are reserved for acknowledgements; the acknowledgement class for any other class is that class minus 5, on the rough theory that since acks are about 1/32 of traffic, giving them 32× the priority should suffice to suppress retries (the right figure is left to be measured empirically someday).

## TrafficClass and Priority

**TrafficClass** is a number from 0 to 128 (one byte). It classifies traffic.

**Priority** is a figure computed from Trace: `Trace >> (128 - TrafficClass)`.

- Trace is 128 bits (16 bytes). The shift is in bits; the result is used for ordering (queue or eviction).
- Traffic with a **lower** TrafficClass and **lower** Trace is less likely to be superseded and evicted, to maximize overall system health.
- Lower TrafficClass → larger shift → Trace occupies fewer significant bits → lexicographic `(TrafficClass, Trace)` ordering as a single 256-bit priority.

Traffic classes 0 through 5 are reserved for acknowledgements. The acknowledgement traffic class for any other traffic class is that class minus 5, on the theory that roughly 1/32 of all traffic is acks, so having 32× the priority should be sufficient to suppress retries. The right figure is left to be measured empirically later.

Source: [doc/design/trace.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/trace.md) at commit `cdb975d8`.
