---
title: Event sources for retention changes and the subscription lifecycle
source: designs/daemon-cross-peer-gc.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 1570e88926e0fe3146b30458b6148f33c76fe02a
source_date: 2026-04-29
source_authors: [Kris Kowal]
topics: [daemon, async-flow]
status: current
---

A retention delta for peer P is emitted whenever an event causes a
formula's entry in `formulaGraph.retentionEdges[P]` to be added or
removed. Three source categories feed the accumulator:

1. **Inbound far-ref arrival.** When the daemon parses an incoming
   message and discovers a reference to one of *our* formulas, the
   sending peer is recorded as a retainer of that formula. (Note the
   inversion: a message *to* us from P that carries one of our formula
   numbers becomes an `add` to *our* `retentionSet(P)` mirror — we are
   noting P's hold on us.)
2. **Outbound far-ref departure / revocation.** When P explicitly
   revokes — by drop notification or by a release on the far ref —
   the corresponding entry is removed.
3. **GC-triggered drop.** When the peer's local GC determines a far
   ref is no longer reachable, it sends a release; same as case 2.

All three are funnelled through a single `formulaChangeTopic` so that
the retention-accumulator and graph-mutation logic have one mutation
surface to watch rather than three.

## Subscription lifecycle

Each `followRetentionSet(peerNodeNumber)` call attaches a fresh
accumulator + follower record to the peer entry in
`formulaGraph.retentionEdges`. The async iterator is the follower's
output. Lifecycle:

- **Start.** The follower receives an initial delta whose `add` lists
  every formula currently in `retentionEdges[peerNodeNumber]` (i.e. a
  cold-start snapshot expressed as adds). Subsequent deltas reflect
  only mutations.
- **Run.** Each tick of the retention-accumulator's flush yields one
  delta; if there is no change in a tick, no delta is yielded.
- **Stop.** Closing the iterator releases the accumulator. This is the
  only handle on the subscription — there is no separate `cancel`
  method; the iterator is the resource.

There is one accumulator per (follower, peer) pair. Multiple followers
on the same peer each get their own accumulator so that one slow
consumer cannot stall another.

See [[endo-but-for-bots--llm-designs-dcpg--persistence-and-graph]] for
the `formulaGraph.retentionEdges` map and the SQLite shadow.
