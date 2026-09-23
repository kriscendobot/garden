---
title: §the-Map-lookup-IS-the-shared-mechanism (first-explicit-observation)
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

The `this.files` map (constructed by `readZipFormat` at construction time) IS the shared state for both read and stat. **The class is a thin wrapper over a Map**, with a name and two access methods. §the-class-IS-essentially-a-named-Map-with-an-archive-label.

§the-class-IS-a-Map + §the-class-IS-essentially-(state, label, read, stat).
