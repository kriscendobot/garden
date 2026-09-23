---
title: §the-stat-shape-projecting-onto-typedef (first-explicit-observation)
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
parent: endo--packages-zip-src-reader-js--ZipReader-class-and-readZip-async-adapter-pair-and-reader-writer-symmetric-pair-shape-and-three-cycles-closing-the-zip-cluster-source-loop
---

The `stat` method returns `{ type: file.type, mode: file.mode, date: file.date, comment: file.comment }` — **explicitly enumerating the four named fields of `ArchivedStat`** (per cycle 282's typedef inventory). This is **§the-explicit-projection-shape**: rather than returning the full `file` object (which would expose `content` and possibly other fields), the method projects to the typedef's exact field set. §the-projection-IS-the-conformance-act.

§two-named-conformance-shapes for the same typedef: §the-`@type`-tag-on-a-callback (used here at line 57) + §the-explicit-projection-of-fields (used here at lines 41-46).
