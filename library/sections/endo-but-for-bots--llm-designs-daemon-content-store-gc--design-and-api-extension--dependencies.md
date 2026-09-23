---
title: Dependencies
source: designs/daemon-content-store-gc.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: e22f713278b397142ca2a27eddd38f937573cd43
source_date: 2026-03-21
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [daemon, persistence]
status: current
notes: The "sweep-time reference count, NOT a persistent counter" is the daemon's GC-discipline pattern — avoids the complexity of a durable refcount table by re-deriving liveness from the formula graph each sweep. Same pattern would generalize to any 1-to-many storage where the "many" side is in formulas. The content-store sweep is **batched** (once per GC pass over the batch of collected formulas), not per-formula.
parent: endo-but-for-bots--llm-designs-daemon-content-store-gc--design-and-api-extension
---

| Design | Relationship |
|--------|-------------|
| `daemon-mount` | Scratch-mount directory cleanup is defined here |
| `daemon-cross-peer-gc` | Orthogonal — that design covers cross-peer formula GC; this covers local storage cleanup |
| `daemon-checkin-checkout` | `endo checkin` creates `readable-tree` formulas that reference the content store |

Source: [designs/daemon-content-store-gc.md](https://github.com/endojs/endo-but-for-bots/blob/e22f713278b397142ca2a27eddd38f937573cd43/designs/daemon-content-store-gc.md) at commit `e22f7132` on branch `llm`.
