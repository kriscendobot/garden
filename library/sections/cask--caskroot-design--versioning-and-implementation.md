---
title: Future Versions, Implementation Plan, and Files
source: doc/design/caskroot-design.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [content-addressed-storage]
status: current
---

Abstract: How the schema hash makes root-format evolution cheap, plus the build plan. When caskhead1 is needed: define a new SchemaV1 hash, add new fields to the root block, and in `Load()` branch on the schema hash (SchemaV0 → v0 code or migrate; SchemaV1 → v1 code); migration loads v0, constructs v1 with new fields defaulted, and writes v1. The schema hash in `Links[0]` makes version detection **O(1)** — just compare the first link. The implementation plan is five steps (create the `caskhead` package, define the SchemaV0 constant, implement New/Load/Get-Set, add session-state blob encode/decode helpers, write tests) landing in `go/cask/head/` as `head.go` (Head structure + New/Load/Get/Set), `session_state.go` (blob encode/decode), and `head_test.go`.

## Future versions

When caskhead1 is needed:

1. Define a new SchemaV1 hash.
2. Add new fields to the root block.
3. In `Load()`, check the schema hash:
   - If SchemaV0: use v0 code or migrate.
   - If SchemaV1: use v1 code.
4. Migration: load v0, construct v1 with new fields defaulted, write v1.

The schema hash in `Links[0]` makes version detection O(1) — just compare the first link.

## Implementation plan

1. Create `caskhead` package.
2. Define SchemaV0 constant.
3. Implement New, Load, GetSessionsRoot, SetSessionsRoot.
4. Add session-state blob helpers (encode/decode).
5. Write tests.

## Files

```
go/cask/head/
 ├─► head.go           : Head structure, New, Load, Get/Set
 ├─► session_state.go  : Session state blob encode/decode
 ├─► head_test.go      : Tests
```

Source: [doc/design/caskroot-design.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/caskroot-design.md) at commit `cdb975d8`.
