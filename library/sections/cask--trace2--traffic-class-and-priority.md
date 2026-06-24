---
title: TrafficClass and Priority (unchanged from TRACE.md)
source: doc/design/trace2.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [networking]
status: current
supersedes: [cask--trace--traffic-class-and-priority]
notes: trace2.md §6 restates the trace.md priority model and labels it "unchanged from TRACE.md", but writes the shift as `Trace << (128 - TrafficClass)` (left) where trace.md wrote `Trace >> (128 - TrafficClass)` (right). The right-shift form is the internally consistent one (lower TrafficClass → larger shift → fewer significant Trace bits → smaller value → higher priority / less likely evicted); the `<<` here reads as a transcription slip. Captured below; the codel-send-buffer-shedding concept keeps the `>>` form.
---

> Abstract: trace2.md's restatement of CASK's scheduling/eviction priority model, labelled "unchanged from TRACE.md". **TrafficClass** is one byte, 0–128, default 5. **Priority** is computed from the 128-bit Trace and the TrafficClass into a 256-bit (or comparable) value where *lower value = higher priority, less likely to be evicted*. Traffic classes 0–5 are reserved for acknowledgements, and the ack class for any traffic class `T` is `T - 5`. Note: §6 writes the shift as `Trace << (128 - TrafficClass)` (left shift) whereas the predecessor trace.md wrote `Trace >> (128 - TrafficClass)` (right shift). The right-shift form is the internally consistent one (a lower TrafficClass produces a larger shift, leaving the Trace with fewer significant bits and thus a smaller value, hence higher priority); the left-shift here is most likely a transcription slip in an otherwise "unchanged" restatement.

## TrafficClass and Priority (as written in trace2.md §6)

- **TrafficClass**: 0–128 (one byte). Default 5.
- **Priority**: `Trace << (128 - TrafficClass)` (256-bit or comparable); lower value = higher priority, less likely to be evicted.
- Traffic classes 0–5 reserved for acks; the ack class for traffic class `T` is `T - 5`.

## Reconciliation with trace.md

trace2.md §6 is headed "unchanged from TRACE.md", and the priority semantics it states are indeed the same as trace.md's: a single 256-bit `(TrafficClass, Trace)` ordering key where lower TrafficClass and lower Trace traffic is least likely to be evicted, with ack classes 0–5 and ack-class = `T - 5`. The one divergence is the shift operator: trace.md wrote `Trace >> (128 - TrafficClass)` (right shift) and explained it ("lower TrafficClass → larger shift → Trace occupies fewer significant bits → lexicographic `(TrafficClass, Trace)` ordering"). trace2.md §6 and §1.3 write `Trace << (128 - TrafficClass)` (left shift), which contradicts the shared "lower value = higher priority, lower TrafficClass less likely evicted" claim (a left shift would make a lower TrafficClass produce a *larger* value). The right-shift form is therefore canonical; this is a candidate comment-vs-doc cleanup if the cask design docs are ever revised upstream.

For the full priority model (the 1/32-of-traffic ack rationale, the per-class backpressure, the parallel-array buffers the heaps order), see the predecessor [cask--trace--traffic-class-and-priority](cask--trace--traffic-class-and-priority.md) (now superseded by this section) and the [codel-send-buffer-shedding](../concepts/codel-send-buffer-shedding.md) concept page, which retains the `>>` form.

Source: [doc/design/trace2.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/trace2.md) at commit `cdb975d8`.
