---
title: Migration and Comparison with v1
source: doc/design/dir-design-v2.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-17
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [content-addressed-storage]
status: current
---

> Abstract: How v2 compares to and migrates from v1, plus the shared mode system and sync protocol. Versus v1, v2 trades O(n) worst-case lookup for O(log n), poor mutation locality for good (Rabin boundaries), variable internal-node size for fixed (interleaved links), inline leaf names for separate key blocks, and adds stable-chunk sync on top of block-level diff. v1 and v2 roots are structurally distinguishable (v1 leaves carry inline name data in `Bytes`; v2 leaves carry only links plus packed modes), so migration is lazy: detect the version on load, read v1 with the v1 path (or migrate on read), read v2 with the v2 path, and always write v2. Unmodified v1 directories stay readable without conversion; a v1 directory is rebuilt as v2 only when modified. The 2-byte mode/category field is unchanged from v1. Directory diff and sync reuse the same SDIF/SOPS protocol as sorted arrays, because a v2 directory *is* a Rabin-chunked sorted array of entries.

## Comparison with v1

| Aspect | v1 | v2 |
|--------|----|----|
| Lookup time | O(n) worst case | O(log n) |
| Mutation locality | Poor (rebuild subtrees) | Good (Rabin boundaries) |
| Internal node size | Variable | Fixed (interleaved links) |
| Name storage | Inline in leaves | Separate key blocks |
| Sync efficiency | Block-level diff | Block-level diff + stable chunks |

## Migration from v1

v1 and v2 directories are distinguishable by structure: v1 leaf blocks contain inline name data in `Bytes`; v2 leaf blocks contain only links (hashes) and packed modes.

**Migration strategy**: (1) detect version when loading root; (2) v1 roots use the v1 code path (or migrate on read); (3) v2 roots use the v2 code path; (4) the write path always produces v2 format. **Lazy migration**: when a v1 directory is modified, rebuild it as v2; unmodified v1 directories remain readable without conversion.

## Mode Categories (unchanged from v1)

The 2-byte mode field interpretation is preserved: `0x00` immutable (file/dir/symlink), `0x01` cell (capability-addressed mutable reference), `0x02` map, `0x03` set. See the v1 mode field section for full documentation.

## Network Protocol Integration

Directory diff and sync use the same SDIF/SOPS protocol as sorted arrays:

```
Peer A                          Peer B
   ├─── SDIF(local_dir, remote) ──►│
   │◄── SOPS(ops to reconcile) ────┤
```

Because directories are Rabin-chunked sorted arrays of entries, the standard sorted-array diff algorithm applies directly.

Source: [doc/design/dir-design-v2.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/dir-design-v2.md) at commit `cdb975d8`.
