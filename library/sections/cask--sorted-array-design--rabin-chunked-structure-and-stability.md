---
title: Rabin-Chunked Structure and the Stability Property
source: doc/design/sorted-array-design.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-17
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [data-structures, content-addressed-storage]
status: current
---

> Abstract: A persistent sorted array (`sortedarray`, status PLANNED) that uses content-defined chunking (Rabin fingerprinting) to localize Merkle-tree changes during insert and delete, avoiding the rebalance cascades a B-tree or red-black tree pays in a content-addressed store (where a single insertion can re-hash every level from leaf to root). The root block links a `chunks_tree` (a standard `arraytree` of chunk hashes) and stores `count`, `entry_size`, `key_size`, and the `avg_chunk` / `min_chunk` / `max_chunk` parameters. Each chunk is a leaf block holding `entry_count` (2 bytes) plus `entry_count × entry_size` sorted entries; an entry is a fixed-size byte sequence whose first `key_size` bytes are the lexicographically-compared sort key and whose remainder is the value (`entry_size == key_size` for a pure set). A chunk boundary occurs when `entry_count ≥ min_chunk` AND `rabin_fingerprint(entry) & mask == mask` (with `mask = avg_chunk − 1`), OR `entry_count ≥ max_chunk`. Because boundaries follow content not position, the **stability property** holds: entries before and after an insertion keep their boundaries, and only the local region around the edit re-chunks, so only that chunk's hash (and its path in `chunks_tree`) changes while distant chunks stay byte-identical. This is the same property that makes Rabin-chunked blobs stable under local edits, lifted from byte streams to sorted records.

## Motivation

Traditional sorted tree structures (B-tree, red-black tree) require rebalancing that can cascade through multiple levels. In a Merkle-tree context this means a single insertion can change hashes at every level from leaf to root. Content-defined chunking, as used in `caskblob` for byte sequences, creates boundaries based on content itself, localizing changes: insertions and deletions affect only nearby chunks, leaving distant chunks and their hashes unchanged.

## Structure

The root block links the chunks tree and stores the layout parameters:

```
SORTED_ARRAY_ROOT
 ├─► Links[0]     : chunks_tree (tree of chunk hashes)
 ├─► Bytes[0:8]   : count (total number of entries)
 ├─► Bytes[8:12]  : entry_size (bytes per entry, fixed)
 ├─► Bytes[12:16] : key_size (bytes of entry used for sorting)
 ├─► Bytes[16:20] : avg_chunk (target entries per chunk)
 ├─► Bytes[20:24] : min_chunk (minimum entries per chunk)
 └─► Bytes[24:28] : max_chunk (maximum entries per chunk)
```

The **chunks tree** is a standard `arraytree` (the same backbone `caskarray` uses) whose leaves are chunk hashes; chunks are variable-sized per Rabin boundaries and ordered by the minimum key they contain. A **chunk** leaf block holds `entry_count` (2 bytes) then `entry_count × entry_size` entries, sorted by key within the chunk. An **entry** is `entry_size` fixed bytes: the first `key_size` are the sort key (compared lexicographically), the remainder is arbitrary value data; `entry_size == key_size` for a pure sorted set.

## Rabin chunking and the stability property

A chunk boundary occurs when:

1. `entry_count >= min_chunk`, AND
2. `rabin_fingerprint(entry) & mask == mask`, OR
3. `entry_count >= max_chunk`

The fingerprint is computed over the entry bytes; `mask = avg_chunk − 1` (for power-of-two `avg_chunk`) sets the average chunk size. Because boundaries depend on content, not position, entries before and after an insertion keep their boundaries and only the local region re-chunks. Worked example: inserting X between `f` and `g` in `[a b c d][e f g][h i j k]` re-chunks only the middle chunk to `[e f X g]`; the two outer chunks retain their hashes and their paths in `chunks_tree` are unchanged. This is the same content-defined-boundary trick that makes Rabin-chunked blobs stable under local edits.

Source: [doc/design/sorted-array-design.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/sorted-array-design.md) at commit `cdb975d8`.
