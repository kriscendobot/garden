---
title: "On-disk: SQLite `retention` table"
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
