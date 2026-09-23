---
id: four-tables-coordinated-retention
aliases: ["four tables", "coordinated retention", "mirrored retention roots", "local agency CRDT", "petname CRDT", "remote-view table", "inviter and accepter tables"]
topics: [daemon, persistence, capability-security, ocapn]
---

# four-tables-coordinated-retention

The Endo Daemon's data model for cross-peer retention coordination.
When two peers are introduced through an out-of-band invitation flow,
four tables are constructed: a *local-agency* table and a *remote-view*
table on each side. Each local table serves the agency of its user; the
remote-view table is *never consulted for local retention decisions* —
the local user always has the final word on what is retained locally,
regardless of what the remote peer expects. The petname database
models the mirrored retention roots as a CRDT in shape (synchronized
when sessions are open between peers), but conflicts cannot occur
because each side is the authoritative writer of its own local table.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [dp/coordinated-retention-and-four-tables](../sections/endo--designs-dp--coordinated-retention-and-four-tables.md) | The user-facing data model: four tables (local + remote × inviter + accepter); introduction protocol; CRDT-in-shape; *local agency always authoritative*. |
| [dcpg/retention-set-model](../sections/endo-but-for-bots--llm-designs-dcpg--retention-set-model.md) | The wire-protocol layer that keeps the mirrored-tables data model honest: one-way `RetentionDelta` stream per peer per direction. |
| [dcpg/status-and-why-crdt-abandoned](../sections/endo-but-for-bots--llm-designs-dcpg--status-and-why-crdt-abandoned.md) | Why the wire protocol is *not* a bidirectional CRDT: asymmetry of authority — only the holder of a far ref knows whether it is still retained. |

## See also

- [[crdt-in-formula-persistence]] — where CRDT shapes show up and where they were rejected.
- [[retention-accumulator]] — the batching primitive that flushes deltas between the four tables.
- [[revocation-by-withdrawal]] — withdrawal on one side is authoritative for that side's local table.
