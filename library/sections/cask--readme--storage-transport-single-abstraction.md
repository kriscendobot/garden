---
title: A single abstraction for storage and transport
source: README.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-17
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [content-addressed-storage, networking]
status: current
---

> Abstract: The first of CASK's "what blocks give you" payoffs: storage and transport share one abstraction. Blocks move between peers over encrypted UDP and land in persistent storage without reformatting. The `dbstore` writes blocks into flat files with `WriteAt` at a fixed slot offset (`slot * BlockSize`) — no serialization, no header parsing, just the same 1024 bytes that arrived on the wire. The allocator, hash-trie index, and metadata files around it reuse CASK's own block-based data-structure patterns for on-disk management.

Blocks move between peers over encrypted UDP and land in persistent storage without reformatting. The [`dbstore`](https://github.com/kriskowal/cask/blob/cdb975d8/doc/design/dbstore-design.md) writes blocks into flat files with `WriteAt` at a fixed slot offset — no serialization, no header parsing, just the same 1024 bytes that arrived on the wire, written at `slot * BlockSize`.

The allocator, hash-trie index, and metadata files that surround it borrow CASK's own block-based data-structure patterns for on-disk management. The result is that the wire representation and the disk representation are the same bytes; there is no marshalling layer between the network and the database.

Source: [README.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/README.md) at commit `cdb975d8`.
