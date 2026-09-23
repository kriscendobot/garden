---
source: packages/zip/src/{buffer-reader,buffer-writer,crc32,signature,compression,reader,writer}.js + index.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/tree/master/packages/zip/src
source_path: packages/zip/index.js, packages/zip/src/buffer-reader.js, packages/zip/src/buffer-writer.js, packages/zip/src/crc32.js, packages/zip/src/signature.js, packages/zip/src/compression.js, packages/zip/src/reader.js, packages/zip/src/writer.js
section_kind: source
ingested: 2026-06-04
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - bundles
  - tooling
genre: §endo-source-comment-fragment §canonical-byte-format-package
cycle: 191
lane: chat
status: current
title: BufferReader and BufferWriter with WeakMap private fields and bound get, pre-pasted pako crc32 with attribution, IE10 defense comment for historical ghost, and STORE-only zip
parent: endo--packages-zip-src-cluster--BufferReader-and-BufferWriter-with-WeakMap-private-fields-pre-pasted-pako-crc32-and-IE10-defense-comment
---

> §Chat-lane after cycle 190's designs-lane. §The-twenty-
> fifth-consecutive designs/chat alternation cycle (166-191).
> §Cycle-186-break-dev-deps' §Cut-3 (vestigial @endo/zip
> devDeps deleted) made `@endo/zip` a §sink-only leaf
> consumer; §this-cycle-ingests-the-source.

`packages/zip/src/` is a small focused 11-file package
totaling ~1482 lines that implements a §store-only-zip
reader/writer pair. Without `compression.js` (4 lines:
`export const STORE = 0`) and `format-*.js` (the larger
files), the §primitive-substrate is:

| File | Lines | Role |
|------|-------|------|
| `index.js` | 4 | Re-export barrel (ZipReader/readZip/ZipWriter/writeZip) |
| `src/buffer-reader.js` | 274 | Uint8Array+DataView pair with §WeakMap-private-fields |
| `src/buffer-writer.js` | 188 | Doubling-capacity Uint8Array with §ensureCanSeek |
| `src/crc32.js` | 48 | §Pre-pasted-pako with attribution comment |
| `src/signature.js` | 21 | PK\x03\x04 magic numbers + §u-helper |
| `src/compression.js` | 4 | STORE = 0 only |
| `src/reader.js` | 60 | ZipReader class + readZip async wrapper |
| `src/writer.js` | 64 | ZipWriter class + writeZip async wrapper |

§The-single-most-structurally-interesting-move is §WeakMap-
private-fields-with-bound-get + §pre-pasted-pako-crc32-with-
attribution-comment + §IE10-defense-comment-for-historical-
ghost + §store-only-zip-with-named-default. §Four-named-moves
in one byte-format package.
