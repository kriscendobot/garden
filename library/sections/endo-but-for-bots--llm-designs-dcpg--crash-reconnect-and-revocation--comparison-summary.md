---
title: Comparison summary
source: designs/daemon-cross-peer-gc.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 1570e88926e0fe3146b30458b6148f33c76fe02a
source_date: 2026-04-29
source_authors: [Kris Kowal]
topics: [daemon, capability-security, persistence]
status: current
parent: endo-but-for-bots--llm-designs-dcpg--crash-reconnect-and-revocation
---

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
