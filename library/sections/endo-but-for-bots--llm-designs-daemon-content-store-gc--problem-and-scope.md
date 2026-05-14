---
title: Problem + Scope (daemon-local storage cleanup; content blobs + scratch-mount dirs)
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
---

> Abstract: **Problem**: the daemon's content-addressed store (`{statePath}/store-sha256/`) grows monotonically — files are written when `readable-blob`/`readable-tree` formulas are created, but **never pruned** when those formulas are GC'd. The formula GC deletes formula JSON from `/formulas/` but doesn't consult the `content` hash field to determine whether the corresponding file in `/store-sha256/` is still referenced. Same problem for scratch-mount backing directories (`{statePath}/mounts/{formulaNumber}`), which persist after their `scratch-mount` formula is collected. Without cleanup, long-running daemons accumulate orphaned content files and mount directories indefinitely. **Scope**: cleanup of **daemon-local storage** associated with formulas but living outside the formula JSON files — (1) content-addressed blobs in `/store-sha256/` (referenced via SHA-256 `content` field); (2) scratch-mount backing directories in `/mounts/{formulaNumber}`. **Cross-peer GC** (synced pet stores, remote formula refs) is covered by `daemon-cross-peer-gc.md` and out of scope here.

## What is the Problem Being Solved?

The daemon's content-addressed store (`{statePath}/store-sha256/`) grows monotonically. Files are written when `readable-blob` and `readable-tree` formulas are created, but **never pruned** when those formulas are garbage-collected. The formula GC pass deletes formula JSON from `/formulas/` but does not consult the `content` hash field to determine whether the corresponding file in `/store-sha256/` is still referenced by any living formula.

The same problem extends to scratch-mount backing directories (`{statePath}/mounts/{formulaNumber}`), which persist after their `scratch-mount` formula is collected.

Without content-store GC, long-running daemons accumulate orphaned content files and mount directories indefinitely.

## Scope

This design covers cleanup of **daemon-local storage** that is associated with formulas but lives outside the formula JSON files themselves:

1. **Content-addressed blobs** — files in `{statePath}/store-sha256/` referenced by `readable-blob` and `readable-tree` formulas via their `content` field (a SHA-256 hash).
2. **Scratch-mount backing directories** — directories at `{statePath}/mounts/{formulaNumber}` owned by `scratch-mount` formulas.

Cross-peer GC (synced pet stores, remote formula references) is covered by [daemon-cross-peer-gc](daemon-cross-peer-gc.md) and is out of scope here.

Source: [designs/daemon-content-store-gc.md](https://github.com/endojs/endo-but-for-bots/blob/e22f713278b397142ca2a27eddd38f937573cd43/designs/daemon-content-store-gc.md) at commit `e22f7132` on branch `llm`.
