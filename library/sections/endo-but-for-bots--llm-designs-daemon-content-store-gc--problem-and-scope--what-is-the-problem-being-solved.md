---
title: What is the Problem Being Solved?
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
notes: Two distinct backing-store kinds — content-addressed blobs (potentially shared across formulas via SHA-256 dedup) and scratch-mount directories (1:1 with formula). Cross-peer GC is explicitly out of scope (separate design daemon-cross-peer-gc).
parent: endo-but-for-bots--llm-designs-daemon-content-store-gc--problem-and-scope
---

The daemon's content-addressed store (`{statePath}/store-sha256/`) grows monotonically. Files are written when `readable-blob` and `readable-tree` formulas are created, but **never pruned** when those formulas are garbage-collected. The formula GC pass deletes formula JSON from `/formulas/` but does not consult the `content` hash field to determine whether the corresponding file in `/store-sha256/` is still referenced by any living formula.

The same problem extends to scratch-mount backing directories (`{statePath}/mounts/{formulaNumber}`), which persist after their `scratch-mount` formula is collected.

Without content-store GC, long-running daemons accumulate orphaned content files and mount directories indefinitely.

Source: [designs/daemon-content-store-gc.md](https://github.com/endojs/endo-but-for-bots/blob/e22f713278b397142ca2a27eddd38f937573cd43/designs/daemon-content-store-gc.md) at commit `e22f7132` on branch `llm`.
