---
title: Crash, reconnect, and revocation semantics
source: designs/daemon-cross-peer-gc.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 1570e88926e0fe3146b30458b6148f33c76fe02a
source_date: 2026-04-29
source_authors: [Kris Kowal]
topics: [daemon, capability-security, persistence]
status: current
---

## Crash recovery on the local side

When the daemon restarts, `formulaGraph.retentionEdges` is rebuilt by
reading every row of the SQLite `retention` table. This gives us, for
each peer P, the formula set as of our last commit. Because the
in-memory map is regenerated *before* any far-ref handshake, the local
GC always has an accurate retention picture even before any peer
reconnects.

## Reconnect on the peer side

When a peer P reconnects after a network partition or restart,
`followRetentionSet(P)` is re-called. The fresh subscription yields a
cold-start delta whose `add` is the full current
`retentionEdges[P]`. P's daemon, on the receiving side, treats this
as a **complete restatement** of P's retention picture rather than an
incremental update — P discards its previous mirror and rebuilds it
from the incoming `add` list. This is the protocol's substitute for
checkpoint-and-replay: every reconnect is a full snapshot expressed as
adds; subsequent deltas are incremental.

Importantly, **no vector clocks or sequence numbers are needed.** The
local side is the authoritative writer of its own retention set, and
the receiver always re-snapshots on reconnect, so there is no question
of stale or out-of-order deltas to reconcile.

## Revocation

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

## Comparison summary

| Aspect | Bidirectional CRDT (abandoned) | One-way retention set (current) |
|---|---|---|
| Writers per peer-pair | Both sides | One side (the holder) |
| Tie-break mechanism | Vector clocks per edge | None needed |
| Reconnect semantics | Merge with last-seen vector | Re-snapshot, discard prior |
| Revocation mechanism | Tombstone + GC pass | Same as removal — a `remove` delta |
| Wire shape | Edge identities + clock | Pair of `Set<formulaNumber>` |
| Why | Asymmetric authority does not need a CRDT | (chosen) |

See [[endo-but-for-bots--llm-designs-dcpg--status-and-why-crdt-abandoned]]
for the design history.
