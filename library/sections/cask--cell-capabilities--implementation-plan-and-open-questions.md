---
title: Implementation Plan and Open Questions
source: doc/design/cell-capabilities.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-17
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [capability-security, content-addressed-storage]
status: current
---

Abstract: The ten-step implementation plan (each step marked done in source) and the six open questions. The plan: type constants + predicates in cask.go; a `cellpath` package (`Store`/`Load`) using `caskio.Writer`/`Reader` plus `github.com/fxamacker/cbor/v2`; wire values in caskdir; path resolution in `cmd/main.go` (`IsCellDirect`/`IsCellIndirect`, a `derefEntry` helper); access checks at `writeTo`/`removeEntry`/the `cas` handler; the `cask mkroot`, `cask typeof`, and `cask ls` display changes; no new GC logic; and a broad test matrix. The open questions: transitive attenuation (a malicious local user can recreate a `TypeCell` for a visible cell ID, acceptable locally, prevented over the network by capability tokens); append-only deferred (`TypeCellAppend` removed; needs a dedicated log type since diffing trees is O(n)); descriptor caching (immutable descriptors make a hash-keyed resolver cache straightforward); empty-path normalization; the CBOR dependency justification; and how future content kinds (maps, sets) follow the same attenuate-down-only pattern.

## Implementation plan

1. **Add type constants and predicates** to `cask.go`. ✓
2. **Add cell path descriptor package** (`cellpath.Store`, `cellpath.Load`) using `caskio.Writer`/`Reader` for the link-bearing first leaf and CBOR encoding for the path segments. Added `github.com/fxamacker/cbor/v2`. ✓
3. **Add wire values** to `caskdir` for the new types (`typeToWire`, `wireToType`). ✓
4. **Update path resolution** in `cmd/main.go`: replace `== TypeCell` checks with `IsCellDirect()` / `IsCellIndirect()`; add a `derefEntry` helper that handles direct cells, indirect cells (loading descriptors and navigating subpaths), and content types. ✓
5. **Add access checks** to `writeTo`, `removeEntry`, and the `cas` command handler. Each mutation point checks the entry type and rejects operations that exceed the granted capability. ✓
6. **Add `cask mkroot`** command to create attenuated cell references. The source path is walked to discover the cell boundary automatically; subpath segments after the cell become the scope. With `--read-only`, the result is read-only. ✓
7. **Add `cask typeof`** command. ✓
8. **Update `cask ls`** to display type names. ✓
9. **GC**: The mark phase already discovers cell IDs as links in directory blocks (for direct cell entries). Cell path descriptors place the cell ID as a link in the first leaf block, so the same mechanism applies. No new GC logic is needed. ✓
10. **Tests**: Added cases for type predicates, cell path descriptor round-trips, wire format round-trips for all 9 types, path resolution through direct and indirect cell types, access check enforcement, the mkroot command (direct, subpath, read-only, from indirect source), typeof output, and ls display. ✓

## Open questions

1. **Transitive attenuation**: `mkroot` enforces that you cannot escalate beyond your current access level, but the underlying cell ID is visible (in the entry for direct types, in the descriptor for indirect types). A malicious local user could create a `TypeCell` entry with the same cell ID. This is acceptable for the local case (the local user already has access to the block store). For the network case, the capability token system prevents this.
2. **Append-only**: A previous version included `TypeCellAppend` for append-only access. This has been deferred. Enforcing append-only requires diffing old and new directory trees, which is O(n) for large directories. A dedicated append-only data structure (e.g., a log type) would be more efficient; append-only semantics can be revisited when such a structure exists.
3. **Descriptor caching**: Resolving an indirect cell reference requires loading and decoding the descriptor on every access. For frequently accessed entries this adds latency. A resolver cache keyed by descriptor hash would eliminate repeated loads; since descriptors are immutable and content-addressed, caching is straightforward.
4. **Empty path in descriptor**: A descriptor with an empty path array is equivalent to a direct reference. Should the system normalize this (refuse empty-path indirect entries, or convert them to direct entries)? The current design permits it but recommends using direct types when the path is empty.
5. **CBOR dependency**: The descriptor format introduces a CBOR dependency. CBOR is a compact, well-specified binary format (RFC 8949) with mature Go libraries. The alternative (hand-rolling a length-prefixed array encoding) would avoid the dependency but duplicate work that CBOR already solves. The descriptor's CBOR payload is minimal (just an array of text strings), so only a small subset of CBOR is exercised.
6. **Future types**: This design covers blobs, directories, and cells. As new content kinds are introduced (maps, sets, etc.), they will follow the same pattern: cell-based types can attenuate from read+write down to read-only (never the reverse, because CAS requires reading); content-hash types have no meaningful attenuations since the hash reveals the content.

Source: [doc/design/cell-capabilities.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/cell-capabilities.md) at commit `cdb975d8`.
