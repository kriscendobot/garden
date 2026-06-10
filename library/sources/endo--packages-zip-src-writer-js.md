---
title: "@endo/zip/src/writer.js — ZipWriter class + writeZip async adapter pair"
source-slug: endo--packages-zip-src-writer-js
url: https://github.com/endojs/endo/blob/master/packages/zip/src/writer.js
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/zip/src/writer.js
total-lines: 64
ingest-cycle: 280
ingest-date: 2026-06-10
lane: chat
---

# `@endo/zip/src/writer.js`

A 64-line file that exports the `ZipWriter` class **paired with** the `writeZip()` async-adapter factory function. Instantiates the class-and-async-adapter pair shape.

## Key moves

- **§The class-and-async-adapter pair as named discipline** — synchronous mutable class (ZipWriter) + thin async adapter factory (writeZip) wrapping the class behind deferred-not-truly-async API.
- **§The sync mutable class with named snapshot method** — accumulates state via `write()`; `snapshot()` produces Uint8Array; sibling-pattern to CRDT and immutable-collection conventions.
- **§The Map for files IS a named insertion-order-preserving store** — JS Maps preserve insertion order; ZIP format IS sensitive to file order.
- **§The sync class wrapped by async adapter pattern** (deferred-not-async) — `async` keyword on signature; sync body; abstraction promises async semantics for future implementations.
- **§The thin async wrapper around thick sync class** — class has 50+ lines; wrapper has 10 lines; wrapper's only job IS the async protocol.
- **§Import-rename to avoid collision with export** — `import { writeZip as writeZipFormat }` because the public export IS also named `writeZip`.
- **§The `0o644` permission default as named Unix convention** — `-rw-r--r--`; canonical default for non-executable files.
- **§The explicit-undefined-as-default pattern** when the absence IS meaningful — `date = undefined` not omitted.
- **§The `Error(...)` without `new` shorthand** — JS allows Error() as function call.
- **§A preserved JSDoc typo** — `/** type {Map<string, ZFile>} */` missing the `@` on `type`; the lint-and-tsc check (per project CLAUDE.md) should have caught this but didn't.
- **§Two named shapes of preserved typo** — deliberate-informal-status (cycle 263) + imperfect-review-trace (cycle 280).
- **§Three named typedefs imported for typing the thin wrapper** — ArchiveWriter + WriteFn + SnapshotFn.

## Section files

- [§ZipWriter class + writeZip async adapter pair + import-rename + Unix permission default + preserved JSDoc typo](../sections/endo--packages-zip-src-writer-js--ZipWriter-class-and-writeZip-async-adapter-pair-and-import-rename-to-avoid-collision-with-export-and-Unix-permission-default-and-preserved-JSDoc-typo.md) — full 64-line file in scope.

## Ingest scope

Cycle 280 (chat-lane after cycle 279's designs-lane cli-edit-verb). Full 64-line file ingested. **First-explicit-observations (twelve)**: the-class-and-async-adapter-pair-as-named-discipline + the-sync-mutable-class-with-named-snapshot-method + two-cycles-with-named-snapshot-method-returning-different-shape-types + the-Map-for-files-IS-a-named-insertion-order-preserving-store + the-sync-class-wrapped-by-async-adapter-pattern + the-thin-async-wrapper-around-thick-sync-class + import-rename-to-avoid-collision-with-export + the-`0o644`-permission-default-as-named-Unix-convention + the-explicit-undefined-as-default-pattern + the-`Error(...)`-without-`new`-shorthand + a-preserved-JSDoc-typo + two-named-shapes-of-preserved-typo.
