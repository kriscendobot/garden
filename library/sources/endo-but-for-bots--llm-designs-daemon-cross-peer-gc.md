---
source: designs/daemon-cross-peer-gc.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 1570e88926e0fe3146b30458b6148f33c76fe02a
source_date: 2026-04-29
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
section_count: 6
status: current
notes: The **cross-peer protocol** sibling of `daemon-retention-paths.md` and `retention-path-notation.md` (both ingested cycle 42–45) — those describe the *local* retention-path graph (what *we* are holding, broken down by reason); this describes the *remote* protocol (what *peers* are holding *of us*, propagated so we can GC on their behalf). Earlier draft of this design was a bidirectional CRDT; superseded internally by a one-way per-peer retention set per direction. Critical primitive: the retention-accumulator, which collapses add/remove churn within a microtask before flushing — same coalesce-then-deliver shape as daemon-retention-paths' RetentionPathDelta subscription.
---

> Abstract: Cross-peer garbage collection via a **one-way retention set per peer per direction**. For each peer P that holds references to our formulas, we mirror P's retention set as `formulaGraph.retentionEdges[P]: Set<formulaNumber>` (in memory) backed by a `retention(guest_public_key, retained_formula_number)` SQLite table. The wire protocol exposes `EndoGateway.followRetentionSet(peerNodeNumber): AsyncIterable<RetentionDelta>` where `RetentionDelta = {add: string[], remove: string[]}`. A retention-accumulator primitive collapses churn within a microtask (add-then-remove cancels). The model **replaced** an earlier bidirectional CRDT design because retention authority is asymmetric — only the holder of a far ref knows whether it is still retained — so no merge step is needed. Reconnect = cold-start `add` of the full current set; revocation = same as a `remove`; no separate tombstone channel.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [status-and-why-crdt-abandoned](../sections/endo-but-for-bots--llm-designs-dcpg--status-and-why-crdt-abandoned.md) | daemon, capability-security | current |
| [retention-set-model](../sections/endo-but-for-bots--llm-designs-dcpg--retention-set-model.md) | daemon, capability-security | current |
| [wire-and-batching](../sections/endo-but-for-bots--llm-designs-dcpg--wire-and-batching.md) | daemon, async-flow, eventual-send | current |
| [event-sources-and-subscription](../sections/endo-but-for-bots--llm-designs-dcpg--event-sources-and-subscription.md) | daemon, async-flow | current |
| [persistence-and-graph](../sections/endo-but-for-bots--llm-designs-dcpg--persistence-and-graph.md) | daemon, persistence | current |
| [crash-reconnect-and-revocation](../sections/endo-but-for-bots--llm-designs-dcpg--crash-reconnect-and-revocation.md) | daemon, capability-security, persistence | current |

## See also

- `daemon-retention-paths.md` (`drp`) — per-target subscription + chat-UI sibling
- `retention-path-notation.md` (`rpn`) — bulk best-path API + CLI notation
