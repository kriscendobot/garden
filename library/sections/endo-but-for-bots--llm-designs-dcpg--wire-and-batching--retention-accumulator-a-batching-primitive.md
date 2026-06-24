---
title: "Retention-accumulator: a batching primitive"
source: designs/daemon-cross-peer-gc.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 1570e88926e0fe3146b30458b6148f33c76fe02a
source_date: 2026-04-29
source_authors: [Kris Kowal]
topics: [daemon, async-flow, eventual-send]
status: current
parent: endo-but-for-bots--llm-designs-dcpg--wire-and-batching
---

Naively emitting one delta per `retentionEdges` mutation produces
thousands of single-element messages — every `add`/`remove`/`add`
cancels its own predecessor. The retention-accumulator is a tiny
buffering primitive whose entire purpose is to collapse such churn:

```js
const makeRetentionAccumulator = () => {
  const adds = new Set();
  const removes = new Set();

  return {
    add(n)    { if (removes.has(n)) removes.delete(n); else adds.add(n); },
    remove(n) { if (adds.has(n))    adds.delete(n);    else removes.add(n); },
    drain()   { /* returns {add: [...adds], remove: [...removes]}, then clears */ },
  };
};
```

Three rules:

1. `add` after a pending `remove` cancels the `remove` (and vice versa)
   so the wire never carries spurious churn.
2. Repeated `add`s or `remove`s of the same formula collapse to one
   (Set semantics).
3. `drain()` returns the accumulated delta and resets, so the caller
   controls flush cadence.

Flush is driven by the next-tick microtask (per pending follower) so
that within a single synchronous batch of graph mutations — e.g. a
multi-message arrival that adds and then revokes the same far ref —
only the net effect crosses the wire.

See [[endo-but-for-bots--llm-designs-dcpg--event-sources-and-subscription]]
for what feeds the accumulator and
[[endo-but-for-bots--llm-designs-dcpg--persistence-and-graph]] for the
graph mutations that produce the events.

The shape is a deliberate echo of
[[endo-but-for-bots--llm-designs-drp--daemon-surface-and-subscription]]'s
`RetentionPathDelta = {snapshot} | {added, removed}` and
[[endo-but-for-bots--llm-designs-rpn--subscription-and-follow-protocol]]'s
microtask-coalesced subscription pattern — *coalesce-then-deliver* is
the daemon-wide async-flow convention for retention-graph events.
