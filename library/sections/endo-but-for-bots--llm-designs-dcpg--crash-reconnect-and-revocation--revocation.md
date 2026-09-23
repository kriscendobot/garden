---
title: Revocation
source: designs/daemon-cross-peer-gc.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 1570e88926e0fe3146b30458b6148f33c76fe02a
source_date: 2026-04-29
source_authors: [Kris Kowal]
topics: [daemon, capability-security, persistence]
status: current
parent: endo-but-for-bots--llm-designs-dcpg--crash-reconnect-and-revocation
---

Explicit revocation of a far ref by P is just an event-source case
(see
[[endo-but-for-bots--llm-designs-dcpg--event-sources-and-subscription]]):
P's drop notification reaches us, we remove the formula from
`retentionEdges[P]`, the accumulator yields a `remove`, the SQL row is
deleted, and on the next local GC pass the formula becomes a
release-candidate (assuming the other two clauses hold; see
[[endo-but-for-bots--llm-designs-dcpg--persistence-and-graph]]).

There is no separate revocation channel — the same one-way retention
set conveys "I am letting go" as a `remove`, and that *is* the
revocation. This collapses what a CRDT design would have split into
"tombstone gossip" + "live-set merge" into a single mutation type.
