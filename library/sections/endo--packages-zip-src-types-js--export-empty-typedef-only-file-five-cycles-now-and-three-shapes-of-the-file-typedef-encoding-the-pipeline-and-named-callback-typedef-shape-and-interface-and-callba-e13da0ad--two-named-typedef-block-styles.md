---
title: §Two named typedef-block styles
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

Lines 5-47 carry §a-multi-typedef-block — one `/** ... */` containing five typedefs (ArchivedStat + ArchivedFile + UncompressedFile + CompressedFile + ArchiveHeaders).

Lines 49-76 carry §three-single-typedef-blocks — each `/** @typedef ... */` defines one typedef (ArchiveReader + ReadFn + ArchiveWriter + WriteFn + SnapshotFn).

§First-explicit-observation in library: **§two-named-typedef-block-styles — §multi-typedef-block-style (one comment containing many typedefs) + §single-typedef-block-style (one typedef per comment) + §the-file-uses-both + §the-discipline-IS-group-related-data-typedefs-together-and-give-each-callback-typedef-its-own-comment**.

§Sibling-pattern to many JSDoc-heavy codebases where the choice between block styles signals relatedness.
