---
title: Merkle trees for everything
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

> Abstract: All of CASK's higher-level data structures are trees of 1KB blocks. **Blobs** split byte streams into blocks with a Rabin-fingerprint rolling hash so a mid-file edit invalidates O(log n) blocks instead of rewriting everything after the edit point. **Directories** are name-ordered Merkle trees of (hash, mode, name) entries. **Arrays** are dense 32-way tries of hashes, with typed variants for every integer width plus a big-int variant. **Maps** and **sets** use 4-level 32-way hash tries. Because every structure shares the same 1KB block format, the garbage collector needs only the block metadata (link count and pointers) to walk the retention graph — it never parses any structure, a deliberate contrast with Git's content-addressed store whose GC must parse object headers.

Higher-level data structures are all trees of 1KB blocks:

- **Blobs** (`blob`) split byte streams into blocks using a Rabin-fingerprint rolling hash, so that edits in the middle of a large file only invalidate O(log n) blocks rather than rewriting everything after the edit point.
- **Directories** (`dir`) are Merkle trees of entries (hash + mode + name), ordered by name.
- **Arrays** (`array`) are dense 32-way tries of hashes, with typed variants for every integer width from uint8 to int64, plus `bigintarray` for arbitrary precision with adaptive width.
- **Maps** and **sets** (`map`, `set`) use 4-level, 32-way hash tries.

Because every data structure shares the same 1KB block format, the garbage collector does not need to understand any of them. It only needs the block metadata — which tells it how many links a block contains and where they point — to walk the retention graph. This is a deliberate contrast with Git's content-addressed store, where the GC must parse object headers to discover references.

Source: [README.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/README.md) at commit `cdb975d8`.
