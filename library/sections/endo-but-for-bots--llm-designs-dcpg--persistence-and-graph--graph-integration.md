---
title: Graph integration
source: designs/daemon-cross-peer-gc.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 1570e88926e0fe3146b30458b6148f33c76fe02a
source_date: 2026-04-29
source_authors: [Kris Kowal]
topics: [daemon, persistence]
status: current
parent: endo-but-for-bots--llm-designs-dcpg--persistence-and-graph
---

The local GC's "is this formula releasable?" check now consults
`retentionEdges` as one of its retention sources alongside pet-name
references and capability-graph reachability. A formula is releasable
iff:

1. No local pet name points to it.
2. No reachable formula references it in its `incarnates` field.
3. **No peer's set in `retentionEdges` contains it.**

The third clause is new with this design and is the only contribution
the cross-peer protocol makes to local GC — the wire-side machinery is
*entirely* about keeping that third clause accurate.

See [[endo-but-for-bots--llm-designs-drp--problem-and-overlapping-designs]]
for the local retention-path graph that names *why* a formula is
retained (pet-name vs. field vs. retention vs. transient); the peer-set
clause adds a fourth retention category — "retained by peer P" — that
the per-target API does not currently surface.
