---
title: Table with Parallel Arrays (the Recommended Alternative)
source: doc/design/dir-design-v2.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-17
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [data-structures, content-addressed-storage]
status: current
notes: This section's "proposed decision — use table structure for v2 directories" was empirically reversed by dir-benchmark, which measured the table format 40-70,000x slower than the compact (interleaved) format at practical sizes and proposed an adaptive compact-default strategy. Kept current as the design rationale; read alongside cask--dir-benchmark--analysis-and-adaptive-strategy.
---

> Abstract: The alternative v2 layout the design doc actually recommends: instead of interleaving entry data in Rabin chunks, store a directory as a **table of parallel arrays** in the same pattern as `sessiontable` and the allocator design. Columns: `names` (array of name hashes → name blobs), `modes` (uint16array), `values` (array of content hashes or cell addresses), and `byName` (a sortedarray index, name_hash → slot index) for O(log n) lookup, all over an allocator that gives stable slots. The table approach wins on simpler column access (read all modes without touching names), consistency with other CASK tables (reuses allocator/sortedarray/uint*array), flexible column evolution (add xattrs/timestamps without changing an entry format), and independent column compaction. The interleaved approach wins on locality for full-entry reads, single-tree sync, and a simpler mental model. The doc's **proposed decision is the table structure** with an **adaptive slot width** (uint8/16/32/64 for the byName index, like bigintarray and allocator). NOTE: dir-benchmark later measured the table realization far slower at practical sizes and reversed the default to compact.

## Alternative: Table with Parallel Arrays

Instead of interleaving entry data in chunks, directories could use the table structure pattern (`sessiontable`, the allocator design):

```
DIRECTORY_TABLE
 ├─► Links[0]     : schema_hash (ZeroHash for v0)
 ├─► Links[1]     : allocator root
 ├─► Links[2]     : names column (array of name hashes → name blobs)
 ├─► Links[3]     : modes column (uint16array)
 ├─► Links[4]     : values column (array of content hashes)
 ├─► Links[5]     : byName index (sortedarray: name_hash → slot index)
 └─► Bytes[0:8]   : entry_count
```

| Column | Type | Description |
|--------|------|-------------|
| names | array of Hash | Hash of name → load for actual name bytes |
| modes | uint16array | 2-byte mode per entry |
| values | array of Hash | Content hash or cell address |
| byName | sortedarray | Sorted index for O(log n) lookup |

**Advantages of the table approach**: simpler column access (reading all modes does not require loading name data); consistency with other tables (reuses allocator, sortedarray, uint*array); flexible column evolution (adding xattrs/timestamps is straightforward); independent column compaction (modes use uint16array packing without affecting names).

**Advantages of interleaved chunks**: locality for full entry reads (one chunk gives complete entries); single tree to sync; simpler mental model (a directory is a sorted list of entries).

### Recommendation

The table approach is more aligned with CASK's emerging patterns (allocator for stable indexes, parallel columns, sorted index). Since most operations (lookup, list, sync) do not need all columns simultaneously, the table approach is likely better. **Proposed decision: use table structure for v2 directories.**

```
DIRECTORY_V2 (table-based)
 ├─► allocator    : stable slot allocation
 ├─► names        : array of name hashes (load hash → get name bytes)
 ├─► modes        : uint16array of modes
 ├─► values       : array of content/cell hashes
 ├─► byName       : sortedarray (name_hash → slot index, adaptive width)
 ├─► entry_count
 └─► slot_width   : 1, 2, 4, or 8 bytes for slot indexes
```

**Adaptive slot width**: the byName index stores slot indexes only as wide as the directory size requires (uint8 for ≤255, uint16 for ≤65535, uint32 for ≤4 billion, uint64 beyond), the same pattern as `bigintarray`'s adaptive index width and the allocator's entities/coEntities. For typical directories (under 64K entries) this saves 6 bytes per entry versus fixed uint64.

**Operations**: `Lookup` (O(log n) via byName), `Get` by slot (O(1) parallel-array access), `Insert` (allocate slot, set columns, update index), `Delete` (remove from index, free slot), `List` (iterate allocated slots).

## Open Questions

1. **Symlink targets**: separate blob or inline? (v1 inline; v2 could use a link.)
2. **Extended attributes**: future xattrs via an optional attrs_hash link per entry?
3. **Case sensitivity**: currently case-sensitive (byte-level compare); case-insensitive would need normalized keys.
4. **Maximum name length**: currently unbounded (separate key block); enforce a limit?
5. **Interleaved vs table**: current recommendation is table-based.

## Implementation Status

**Status: PLANNED.** Dependencies: Rabin fingerprint (from `blob`), sorted-array patterns. Builds on: v1 caskdir (mode system, entry semantics), caskblob (Rabin chunking), arraytree (tree structure).

Source: [doc/design/dir-design-v2.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/dir-design-v2.md) at commit `cdb975d8`.
