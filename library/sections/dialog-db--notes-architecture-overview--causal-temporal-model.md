---
title: Causal temporal model
source: notes/architecture overview.md
source_repo: dialog-db/dialog-db
source_commit: f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [local-first-sync, change-propagation]
status: current
---

> Abstract: Unlike databases with a single global timeline, DialogDB uses a **causal temporal model** (a [B-theory-of-time] view): facts exist in their own causal timelines rather than a universal one, each fact can causally reference the predecessor facts it supersedes, multiple independent causal chains coexist and later merge, and retractions mark facts invalid from that point in the causal timeline forward. Time is expressed through causal relationships between facts, not wall-clock timestamps. This buys flexible history (query as-of any point), auditability (full preserved history), disconnected operation (devices evolve timelines independently), and conflict resolution (divergent timelines merge by strategy).

Unlike databases with a single global timeline, DialogDB employs a [causal temporal model][B-theory-of-time], where:

- Facts exist in their own causal timelines rather than in a universal timeline.
- Each fact can causally reference predecessor facts it supersedes.
- Multiple independent causal chains can coexist and later merge.
- Retractions mark facts as invalid from that point in the causal timeline forward.
- Time is expressed through **causal relationships** between facts, not through wall-clock timestamps.

This causal model offers several advantages:

- **Flexible history**: query data as of any point in the causal timelines.
- **Auditability**: the complete history is preserved, showing exactly how data evolved.
- **Disconnected operation**: different devices can evolve timelines independently.
- **Conflict resolution**: divergent timelines can be merged using various strategies.
- **Flexible querying**: query across attributes that weren't planned for initially.
- **Progressive enhancement**: schema can evolve organically as needs change.

The move from wall-clock ordering to causal reference is what lets independent replicas make progress offline and reconcile deterministically later — the temporal counterpart to the content-addressed storage layer's deterministic tree layout.

Source: [notes/architecture overview.md](https://github.com/dialog-db/dialog-db/blob/f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53/notes/architecture%20overview.md) at commit `f777fe7c`.

[B-theory-of-time]: https://en.wikipedia.org/wiki/B-theory_of_time
