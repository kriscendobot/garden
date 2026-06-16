---
title: §The ZipWriter class — synchronous mutable API
source-slug: endo--packages-zip-src-writer-js
section-slug: ZipWriter-class-and-writeZip-async-adapter-pair-and-import-rename-to-avoid-collision-with-export-and-Unix-permission-default-and-preserved-JSDoc-typo
source-url: https://github.com/endojs/endo/blob/master/packages/zip/src/writer.js
source-repo: endojs/endo
source-path: packages/zip/src/writer.js
source-author: Endo project (collective)
total-lines: 64
ingest-cycle: 280
ingest-date: 2026-06-10
lane: chat
parent: endo--packages-zip-src-writer-js--ZipWriter-class-and-writeZip-async-adapter-pair-and-import-rename-to-avoid-collision-with-export-and-Unix-permission-default-and-preserved-JSDoc-typo
---

Lines 6-50 carry the §sync-mutable-class:
- **Constructor** with `options = { date: new Date() }` default.
- **`write(name, content, options)`** — adds a file to the internal Map.
- **`snapshot()`** — produces a Uint8Array of the full ZIP buffer.

§First-explicit-observation in library: **§the-sync-mutable-class-with-named-snapshot-method — §the-class-accumulates-state-via-`write()` + §`snapshot()`-produces-the-current-serialized-form-without-mutating-the-class-state + §sibling-pattern to many CRDT and immutable-collection conventions (Automerge `Doc.snapshot()`; immutable.js `.toJS()`)**.

§The-`snapshot`-method-returns-a-Uint8Array-via-`writer.subarray()` — §the-BufferWriter's-`subarray()`-returns-the-whole-written-buffer; §sibling-pattern to many builder-pattern conventions where the final `.build()` or `.snapshot()` returns the accumulated structure.

§Two-named-snapshot-conventions-now (cycle 259's Browser.snapshot() returning text-or-screenshot + cycle 280's ZipWriter.snapshot() returning Uint8Array); §two-cycles-with-named-snapshot-method-returning-different-shape-types (259 + 280).
