---
title: CASK CLI quick start
source: README.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-17
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [content-addressed-storage]
status: current
---

> Abstract: The `cask` CLI surface, consolidated from the README quick-start subsections. Covers daemon lifecycle (`init`, `start`, `stop`), storing/loading blobs by content hash, checking directories in and out, the persistent root tree with bare-name and colon-path addressing plus `@HASH` direct references, **cells** (named mutable references whose stable ID is distinct from the content hash they point at, addressed with a trailing `:`), copy/snapshot/link operations (`cp`, `cp -s`, `ln`, `ln --read-only`), and inspection commands (`at`, `state`, `typeof`, `weigh`, `ls -r`, `head`, `gc`).

Initialize a store and start the daemon, then store and load content addressed by hash:

```sh
cask init
cask start
echo "hello, world" | cask store        # prints the content hash
cask load @ae4e4b6c...                   # @HASH refers to a specific hash directly
```

**Directories** check in and out: `cask checkin myproject` returns a hash; `cask checkout restored @b7f2a1...` materializes it.

**The root tree** is a persistent directory in the head block. Bare names and colon-separated paths address entries from the root; `@HASH` addresses a hash directly. `cask checkin myproject --to myproject` stores a named entry; `cask ls` lists the root tree; `cask checkout restored myproject` checks out by name.

**Cells** are named mutable references. A trailing `:` in a target path means "this name is a cell." A cell holds a content hash that can be updated without changing the directory entry — only the cell's value changes, and the **cell ID is stable across updates** (`cask at latest` prints the stable cell ID; `cask state latest` prints what it currently points to; `cask ls latest` follows it transparently). A cell can be updated by address: `echo "new content" | cask store --to @2191...:`.

**Copy, snapshot, link:** `cask cp` preserves cell references; `cask cp -s` resolves all cell references to current content; `cask cp -S photos/vacation` snapshots only specific cells by subpath; `cask mkdir albums` creates an empty directory; `cask ln photos-ro photos` creates an attenuated (symlink-like) cell reference; `cask ln --read-only eve photos:vacation:summer` creates a scoped, read-only reference to a subpath. `cask rm myproject` removes an entry.

**Inspection:** `cask at` (raw cell ID or, with `:`, the content hash), `cask state` (current value), `cask typeof` (entry type: blob, dir, cell, ...), `cask weigh` (total block count of a subtree), `cask ls -r` (recursive), `cask head` (current store head), `cask gc` (garbage-collect unreachable blocks), `cask stop`.

Source: [README.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/README.md) at commit `cdb975d8`.
