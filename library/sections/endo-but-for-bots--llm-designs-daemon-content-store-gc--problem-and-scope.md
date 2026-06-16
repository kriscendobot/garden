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
kind: index
section_count: 2
---

> Abstract: **Problem**: the daemon's content-addressed store (`{statePath}/store-sha256/`) grows monotonically — files are written when `readable-blob`/`readable-tree` formulas are created, but **never pruned** when those formulas are GC'd. The formula GC deletes formula JSON from `/formulas/` but doesn't consult the `content` hash field to determine whether the corresponding file in `/store-sha256/` is still referenced. Same problem for scratch-mount backing directories (`{statePath}/mounts/{formulaNumber}`), which persist after their `scratch-mount` formula is collected. Without cleanup, long-running daemons accumulate orphaned content files and mount directories indefinitely. **Scope**: cleanup of **daemon-local storage** associated with formulas but living outside the formula JSON files — (1) content-addressed blobs in `/store-sha256/` (referenced via SHA-256 `content` field); (2) scratch-mount backing directories in `/mounts/{formulaNumber}`. **Cross-peer GC** (synced pet stores, remote formula refs) is covered by `daemon-cross-peer-gc.md` and out of scope here.

Sections:

- [What is the Problem Being Solved?](endo-but-for-bots--llm-designs-daemon-content-store-gc--problem-and-scope--what-is-the-problem-being-solved.md)
- [Scope](endo-but-for-bots--llm-designs-daemon-content-store-gc--problem-and-scope--scope.md)

Source: [designs/daemon-content-store-gc.md](https://github.com/endojs/endo-but-for-bots/blob/e22f713278b397142ca2a27eddd38f937573cd43/designs/daemon-content-store-gc.md) at commit `e22f7132` on branch `llm`.
