---
title: "`@endo/zip/src/format-writer.js` (full file)"
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

A 264-line file implementing the zip format writer: encodes `ArchivedFile` inputs through a three-stage pipeline (`encodeFile` → `compressFileWithStore` → `makeFileRecord`), then writes local file headers + central directory headers + end-of-central-directory record via a `BufferWriter` interface. Per-file deep ingest extending cycle 191's cluster-scope coverage.
