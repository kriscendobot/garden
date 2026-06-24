---
title: "@endo/zip/src/writer.js — ZipWriter class + writeZip async adapter pair + import-rename to avoid collision with export + Unix permission default 0o644 + preserved JSDoc typo (missing @ on type annotation)"
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
kind: index
section_count: 16
---

Sections:

- [`@endo/zip/src/writer.js` — the class-and-async-adapter pair](endo--packages-zip-src-writer-js--ZipWriter-class-and-writeZip-async-adapter-pair-and-import-rename-to-avoid-collision-with-export-and-Unix-permission-default-and-preserved-JSDoc-typo--endo-zip-src-writer-js-the-cla.md)
- [§The ZipWriter class — synchronous mutable API](endo--packages-zip-src-writer-js--ZipWriter-class-and-writeZip-async-adapter-pair-and-import-rename-to-avoid-collision-with-export-and-Unix-permission-default-and-preserved-JSDoc-typo--the-zipwriter-class-synchronous-mutable-api.md)
- [§The Map-of-files preserves insertion order](endo--packages-zip-src-writer-js--ZipWriter-class-and-writeZip-async-adapter-pair-and-import-rename-to-avoid-collision-with-export-and-Unix-permission-default-and-preserved-JSDoc-typo--the-map-of-files-preserves-insertion-order.md)
- [§The writeZip() async-adapter factory — ten lines wrapping the class](endo--packages-zip-src-writer-js--ZipWriter-class-and-writeZip-async-adapter-pair-and-import-rename-to-avoid-collision-with-export-and-Unix-permission-default-and-preserved-JSDoc-typo--the-writezip-async-adapter-fac.md)
- [§Import-rename to avoid collision with export](endo--packages-zip-src-writer-js--ZipWriter-class-and-writeZip-async-adapter-pair-and-import-rename-to-avoid-collision-with-export-and-Unix-permission-default-and-preserved-JSDoc-typo--import-rename-to-avoid-collision-with-export.md)
- [§Named options pattern with three named option fields](endo--packages-zip-src-writer-js--ZipWriter-class-and-writeZip-async-adapter-pair-and-import-rename-to-avoid-collision-with-export-and-Unix-permission-default-and-preserved-JSDoc-typo--named-options-pattern-with-three-named-option-fields.md)
- [§The `if (!content) throw Error(...)` validation](endo--packages-zip-src-writer-js--ZipWriter-class-and-writeZip-async-adapter-pair-and-import-rename-to-avoid-collision-with-export-and-Unix-permission-default-and-preserved-JSDoc-typo--the-if-content-throw-error-validation.md)
- [§The preserved JSDoc typo — `type {Map<string, ZFile>}` missing the `@`](endo--packages-zip-src-writer-js--ZipWriter-class-and-writeZip-async-adapter-pair-and-import-rename-to-avoid-collision-with-export-and-Unix-permission-default-and-preserved-JSDoc-typo--the-preserved-jsdoc-typo-type.md)
- [§Three named typedefs imported for typing the thin wrapper](endo--packages-zip-src-writer-js--ZipWriter-class-and-writeZip-async-adapter-pair-and-import-rename-to-avoid-collision-with-export-and-Unix-permission-default-and-preserved-JSDoc-typo--three-named-typedefs-imported.md)
- [§Cycle 280 first-explicit-observations roundup (twelve)](endo--packages-zip-src-writer-js--ZipWriter-class-and-writeZip-async-adapter-pair-and-import-rename-to-avoid-collision-with-export-and-Unix-permission-default-and-preserved-JSDoc-typo--cycle-280-first-explicit-observations-roundup-twelve.md)
- [§Recurring meta-pattern counters bumped at cycle 280](endo--packages-zip-src-writer-js--ZipWriter-class-and-writeZip-async-adapter-pair-and-import-rename-to-avoid-collision-with-export-and-Unix-permission-default-and-preserved-JSDoc-typo--recurring-meta-pattern-counters-bumped-at-cycle-280.md)
- [§Synthesis target — slot machine library](endo--packages-zip-src-writer-js--ZipWriter-class-and-writeZip-async-adapter-pair-and-import-rename-to-avoid-collision-with-export-and-Unix-permission-default-and-preserved-JSDoc-typo--synthesis-target-slot-machine-library.md)
- [§Tier-1 borrowing](endo--packages-zip-src-writer-js--ZipWriter-class-and-writeZip-async-adapter-pair-and-import-rename-to-avoid-collision-with-export-and-Unix-permission-default-and-preserved-JSDoc-typo--tier-1-borrowing.md)
- [§Tier-2 borrowing](endo--packages-zip-src-writer-js--ZipWriter-class-and-writeZip-async-adapter-pair-and-import-rename-to-avoid-collision-with-export-and-Unix-permission-default-and-preserved-JSDoc-typo--tier-2-borrowing.md)
- [§Tier-3 borrowing](endo--packages-zip-src-writer-js--ZipWriter-class-and-writeZip-async-adapter-pair-and-import-rename-to-avoid-collision-with-export-and-Unix-permission-default-and-preserved-JSDoc-typo--tier-3-borrowing.md)
- [Pattern summary (tag-prefixed)](endo--packages-zip-src-writer-js--ZipWriter-class-and-writeZip-async-adapter-pair-and-import-rename-to-avoid-collision-with-export-and-Unix-permission-default-and-preserved-JSDoc-typo--pattern-summary-tag-prefixed.md)
