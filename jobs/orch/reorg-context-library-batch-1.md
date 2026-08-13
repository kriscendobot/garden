---
order: parallel
children: reorg-context-local-inference-amd reorg-skill-local-verify
on-child-failure: continue
state: running
created_by: producer
created_at: 2026-08-13T22:08:11Z
---

Batch 1 of the context-graph reorganization backlog surfaced by the focused
size audit (journal/reports/context-graph-size-audit-focused-2026-08-13.md):
the two largest main2 candidates. Independent documents, no ordering
dependency between them, so dispatched in parallel. A failure on one should
not block the other.
