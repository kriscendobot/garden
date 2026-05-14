---
title: Current state (content store, formula GC) + reference-counting problem
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
notes: The "two formulas can share a content hash via dedup" is the load-bearing reason a naive delete-on-formula-collect would corrupt the store. The pre-design content store API (`store`, `fetch`, `has` but **no `remove`**) is itself a useful library record — confirms which methods existed before PR #99 landed.
---

> Abstract: **Content store before this design**: `makeContentStore()` in `daemon-node-powers.js` exposes `store()`, `fetch()`, `has()`. **No `remove()`. No retention tracking. No integration with formula GC.** **Formula GC** (`collectIfDirty()` in `daemon.js`): mark-and-sweep over formulas; on collection it cancels the controller, drops live values + CapTP retainers, deletes the formula JSON file, deletes pet-store/mailbox-store/known-peers-store directories. **Does NOT** handle content-store files or scratch-mount directories. **Reference-counting problem**: multiple formulas can reference the same SHA-256 hash (content deduplication). A naive "delete content when formula is collected" would break if two `readable-blob` formulas share the same hash and only one is collected.

## Current State

### Content store

`makeContentStore()` in `daemon-node-powers.js` exposes three methods: `store()`, `fetch()`, `has()`. There is no `remove()`, no retention tracking, and no integration with the formula GC pass.

### Formula GC

`collectIfDirty()` in `daemon.js` runs a mark-and-sweep over formulas. When collecting a formula, it:

- Cancels the controller
- Drops live values and CapTP retainers
- Deletes the formula JSON file
- Deletes pet-store/mailbox-store/known-peers-store directories

It does **not** handle content-store files or scratch-mount directories.

### Reference counting problem

Multiple formulas can reference the same SHA-256 hash (content deduplication). A simple "delete content when formula is collected" strategy would break if two `readable-blob` formulas share the same content hash and only one is collected.

Source: [designs/daemon-content-store-gc.md](https://github.com/endojs/endo-but-for-bots/blob/e22f713278b397142ca2a27eddd38f937573cd43/designs/daemon-content-store-gc.md) at commit `e22f7132` on branch `llm`.
