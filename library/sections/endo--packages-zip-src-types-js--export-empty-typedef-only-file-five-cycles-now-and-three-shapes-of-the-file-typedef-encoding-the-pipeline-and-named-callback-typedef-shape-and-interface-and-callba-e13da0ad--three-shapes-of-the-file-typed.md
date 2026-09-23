---
title: §Three shapes of the file typedef encoding the pipeline
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

Lines 6-36 define §three-shape-versions-of-the-conceptual-file:

1. **`ArchivedFile`** (the input/output shape) — `name: string` + `content: Uint8Array` + ArchivedStat fields.
2. **`UncompressedFile`** (the on-the-wire pre-compression shape) — `name: Uint8Array` (binary) + `content: Uint8Array` + binary `comment`.
3. **`CompressedFile`** (the on-the-wire compressed shape) — `name: Uint8Array` + `crc32: number` + `compressionMethod: number` + `compressedLength: number` + `uncompressedLength: number` + `content: Uint8Array` + `comment: Uint8Array`.

§First-explicit-observation in library: **§three-shapes-of-the-file-typedef-encoding-the-pipeline — §input-shape (string name + ArchivedStat metadata) + §uncompressed-wire-shape (Uint8Array name + content) + §compressed-wire-shape (Uint8Array name + content + crc32 + compression metadata) + §each-shape-encodes-a-stage-of-the-pipeline**.

§The-conceptual-shift-from-string-to-Uint8Array — §the-input-shape-uses-`string`-for-name + §the-wire-shapes-use-`Uint8Array` because the ZIP format stores names as bytes; §the-shape-distinction-encodes-the-format-boundary.

§Sibling-pattern to many serialization-format types where input + wire + compressed-wire shapes are distinct.
