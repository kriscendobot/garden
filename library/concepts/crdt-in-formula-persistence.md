---
id: crdt-in-formula-persistence
aliases: ["CRDT", "CRDT in formula persistence", "petname CRDT", "bidirectional CRDT", "CRDT abandoned", "asymmetry of authority", "no shared truth to converge on"]
topics: [daemon, persistence, capability-security]
---

# crdt-in-formula-persistence

Where CRDT shapes do and do not appear in Formula Persistence.

**Where CRDT shape is used.** The petname database models mirrored
retention roots between two introduced peers as a CRDT in *shape* —
synchronized when sessions are open, eventually consistent in the data-
shape sense. Conflicts cannot occur because each side is the
authoritative writer of its own local table (see
[[four-tables-coordinated-retention]]).

**Where a bidirectional CRDT was abandoned.** An earlier design for the
cross-peer retention protocol used a bidirectional shared-namespace
CRDT with vector clocks per edge. It was retired in favour of a
*one-way retention set per peer per direction* because **retention
authority is asymmetric** — only the holder of a far ref knows whether
it is still retained. There is no shared truth to converge on; each
side's retention set is its own authoritative statement of what *it*
currently holds. The peer's job is to *replay* that set, not to
*merge* with it.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [dp/coordinated-retention-and-four-tables](../sections/endo--designs-dp--coordinated-retention-and-four-tables.md) | Where CRDT *shape* is used — petname DB as CRDT-shaped data structure synced across peer sessions; local agency authoritative. |
| [dcpg/status-and-why-crdt-abandoned](../sections/endo-but-for-bots--llm-designs-dcpg--status-and-why-crdt-abandoned.md) | Where a bidirectional CRDT was *rejected* — asymmetry of authority + no shared truth means no merge step needed. |
| [dcpg/retention-set-model](../sections/endo-but-for-bots--llm-designs-dcpg--retention-set-model.md) | The replacement design — one-way retention set per peer per direction; receiver replays rather than merges. |

## See also

- [[four-tables-coordinated-retention]] — the data model where CRDT shape lives.
- [[retention-accumulator]] — the wire-level coalescing primitive that is *not* a CRDT.
