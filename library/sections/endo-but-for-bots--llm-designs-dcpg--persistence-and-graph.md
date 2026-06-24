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
kind: index
section_count: 3
---

The retention state lives in two coupled stores: an in-memory map for
hot access, and a SQLite table for crash survival.

Sections:

- [In-memory: `formulaGraph.retentionEdges`](endo-but-for-bots--llm-designs-dcpg--persistence-and-graph--in-memory-formulagraph-retentionedges.md)
- [On-disk: SQLite `retention` table](endo-but-for-bots--llm-designs-dcpg--persistence-and-graph--on-disk-sqlite-retention-table.md)
- [Graph integration](endo-but-for-bots--llm-designs-dcpg--persistence-and-graph--graph-integration.md)
