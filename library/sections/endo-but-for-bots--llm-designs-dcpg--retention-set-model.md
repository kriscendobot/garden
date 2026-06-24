---
title: One-way retention set per peer (the model that replaced the CRDT)
source: designs/daemon-cross-peer-gc.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 1570e88926e0fe3146b30458b6148f33c76fe02a
source_date: 2026-04-29
source_authors: [Kris Kowal]
topics: [daemon, capability-security]
status: current
---

The cross-peer GC protocol is structured as a **per-peer retention set**
streamed in one direction.

For every peer P that this node has issued references *to*, this node
maintains the set:

```
retentionSet(P) = { formulaNumber : P currently holds a reference to this formula }
```

The retention set is **P's view, kept by us, of what we are obligated to
keep alive on P's behalf.** P is the authoritative writer of this set —
when P acquires a far ref to one of our formulas, P sends an `add`; when
P drops the last far ref, P sends a `remove`. We do not infer P's
retention from our own outgoing-message traffic, because the same far
ref can be aliased, snapshot, or passed onward inside P's address space
without our knowledge.

The set is **per-peer, not global.** If peers P and Q both hold a
reference to the same formula, both `retentionSet(P)` and
`retentionSet(Q)` contain that formula's number. The formula is GC-able
locally only when every peer's retention set has dropped it *and* there
is no local retainer (see
[[endo-but-for-bots--llm-designs-dcpg--persistence-and-graph]] for how
this fans into `formulaGraph.retentionEdges`).

The wire format is a stream of deltas, not a snapshot:

```typescript
type RetentionDelta = {
  add: string[];     // formulaNumbers newly retained
  remove: string[];  // formulaNumbers no longer retained
};
```

Snapshots are reconstructable by replaying every delta since session
start (or since the last persisted retention checkpoint after reconnect).
See [[endo-but-for-bots--llm-designs-dcpg--wire-and-batching]] for the
follower API and batching primitive, and
[[endo-but-for-bots--llm-designs-dcpg--crash-reconnect-and-revocation]]
for replay semantics across reconnects.

**Why this is not a CRDT:** there is no merge step. The receiver does
not reconcile incoming deltas with its own retention beliefs; it simply
applies them to its mirror of `retentionSet(P)`. Conflict resolution is
unnecessary because there is only one writer per set (the peer that owns
the references). See
[[endo-but-for-bots--llm-designs-dcpg--status-and-why-crdt-abandoned]]
for the abandoned bidirectional design and the asymmetry-of-authority
argument.
