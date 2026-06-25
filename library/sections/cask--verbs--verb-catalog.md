---
title: Verb Catalog (Reads and Reduces)
source: doc/design/verbs.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-25
ingested_by: scholar
topics: [content-addressed-storage]
status: current
notes: Reference catalog consolidated into one section per conventions.md (aggressively consolidate non-thematic reference docs), preserving the per-verb H3 anchors inline for grep.
---

Abstract: The four-letter verb vocabulary for CASK data-structure operations, where each verb maps to one abstract signature shape with common semantics across every data type that supports it. The unifying convention: all verbs operate on a 32-byte **root hash** identifying the current state of a structure in the block store, with the store always implicit; **reads** are `(store, root, args...) → value` (return without changing state) and **reduces** are `(store, root, args...) → root'` (return a new root hash for the updated state) following the same `(state_hash, args) → new_state_hash` reducer shape the rest of CASK uses. Type abbreviations span array (Hash-valued), u\*arr/i\*arr (the fixed-width uint/int arrays), bigarr (bigintarray), map, set, htree (hashtree), ht→uN (hashtreetouintN), heap (indexheap), alloc (allocator), sess (sessiontable), dir, blob (Rabin-chunked byte stream), cblob (compactblob), root (caskhead), and io (cross-store). There are **10 read verbs** (`size`, `getv`, `getk`, `find`, `walk`, `list`, `each`, `peek`, `have`, `read`) and **17 reduce verbs** (`setv`, `putk`, `delk`, `delv`, `push`, `popv`, `insv`, `swap`, `spli`, `fixv`, `aloc`, `free`, `updv`, `init`, `writ`, `pack`, `copy`) for **27 verbs total**. Six are structural infrastructure for lifecycle and encoding (`init`, `writ`, `pack`, `copy`, `aloc`, `free`); the remaining 21 are data verbs that would generalize over cells and directory entries reached through a path or capability. A verb applied to an incompatible type is an error (`push` on a blob, `getk` on an array, `setv` on a set), and the same code may carry different semantics across types (`putk` on a set is membership, `putk` on a map is a key-value pair).

## Conventions

All verbs operate on a **root hash** that identifies the current state of a data structure in the block store. Reads return values without changing state. Reduces return a new root hash representing the updated state.

```
read:    (store, root, args...) → value
reduce:  (store, root, args...) → root'
```

The store is always implicit (the block store context). The root is always a 32-byte hash. Arguments and return values vary by verb and data type.

## Type Abbreviations

| Abbreviation | Packages |
|--------------|----------|
| array | array (Hash-valued) |
| u\*arr | uint8array, uint16array, uint32array, uint64array |
| i\*arr | int8array, int16array, int32array, int64array |
| bigarr | bigintarray |
| map | map (uint32 → Hash) |
| set | set (uint32 membership) |
| htree | hashtree (uint32 → Hash trie) |
| ht→uN | hashtreetouint8, hashtreetouint16, hashtreetouint32, hashtreetouint64 |
| heap | indexheap |
| alloc | allocator |
| sess | sessiontable |
| dir | dir (directory tree) |
| blob | blob (Rabin-chunked byte stream) |
| cblob | compactblob (single-block blob) |
| root | caskhead (system head) |
| io | io (cross-store) |

## Reads

- **`size`** — count of elements or byte length: `(root) → uint64`. array/u\*arr/i\*arr/bigarr/ht→uN/heap Len; alloc allocated count; sess session count; blob byte length (Size).
- **`getv`** — get value by integer index: `(root, index: uint64) → value`. array→Hash, u\*arr→uintN, i\*arr→intN, bigarr→\*big.Int, sess→Session (Get).
- **`getk`** — get value by key: `(root, key) → (value, found: bool)`. map (uint32→Hash), ht→uN (uint32→uintN), htree (GetLeaf, uint32→Hash), set (Has, uint32→bool membership).
- **`find`** — find index by key (lookup): `(root, key) → (index: uint64, found: bool)`. sess Lookup (Hash session ID), dir v2 Lookup (name bytes).
- **`walk`** — resolve a path through nested structures: `(root, path: string) → Entry`. dir Resolve.
- **`list`** — enumerate all entries: `(root) → []Entry`. dir List.
- **`each`** — iterate all elements with callback: `(root, fn) → error`. ht→uN ForEach `(key uint32, value uintN)`, alloc ForEach `(index uint64)`, sess ForEach `(index uint64, session Session)`.
- **`peek`** — read extremum without removing: `(root) → (index: uint64, found: bool)`. heap Peek (minimum value), sess PeekExpired (earliest expiry).
- **`have`** — membership / existence test: `(root, key_or_index) → bool`. set Has (key uint32), heap Contains (index uint64), alloc IsAllocated (index uint64).
- **`read`** — load bytes from blob: `(root, writer) → error` or `(root, offset, buf) → (n: int, error)`. blob Load (streaming) / ReadAt (random access); cblob Load (streaming) / Read (full read).

## Reduces

- **`setv`** — set value at integer index: `(root, index, value) → root'`. array→Hash, u\*arr→uintN, i\*arr→intN, bigarr→\*big.Int (Set).
- **`putk`** — insert or replace by key: `(root, key, value) → root'`. map Put (uint32→Hash), htree PutLeaf, ht→uN Set, set Put (implicit sentinel), dir v2 Insert (name bytes → mode, Hash).
- **`delk`** — delete by key: `(root, key) → root'`. map/htree/ht→uN/set Delete, dir v2 Delete (name bytes).
- **`delv`** — delete by integer index: `(root, index) → root'`. array Delete, u\*arr/i\*arr/bigarr Remove, sess Delete.
- **`push`** — append value to end (or insert into heap): `(root, value) → root'`. array Append (Hash), u\*arr/i\*arr/bigarr Append, heap Push (index uint64).
- **`popv`** — remove and return from end or extremum: `(root) → (root', value)`. u\*arr/i\*arr/bigarr Pop (last), heap Pop (minimum), sess PopExpired (earliest expiry).
- **`insv`** — insert at index, shifting subsequent elements: `(root, index, value) → root'`. array Insert.
- **`swap`** — exchange two elements by index: `(root, i, j) → root'`. u\*arr/i\*arr/bigarr Swap.
- **`spli`** — splice / replace range: `(root, i, j, values) → root'`. array ReplaceRange (replace [i, j) with values); array Transform (generalized splice via keep/skip/inject ops).
- **`fixv`** — reposition element after value change (heap repair): `(root, index) → root'`. heap Fix.
- **`aloc`** — allocate a new slot: `(root) → (index: uint64, root')`. alloc Alloc (free slot index), sess Create (alloc + populate fields).
- **`free`** — release a slot by index: `(root, index) → root'`. alloc Free.
- **`updv`** — update fields of existing record by index: `(root, index, fields...) → root'`. sess Update (expiry uint64, data Hash), root SetSessionsRoot / SetMembershipRoot.
- **`init`** — create empty structure: `() → root`. heap/alloc/sess/bigarr/root New.
- **`writ`** — serialize external data into blocks: `(external_data) → root`. blob Store (io.Reader), cblob Store (io.Reader) / Write ([]byte), dir Store (filesystem + path).
- **`pack`** — compact encoding without changing logical content: `(root) → root'`. bigarr Compact (shrink width if values fit smaller encoding).
- **`copy`** — replicate blocks between stores: `(target_store, source_store, root) → error`. io Copy (concurrent BOM walk), io CopyWithBOM (BOM then copy).

## Summary Table

| Code | Kind | Meaning | Applicable types |
|------|------|---------|------------------|
| `size` | read | count / byte length | array, u\*arr, i\*arr, bigarr, ht→uN, heap, alloc, sess, blob |
| `getv` | read | get by index | array, u\*arr, i\*arr, bigarr, sess |
| `getk` | read | get by key | map, ht→uN, htree, set |
| `find` | read | find index by key | sess, dir |
| `walk` | read | resolve path | dir |
| `list` | read | enumerate entries | dir |
| `each` | read | iterate with callback | ht→uN, alloc, sess |
| `peek` | read | read extremum | heap, sess |
| `have` | read | membership test | set, heap, alloc |
| `read` | read | load bytes | blob, cblob |
| `setv` | reduce | set by index | array, u\*arr, i\*arr, bigarr |
| `putk` | reduce | put by key | map, htree, ht→uN, set, dir |
| `delk` | reduce | delete by key | map, htree, ht→uN, set, dir |
| `delv` | reduce | delete by index | array, u\*arr, i\*arr, bigarr, sess |
| `push` | reduce | append / push | array, u\*arr, i\*arr, bigarr, heap |
| `popv` | reduce | pop / remove extremum | u\*arr, i\*arr, bigarr, heap, sess |
| `insv` | reduce | insert at index | array |
| `swap` | reduce | exchange two elements | u\*arr, i\*arr, bigarr |
| `spli` | reduce | splice range | array |
| `fixv` | reduce | heap repair | heap |
| `aloc` | reduce | allocate slot | alloc, sess |
| `free` | reduce | release slot | alloc |
| `updv` | reduce | update record fields | sess, root |
| `init` | reduce | create empty | heap, alloc, sess, bigarr, root |
| `writ` | reduce | serialize in | blob, cblob, dir |
| `pack` | reduce | compact encoding | bigarr |
| `copy` | reduce | replicate blocks | io |

10 reads, 17 reduces, 27 verbs total. The 6 structural verbs (`init`, `writ`, `pack`, `copy`, `aloc`, `free`) are infrastructure for lifecycle and encoding management. The remaining 21 are the data verbs that would generalize over operating on cells and directory entries reached through a path or capability.

Source: [doc/design/verbs.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/verbs.md) at commit `cdb975d8`.
