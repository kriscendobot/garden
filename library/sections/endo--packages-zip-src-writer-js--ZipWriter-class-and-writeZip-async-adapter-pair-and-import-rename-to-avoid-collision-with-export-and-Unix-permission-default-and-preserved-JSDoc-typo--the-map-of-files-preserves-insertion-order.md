---
title: §The Map-of-files preserves insertion order
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

Line 15: `this.files = new Map();`

§First-explicit-observation in library: **§the-Map-for-files-IS-a-named-insertion-order-preserving-store — §JS-Maps-preserve-insertion-order + §the-ZIP-format-IS-sensitive-to-file-order + §the-Map-IS-the-canonical-choice-for-ordered-named-key-to-value-mapping**.

§Sibling-pattern to many @endo/* conventions where Map IS preferred over plain Object for: insertion-order preservation + non-string keys + no prototype pollution.
