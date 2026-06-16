---
title: Synthesis target
section-slug: endo--packages-zip-src-format-writer-js--three-stage-pipeline-encode-compress-make-record-and-DOS-date-bit-packing-and-LocalFileLocator-with-three-offsets-and-FileRecord-extends-ArchiveHeaders
source-slug: endo--packages-zip-src-format-writer-js
url: https://github.com/endojs/endo/blob/master/packages/zip/src/format-writer.js
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/zip/src/format-writer.js
total-lines: 264
ingest-cycle: 294
ingest-date: 2026-06-11
lane: chat
scope: full
parent: endo--packages-zip-src-format-writer-js--three-stage-pipeline-encode-compress-make-record-and-DOS-date-bit-packing-and-LocalFileLocator-with-three-offsets-and-FileRecord-extends-ArchiveHeaders
---

Slot machine library `@game/replay/src/format-writer.js`: three-stage pipeline (encodeFile → compressFileWithStore → makeFileRecord); historical-format date-time bit-packing with trailing comments naming each field; epoch shift + truncation mask + low-resolution discipline; named-zero-IS-epoch-origin comment; three typedef block at top with LocalFileLocator + GameRecord + BufferWriter; structural-typing for BufferWriter (duck-typed); GameRecord IS intersection-type-extension of imported GameHeaders; LocalFileLocator with three named offsets for cross-record reference; intra-buffer byte reuse via writeCopy; named UNIX + VERSION constants; module-scope TextEncoder singleton; backslash-to-forward-slash path normalization at encode-time; named TODO comments; commented-out named-future-function for unsupported feature (with TODO above); externalFileAttributes Unix-mode-shifted-to-format with named bit operations; compressionWithStore-named-for-no-actual-compression; crc32 called with only bytes (default parameters pay off); named two-tier public API (low-level + high-level); @see external references for format spec URLs.
