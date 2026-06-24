---
title: Universal Tree Integration and Schema Hashes
source: doc/design/parallel-arrays.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [content-addressed-storage, data-structures]
status: current
---

> Abstract: How parallel-array tables integrate with CASK's universal filesystem-like tree and how structures self-describe. Today caskdir entries carry a 1-byte mode (blob / directory / symlink). A finite mode space cannot capture maps, sets, arrays, and tables, so the design proposes **schema hashes**: every structure's root block carries, at link[0], the content-addressed hash of a schema-definition block that fully describes its layout (structure type, meaning of each subsequent link, byte-section layout, invariants) — like a vtable pointer. Schemas live in the same content-addressed store as everything else (no external registry; a schema hash is just another hash), enabling type checking, generic tooling, safe additive evolution (new fields → new hash, old data stays valid), and cross-language interop. The doc sketches a CASK IDL that compiles a table definition into a canonical schema block, its hash, and load/store/validate code. The unifying move: **directories become tables** (parallel arrays of names/contents/modes plus order and free-list indexes), giving O(log n) add/remove and O(1) name-hash lookup with deferred sort/defragment, and a single `TreeNode` schema can represent both directories (entries) and blobs (chunks), adapting representation (compact vs sparse) to the access pattern.

## From Mode Bytes to Schema Hashes

The current 1-byte `mode` (0x00 blob, 0x01 directory, 0x02 symlink) is sufficient for basic filesystem semantics but cannot encode richer collection and table types; even a 2-byte category/subtype extension only covers types known at design time. The more powerful approach: each structure root carries a **schema hash** at link[0] pointing to a schema-definition block:

```
SCHEMA_BLOCK describes:
  name (e.g. "cask.table.PriorityQueue"), version, num_links,
  link_names (each link's meaning), num_fields, field_defs (name, type, width),
  packed string_table
```

The hash of a schema block is deterministic; any structure with the same schema hash has the same layout. Schemas are stored as ordinary content-addressed blocks — no external registry — preserving CASK's property that a hash suffices to retrieve and verify any content.

## Toward a CASK IDL

A schema-hash regime supports an Interface Definition Language. A `table PriorityQueue { deadlines: array<uint64>; ...; index_width: uint8; }` declaration compiles to the canonical schema block, its hash, generated Go (or other) load/store code, and validation code. The IDL can express a type hierarchy (primitives, built-in collections, an `index` type whose width follows capacity, a `Table` base that specific tables `extend`) and safe schema evolution (additive fields, version field, multi-schema compatibility advertisement, deprecation without invalidating old data).

## Benefits of Schema Hashes

Self-describing (any tool can introspect a structure via its schema), type-safe (verify a hash points to the expected type before use), versioned, tooling-friendly (generic viewers/validators/migrators), self-documenting, and language-interoperable.

## Adaptive Structures and the Unified Tree

Rather than separate "compact" and "sparse" types, a structure adapts its internal representation while keeping one schema: a blob is born compact (chunked, concatenated) and transitions to a sparse tree of chunks when operational transforms (insert/delete/replace ranges) are applied. **Directories as tables** gain the parallel-array benefits:

| Operation | Traditional caskdir | Directory Table |
|-----------|---------------------|-----------------|
| Add entry | O(n) rebuild | O(log n) append + index update |
| Remove entry | O(n) rebuild | O(log n) swap-to-end |
| Lookup by name | O(log n) binary search | O(1) via name hash → slot |
| Rename | O(n) rebuild | O(log n) update name + reindex |

Adds/removes are fast (append / swap-to-end) with **deferred sorting**: the directory accumulates unsorted entries and an explicit `Sort`/`Defragment` rebuilds the order index when beneficial. A single unified `TreeNode` schema then represents both directories (name/content/mode columns plus order and free-list indexes) and blobs (chunk columns plus a chunk-order index), with a `node_type` byte (dir / blob / hybrid) — both using the same parallel-array machinery, both able to be sparse or compact, both supporting operational transforms.

Source: [doc/design/parallel-arrays.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/parallel-arrays.md) at commit `cdb975d8`.
