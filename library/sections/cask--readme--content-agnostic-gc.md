---
title: Content-agnostic garbage collection
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

> Abstract: CASK's garbage collector. Because the link structure of every block is captured in its metadata, the GC can walk the retention graph from a set of pinned roots without understanding what any block contains. Two retention regimes coexist: pinned content (on-disk, with roots in a hash-trie) and deadline-based ephemeral data (in-memory, heap-ordered by expiry). Concurrent GC quarantines new writes during a mark-sweep pass and then consolidates them afterward.

The link structure of every block is captured in its metadata, so the GC can walk the retention graph from a set of pinned roots without understanding what any block contains.

Two retention regimes coexist: pinned content (on-disk, roots in a hash-trie) and deadline-based ephemeral data (in-memory, heap-ordered by expiry). Concurrent GC quarantines new writes during a mark-sweep pass, then consolidates them afterward (see the `gc-and-retention` and `gc-concurrent-design` docs).

Source: [README.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/README.md) at commit `cdb975d8`.
