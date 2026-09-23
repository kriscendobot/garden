---
title: Single most structurally interesting move
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

**§the-three-stage-pipeline-encode-compress-make-record** with **§the-named-four-staged-record-progression** — the `writeZip` function IS just three `.map()` calls in series: `files.map(encodeFile).map(compressFileWithStore).map(makeFileRecord)`. Each stage IS a *named typed transformation*: `ArchivedFile → UncompressedFile → CompressedFile → FileRecord`. The composition IS explicit; the types IS at the boundaries.

This generalizes the cycle 282 observation (§three-shapes-of-the-file-typedef-encoding-the-pipeline) into a **four-shape progression**: not just the three wire-format shapes from types.js (ArchivedFile + UncompressedFile + CompressedFile), but a *fourth* shape (FileRecord) that adds the zip-format-specific fields (centralName + madeBy + version + diskNumberStart + ...).

§the-named-pipeline-IS-three-named-typed-transforms-from-four-named-shapes: a discipline where each stage IS a named function + a named typedef + the function name + the typedef name correspond. The pipeline IS *self-documenting* via its named stage names.

The pattern generalizes to any encoding pipeline: define N+1 named shapes for N transformations, name each transformation function after what it produces, then compose the transformations with `.map()`. Readers see the shape progression in the type signatures + the transformation discipline in the function names.

§the-named-staged-pipeline-IS-the-self-documenting-encoding-discipline.
