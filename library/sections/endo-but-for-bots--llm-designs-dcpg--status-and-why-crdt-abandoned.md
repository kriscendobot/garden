---
title: Status, what shipped, and why the CRDT approach was abandoned
source: designs/daemon-cross-peer-gc.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 1570e88926e0fe3146b30458b6148f33c76fe02a
source_date: 2026-04-29
source_authors: [Kris Kowal]
topics: [daemon, capability-security]
status: current
notes: Sibling of [[endo-but-for-bots--llm-designs-drp--problem-and-overlapping-designs]] and [[endo-but-for-bots--llm-designs-rpn--problem-and-design-overview]] — those two cover the *local* retention-path graph (what a single daemon retains); this design covers the *cross-peer* protocol that propagates each side's retention set to the other so the *peer* can GC. Earlier draft used a bidirectional shared-namespace CRDT; superseded by a one-way "I tell you what I currently retain of yours" set.
---

The design is marked **In Progress** in the source. The retention-accumulator
primitive and `EndoGateway.followRetentionSet(peerNodeNumber)` API have
landed; the SQLite `retention` table at `daemon-database.js:87` and the
`formulaGraph.retentionEdges` map at `graph.js:69` are in place. What remains
is the long-tail of integrating retention events into every formula
incarnation site and the crash/reconnect replay path.

The original design contemplated a **bidirectional CRDT** in which both
peers maintained a shared namespace of "edges" and merged updates via vector
clocks. Two problems retired that approach:

1. **Asymmetry of authority.** Only the *holder* of a remote reference
   knows whether it is still retained. The remote node has no opinion on
   what the local node is keeping alive, so a symmetric CRDT was modelling
   half a fiction.
2. **No need for tie-breaking.** The whole point of a CRDT is converging
   on a shared truth under concurrent edits. Here there is no shared truth
   to converge on — each side's retention set is its own authoritative
   statement of what *it* currently holds. The peer's job is to replay
   that set, not negotiate with it.

The replacement is **one-way retention sets per direction**: each peer
streams its own `RetentionDelta`s to each other peer it has references
from. No vector clocks; no edge identities shared across the wire; the
peer is authoritative for what it currently holds of yours, and you GC
on its behalf when it drops a reference.

See [[endo-but-for-bots--llm-designs-dcpg--retention-set-model]] for the
design that replaced the CRDT.
