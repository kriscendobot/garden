---
title: "@endo/zip/src/format-writer.js — three-stage pipeline (encode → compress → makeFileRecord); DOS date-time bit-packing; LocalFileLocator; FileRecord intersection-type-extension"
source-slug: endo--packages-zip-src-format-writer-js
url: https://github.com/endojs/endo/blob/master/packages/zip/src/format-writer.js
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/zip/src/format-writer.js
total-lines: 264
ingest-cycle: 294
ingest-date: 2026-06-11
lane: chat
---

# `@endo/zip/src/format-writer.js`

A 264-line file implementing the zip format writer: encodes `ArchivedFile` inputs through a three-stage pipeline (`encodeFile` → `compressFileWithStore` → `makeFileRecord`), then writes local headers + central directory + end-of-central-directory record via a duck-typed `BufferWriter` interface.

## Key moves

- **§the-three-stage-pipeline-encode-compress-make-record** — `files.map(encodeFile).map(compressFileWithStore).map(makeFileRecord)`; §the-named-four-staged-record-progression (extends cycle 282's three-shapes); ArchivedFile → UncompressedFile → CompressedFile → FileRecord.
- **§the-DOS-date-time-bit-packing-with-trailing-comments-naming-each-field** — six named bit fields in one uint32 (year + month + day + hour + minute + second); §named-historical-format-limitations (7-bit year + 2-second resolution + 1-indexed month).
- **§the-`: 0; // Epoch origin by default.`-comment** — the-comment-IS-the-named-protocol-interpretation-of-the-zero-value.
- **§the-three-typedef-block-at-the-top** — LocalFileLocator + FileRecord + BufferWriter; the-named-local-interface-shape-declaration (BufferWriter declared inline, not imported); the-named-decoupling-via-structural-typing.
- **§the-`FileRecord = Y & import('./types.js').ArchiveHeaders` intersection-type-extension** — §three-cycles-with-intersection-type-syntax-in-JSDoc-typedef (282 + 294).
- **§the-`LocalFileLocator` three-named-offsets** — fileStart + headerStart + headerEnd; the-named-locator-IS-the-named-cross-record-reference-shape.
- **§the-`writer.writeCopy(locator.headerStart, locator.headerEnd)` intra-buffer-byte-reuse** — local-header bytes reused in central-directory-entry; §two-cycles-with-named-intra-buffer-byte-reuse (290 + 294); the-discipline-IS-encode-once-copy-elsewhere.
- **§the-`UNIX = 3` + `UNIX_VERSION = 30`-named-constants** — the-named-constant-IS-the-named-documentation.
- **§the-module-scope-`textEncoder = new TextEncoder()`-singleton** — eager singleton at module load; the-singleton-IS-the-named-amortization-shape; §three-cycles-with-module-load-time-amortization-shapes (286 crc32 table + 294 textEncoder + earlier).
- **§the-name-with-backslash-to-forward-slash-normalization** — `file.name.replace(/\\/g, '/')`; named platform-portability normalization at encode-time.
- **§the-named-TODO-comments** — seven named TODOs enumerating specific format features deferred (extra fields + directory records + versionNeeded); the-named-incompleteness-discipline; §three-named-shapes-for-tracking-deferred-work (cycle 283/287 `## Open Questions` + cycle 291 `TBD:` + cycle 294 in-code `// TODO`).
- **§the-commented-out-named-future-function** — `externalDirectoryAttributes(mode)` block-commented with TODO above + the format-specific magic-number documented inside the commented code; the-named-block-commented-function-as-named-stub-preserving-implementation; §two-named-shapes-of-deferred-work-in-code (in-line-TODO + commented-block).
- **§the-`externalFileAttributes(mode)` Unix-mode-shifted-to-zip-format** — `((mode & 0o777) | 0o100000) << 16`; three named bit operations (mask + or + shift); the-named-magic-octal-literals (0o777 Unix permission mask + 0o100000 regular-file marker).
- **§the-`compressFileWithStore`-named-for-the-only-supported-compression** — function name IS explicit about no-compression-discipline; the-discipline-IS-named-store-only-zip.
- **§the-`crc32(file.content)` IS-called-with-only-bytes** — §the-named-default-parameters-pay-off (cycle 286's default-parameter shape benefits the simple call site).
- **§the-named-three-public-export-shapes** — writeZipRecords (low-level) + writeZip (high-level); the-named-two-tier-API.
- **§the-named-`@see` external-references** — DJGPP DOS format spec URLs; §two-cycles-with-named-vocabulary-deference (293 tc39 + 294 DJGPP-DOS-spec).
- **§two-cycles-with-the-`Date?`-shorthand** (282 + 294).
- **§the-zip-cluster-source-file-deep-ingest-progresses (10 of 12 files now per-file ingested)**.

## Section files

- [§three-stage-pipeline + §DOS-date-bit-packing + §LocalFileLocator + §FileRecord-intersection-extension + 33 more first-explicit-observations](../sections/endo--packages-zip-src-format-writer-js--three-stage-pipeline-encode-compress-make-record-and-DOS-date-bit-packing-and-LocalFileLocator-with-three-offsets-and-FileRecord-extends-ArchiveHeaders.md) — full 264-line file in scope at cycle 294 per-file deep ingest after cluster-scope in cycle 191.

## Ingest scope

Cycle 294 (chat-lane after cycle 293 designs-lane @endo/ses/docs/guide.md). Full 264-line file in scope. **First-explicit-observations (thirty-seven)** at per-file deep ingest scope, extending cycle 191's cluster-scope coverage. The zip cluster source-file deep ingest now progresses to 10 of 12 files.
