---
title: Operational-transform change model
source: plans/git-storage.md
source_repo: cloudflare/cloudflare-os
source_commit: 1ef6020a42fbabb6d27dd1063db3a075ba95c974
source_date: 2026-08-21
source_authors: [Kenton Varda]
ingested: 2026-08-24
ingested_by: scholar
topics: [collaborative-workspace-sharing, persistence, testing]
status: current
---

Part 3 adopts operational transformation before deployment, replacing Yjs chat updates with a small file-change algebra built on CodeMirror `ChangeSet` and a Durable Object sequencer.

The shared change model distinguishes file creation, deletion, replacement, and text edits; validates Unicode and length boundaries; and defines apply, compose, transform, and diff operations. The server owns a revision stream per generation and transforms submissions from their base revision through retained changes. Client IDs plus monotonic sequence numbers make retries idempotent, while digest mismatches, sequence gaps, and submissions outside the retained transform window reject rather than double-apply. Property and fuzz tests cover convergence, composition, transformation, validation, and reconnect behavior.

Source: [plans/git-storage.md](https://github.com/cloudflare/cloudflare-os/blob/1ef6020a42fbabb6d27dd1063db3a075ba95c974/plans/git-storage.md) at commit `1ef6020a`.
