---
title: "@endo/zip/src/reader.js — ZipReader sync class + readZip async-adapter pair; reader-writer symmetric-pair shape; closes the zip cluster source-file loop"
section-slug: endo--packages-zip-src-reader-js--ZipReader-class-and-readZip-async-adapter-pair-and-reader-writer-symmetric-pair-shape-and-three-cycles-closing-the-zip-cluster-source-loop
source-slug: endo--packages-zip-src-reader-js
url: https://github.com/endojs/endo/blob/master/packages/zip/src/reader.js
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/zip/src/reader.js
total-lines: 60
ingest-cycle: 284
ingest-date: 2026-06-10
lane: chat
scope: full
kind: index
section_count: 17
---

Sections:

- [`@endo/zip/src/reader.js` (full file)](endo--packages-zip-src-reader-js--ZipReader-class-and-readZip-async-adapter-pair-and-reader-writer-symmetric-pair-shape-and-three-cycles-closing-the-zip-cluster-source-loop--endo-zip-src-reader-js-full-file.md)
- [Key moves](endo--packages-zip-src-reader-js--ZipReader-class-and-readZip-async-adapter-pair-and-reader-writer-symmetric-pair-shape-and-three-cycles-closing-the-zip-cluster-source-loop--key-moves.md)
- [The structure](endo--packages-zip-src-reader-js--ZipReader-class-and-readZip-async-adapter-pair-and-reader-writer-symmetric-pair-shape-and-three-cycles-closing-the-zip-cluster-source-loop--the-structure.md)
- [§the-import-rename-to-avoid-collision-with-export reaffirmed](endo--packages-zip-src-reader-js--ZipReader-class-and-readZip-async-adapter-pair-and-reader-writer-symmetric-pair-shape-and-three-cycles-closing-the-zip-cluster-source-loop--the-import-rename-to-avoid-collision-with-export-reaffirmed.md)
- [§the-`as`-rename-import-pattern as named cluster discipline](endo--packages-zip-src-reader-js--ZipReader-class-and-readZip-async-adapter-pair-and-reader-writer-symmetric-pair-shape-and-three-cycles-closing-the-zip-cluster-source-loop--the-as-rename-import-pattern-as-named-cluster-discipline.md)
- [§the-three-line-async-adapter shape](endo--packages-zip-src-reader-js--ZipReader-class-and-readZip-async-adapter-pair-and-reader-writer-symmetric-pair-shape-and-three-cycles-closing-the-zip-cluster-source-loop--the-three-line-async-adapter-shape.md)
- [§the-`location`-vs-`name` parameter-naming drift (first-explicit-observation)](endo--packages-zip-src-reader-js--ZipReader-class-and-readZip-async-adapter-pair-and-reader-writer-symmetric-pair-shape-and-three-cycles-closing-the-zip-cluster-source-loop--the-location-vs-name-parameter.md)
- [§the-error-message-naming-both-names shape (first-explicit-observation)](endo--packages-zip-src-reader-js--ZipReader-class-and-readZip-async-adapter-pair-and-reader-writer-symmetric-pair-shape-and-three-cycles-closing-the-zip-cluster-source-loop--the-error-message-naming-both.md)
- [§two-named-Map-lookup-then-act-shapes in one class (first-explicit-observation)](endo--packages-zip-src-reader-js--ZipReader-class-and-readZip-async-adapter-pair-and-reader-writer-symmetric-pair-shape-and-three-cycles-closing-the-zip-cluster-source-loop--two-named-map-lookup-then-act.md)
- [§the-stat-shape-projecting-onto-typedef (first-explicit-observation)](endo--packages-zip-src-reader-js--ZipReader-class-and-readZip-async-adapter-pair-and-reader-writer-symmetric-pair-shape-and-three-cycles-closing-the-zip-cluster-source-loop--the-stat-shape-projecting-onto.md)
- [§the-content-field-is-deliberately-not-in-stat (first-explicit-observation)](endo--packages-zip-src-reader-js--ZipReader-class-and-readZip-async-adapter-pair-and-reader-writer-symmetric-pair-shape-and-three-cycles-closing-the-zip-cluster-source-loop--the-content-field-is-deliberat.md)
- [§the-`// @ts-check`-on-every-file-of-the-zip-cluster reaffirmed (now four files)](endo--packages-zip-src-reader-js--ZipReader-class-and-readZip-async-adapter-pair-and-reader-writer-symmetric-pair-shape-and-three-cycles-closing-the-zip-cluster-source-loop--the-ts-check-on-every-file-of.md)
- [§the-Map-lookup-IS-the-shared-mechanism (first-explicit-observation)](endo--packages-zip-src-reader-js--ZipReader-class-and-readZip-async-adapter-pair-and-reader-writer-symmetric-pair-shape-and-three-cycles-closing-the-zip-cluster-source-loop--the-map-lookup-is-the-shared-m.md)
- [Patterns from prior cycles, reaffirmed](endo--packages-zip-src-reader-js--ZipReader-class-and-readZip-async-adapter-pair-and-reader-writer-symmetric-pair-shape-and-three-cycles-closing-the-zip-cluster-source-loop--patterns-from-prior-cycles-reaffirmed.md)
- [Borrowing tiers](endo--packages-zip-src-reader-js--ZipReader-class-and-readZip-async-adapter-pair-and-reader-writer-symmetric-pair-shape-and-three-cycles-closing-the-zip-cluster-source-loop--borrowing-tiers.md)
- [Synthesis target](endo--packages-zip-src-reader-js--ZipReader-class-and-readZip-async-adapter-pair-and-reader-writer-symmetric-pair-shape-and-three-cycles-closing-the-zip-cluster-source-loop--synthesis-target.md)
- [Single most structurally interesting move](endo--packages-zip-src-reader-js--ZipReader-class-and-readZip-async-adapter-pair-and-reader-writer-symmetric-pair-shape-and-three-cycles-closing-the-zip-cluster-source-loop--single-most-structurally-interesting-move.md)
