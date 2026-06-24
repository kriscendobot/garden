---
title: §The interface-and-callback pair shape
source-slug: endo--packages-zip-src-types-js
section-slug: export-empty-typedef-only-file-five-cycles-now-and-three-shapes-of-the-file-typedef-encoding-the-pipeline-and-named-callback-typedef-shape-and-interface-and-callback-pair-and-closes-the-typedef-loop-with-cycle-280
source-url: https://github.com/endojs/endo/blob/master/packages/zip/src/types.js
source-repo: endojs/endo
source-path: packages/zip/src/types.js
source-author: Endo project (collective)
total-lines: 76
ingest-cycle: 282
ingest-date: 2026-06-10
lane: chat
parent: endo--packages-zip-src-types-js--export-empty-typedef-only-file-five-cycles-now-and-three-shapes-of-the-file-typedef-encoding-the-pipeline-and-named-callback-typedef-shape-and-interface-and-callback-pair-and-closes-the-typedef-loop-with-cycle-280
---

Lines 50-58 carry §the-interface-and-callback-pair-for-ArchiveReader:
- **`ArchiveReader`** (interface; `@typedef object`) — `{ read: ReadFn }`.
- **`ReadFn`** (function; `@callback`) — `(name: string) => Promise<Uint8Array>`.

Lines 61-76 carry the §interface-and-callback-pair-for-ArchiveWriter:
- **`ArchiveWriter`** (interface) — `{ write: WriteFn, snapshot: SnapshotFn }`.
- **`WriteFn`** (function) — `(name, bytes) => Promise<void>`.
- **`SnapshotFn`** (function) — `() => Promise<Uint8Array>`.

§First-explicit-observation in library: **§the-interface-and-callback-pair-shape — §the-interface-typedef-references-named-callback-typedefs + §the-callback-typedefs-are-named-and-defined-separately + §the-discipline-IS-named-method-types-not-inline-function-types**.

§Sibling-pattern to TypeScript's `interface ArchiveWriter { write: WriteFn; snapshot: SnapshotFn; }` discipline applied in JSDoc.

§Three-cycles-with-closing-the-typedef-import-loop (263+273 + 268+270 + 280+282); §the-loop-closure-IS-an-emerging-meta-pattern (cycle 270's observation now confirmed across three pair-types).
