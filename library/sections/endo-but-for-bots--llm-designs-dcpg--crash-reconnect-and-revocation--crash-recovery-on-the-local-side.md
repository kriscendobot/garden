---
title: Crash recovery on the local side
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

When the daemon restarts, `formulaGraph.retentionEdges` is rebuilt by
reading every row of the SQLite `retention` table. This gives us, for
each peer P, the formula set as of our last commit. Because the
in-memory map is regenerated *before* any far-ref handshake, the local
GC always has an accurate retention picture even before any peer
reconnects.
