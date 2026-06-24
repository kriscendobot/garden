---
title: Goals and the Rabin-Chunked Entries Tree
source: doc/design/dir-design-v2.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-17
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [content-addressed-storage, data-structures]
status: current
notes: dir-design-v2 is a PLANNED design (status PLANNED in source). It is not superseded, but its "use table" recommendation was empirically reversed by dir-benchmark toward an adaptive compact-default strategy; see concept caskdir-directory-format.
---

> Abstract: caskdir v2's goals and its first proposed structure. v2 targets the v1 O(n) lookup limit with O(log n) lookup, mutation locality (insert/delete touch only nearby blocks), efficient Merkle diff/sync, variable-length names, and backward-compatible modes. The first structure is a Rabin-chunked sorted **entries tree**: entries sorted lexicographically by name, chunk boundaries chosen by Rabin fingerprinting over the 32-byte name hash, internal nodes interleaving child-hash links with min-key-hash links. Min-keys are stored as links (not inline) so internal nodes stay fixed-width, key data deduplicates (a subtree's min-key equals its leftmost leaf's), and the layout stays content-addressed. A key block is just `SHA256(name_bytes) → name`; identical names share one key block. Chunk (leaf) blocks interleave per-entry content-hash and name-hash links plus a packed modes array. A boundary occurs after entry E when `entries_so_far >= min_chunk` AND the fingerprint matches the mask, OR `entries_so_far >= max_chunk`; parameter triples (avg/min/max) scale by directory size.

## Goals

1. **O(log n) lookup** by name.
2. **Mutation locality** — insertions/deletions affect only nearby blocks.
3. **Efficient sync** — Merkle structure enables fast diff and sync.
4. **Variable-length names**.
5. **Backward-compatible modes** — preserve the v1 mode/category system.

## Structure Overview

```
DIRECTORY_ROOT
 ├─► Links[0]     : entries_tree root (Rabin-chunked sorted entries)
 ├─► Links[1]     : schema_hash (ZeroHash for v0)
 ├─► Bytes[0:8]   : entry_count
 ├─► Bytes[8:12]  : avg_chunk (target entries per chunk)
 ├─► Bytes[12:16] : min_chunk
 └─► Bytes[16:20] : max_chunk
```

## Entries Tree

A Rabin-chunked sorted array: entries sorted lexicographically by name, chunk boundaries by Rabin fingerprinting, internal nodes carrying min-key hints for O(log n) navigation.

### Internal Node Structure

Internal nodes interleave child hashes with min-key hashes:

```
INTERNAL_NODE
 ├─► Links[0]      : child_0 hash
 ├─► Links[1]      : min_key_0 hash (hash of name bytes for leftmost entry in child_0)
 ├─► Links[2]      : child_1 hash
 ├─► Links[3]      : min_key_1 hash
 │   ...
 ├─► Links[2N-2]   : child_{N-1} hash
 ├─► Links[2N-1]   : min_key_{N-1} hash
 └─► Bytes[0]      : child_count (N)
```

**Why min-keys are links, not inline data**: directory names are variable-length; storing as links keeps internal nodes fixed-width; key data deduplicates (a subtree's min-key equals its leftmost leaf's min-key); consistent with the content-addressed model.

### Key Block

Each min-key link points to a key block holding the name bytes (UTF-8, no null terminator). The hash of a key block is `SHA256(name_bytes)`; identical names share the same key block.

### Chunk (Leaf) Structure

```
CHUNK
 ├─► Links[0]      : hash_0 (content hash or cell address for entry 0)
 ├─► Links[1]      : name_0 hash (hash of name bytes)
 ├─► Links[2]      : hash_1
 ├─► Links[3]      : name_1 hash
 │   ...
 ├─► Bytes[0:2]    : entry_count
 └─► Bytes[2:..]   : modes (entry_count × 2 bytes, packed)
```

Each entry occupies 2 links (64 bytes: content hash + name hash) plus 2 bytes in the modes array. `Links[2*i]` is the content hash (immutable) or cell address (cell); `Links[2*i+1]` is the hash of the name bytes; `Bytes[2 + 2*i : 2 + 2*i + 2]` is the 2-byte mode (see v1 mode field).

## Rabin Chunking

A chunk boundary occurs after entry E when:

1. `entries_so_far >= min_chunk`, AND
2. `rabin_fingerprint(E.name_hash) & mask == mask`, OR
3. `entries_so_far >= max_chunk`.

The fingerprint is computed over the 32-byte name hash, making boundaries content-defined and stable under distant mutations.

| Use Case | avg_chunk | min_chunk | max_chunk |
|----------|-----------|-----------|-----------|
| Small directories (<1000) | 32 | 8 | 128 |
| Large directories | 64 | 16 | 256 |
| Huge directories (>100K) | 128 | 32 | 512 |

Smaller chunks give better mutation locality but more tree overhead; larger chunks give less overhead but a larger blast radius on mutation.

Source: [doc/design/dir-design-v2.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/dir-design-v2.md) at commit `cdb975d8`.
