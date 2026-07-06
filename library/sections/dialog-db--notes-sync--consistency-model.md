---
title: Consistency model
source: notes/sync.md
source_repo: dialog-db/dialog-db
source_commit: bf88f2c3313f54e3bd2d89f394f2c4aaf1f1d6c1
source_date: 2025-10-20
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [local-first-sync, change-propagation]
status: current
---

> Abstract: The sync protocol provides **eventual consistency with deterministic convergence**. Each peer keeps an immutable local tree (a partial replica) and coordinates through a single mutable pointer that is the canonical root reference. Given identical merge strategies and histories, all replicas converge to the same state.

This protocol provides **eventual consistency** with **deterministic convergence**. Each peer maintains an immutable local tree (partial replica) and coordinates via a single mutable pointer that serves as the canonical root reference. Given identical merge strategies and histories, all replicas converge to the same state.

Source: [notes/sync.md](https://github.com/dialog-db/dialog-db/blob/bf88f2c3313f54e3bd2d89f394f2c4aaf1f1d6c1/notes/sync.md) at commit `bf88f2c3`.
