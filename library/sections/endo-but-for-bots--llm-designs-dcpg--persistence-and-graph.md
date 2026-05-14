---
title: SQLite retention table, formulaGraph.retentionEdges, and graph integration
source: designs/daemon-cross-peer-gc.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 1570e88926e0fe3146b30458b6148f33c76fe02a
source_date: 2026-04-29
source_authors: [Kris Kowal]
topics: [daemon, persistence]
status: current
---

The retention state lives in two coupled stores: an in-memory map for
hot access, and a SQLite table for crash survival.

## In-memory: `formulaGraph.retentionEdges`

At `graph.js:69`:

```js
formulaGraph.retentionEdges: Map<peerNodeNumber, Set<formulaNumber>>
```

This is the authoritative answer to "for peer P, which formulas of mine
is P currently holding?" It is read on every local GC pass (to decide
whether a formula is releasable) and is mutated by the event sources in
[[endo-but-for-bots--llm-designs-dcpg--event-sources-and-subscription]].
Each mutation is also fed into every active retention-accumulator on
that peer (see
[[endo-but-for-bots--llm-designs-dcpg--wire-and-batching]]).

## On-disk: SQLite `retention` table

At `daemon-database.js:87`:

```sql
CREATE TABLE retention (
  guest_public_key      TEXT NOT NULL,  -- peer node number
  retained_formula_number TEXT NOT NULL,
  PRIMARY KEY (guest_public_key, retained_formula_number)
);
```

The schema mirrors `retentionEdges` row-for-row. The table is the
durable shadow of the in-memory map — the in-memory map is the
authority during a session, the table is the authority after a crash.
Writes are coupled to the same mutation funnel so that an in-memory
add/remove always pairs with a SQL `INSERT`/`DELETE`. The SQL
operation is asynchronous; the in-memory mutation is synchronous; the
accumulator flushes only after the SQL commit so that a peer never sees
a delta we have not yet promised to remember after a crash. (Compare to
[[endo-but-for-bots--llm-designs-rpn--persistence-and-recovery]] — same
"in-memory-authoritative-during-session, on-disk-authoritative-across"
discipline.)

## Graph integration

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
