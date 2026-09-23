---
title: Lookup Complexity and Future Work
source: doc/design/dir-design.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-17
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [content-addressed-storage, data-structures]
status: current
notes: This section poses the O(n)-lookup open question that dir-design-v2 answers and dir-benchmark empirically evaluates. It is not superseded (the v1 format remains the practical default per the benchmark); it is the origin of the design arc captured in concept caskdir-directory-format.
---

> Abstract: The v1 caskdir's known limitation and its enumerated fixes. The current implementation may require O(n) time to look up a name in a directory of n entries, since it scans leaf blocks sequentially. The goal is O(log n). Four approaches are listed: (1) sorted entries with branch-block boundary keys (B+ tree style), (2) a prefix-trie restructuring (O(k) in key length, size-independent), (3) a parallel hashtree index (name_hash → entry) for O(1) at the cost of extra storage/maintenance, and (4) Rabin-chunked sorted entries reusing the sorted-array design. The recommendation is approach 1 or approach 4 as most aligned with existing CASK patterns. This is the open question that `dir-design-v2` takes up (choosing approach 4, then a table variant) and that `dir-benchmark` resolves empirically. Other future work: cell resolution in Resolve, incremental updates, streaming, branch-block search optimization, and permission bits.

## Future Work

1. **Cell resolution**: Extend Resolve to handle cell references.
2. **Incremental updates**: Modify a directory without full rebuild.
3. **Streaming**: Process large directories without loading all entries.
4. **Search optimization**: Store boundary keys in branch blocks.
5. **Permissions**: Extended mode bits for access control.

### Lookup Time Complexity

**Current issue**: The current caskdir implementation may require O(n) time to look up a name in a directory with n entries, as it must scan leaf blocks sequentially to find a matching name.

**Goal**: O(log n) lookup time for a given string key.

**Potential approaches**:

1. **Sorted entries with boundary keys**: Store entries sorted by name within leaves. Branch blocks store boundary keys (min/max name in subtree) to enable binary search across the tree. Similar to a B+ tree.
2. **Prefix tree (trie) foundation**: Restructure caskdir as a trie branching on a character or character group per level. Lookup is O(k) where k is the key length, independent of directory size.
3. **Hash-based index**: Add a parallel hashtree index (name_hash → entry) for O(1) lookup, while keeping the current structure for iteration. Trade-off: extra storage and maintenance overhead.
4. **Rabin-chunked sorted entries**: Apply the sorted array design (`SORTED_ARRAY_DESIGN.md`) to directory entries. Entries sorted by name, Rabin-chunked for stable Merkle boundaries. Lookup via binary search.

**Recommendation**: Approach 1 (sorted with boundary keys) or approach 4 (Rabin-chunked sorted) are most aligned with existing CASK patterns. The choice depends on whether to prioritize minimal change to the current structure (approach 1) or consistency with other sorted structures (approach 4). This should be revisited when implementing large directory support or when lookup performance becomes a bottleneck.

Source: [doc/design/dir-design.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/dir-design.md) at commit `cdb975d8`.
