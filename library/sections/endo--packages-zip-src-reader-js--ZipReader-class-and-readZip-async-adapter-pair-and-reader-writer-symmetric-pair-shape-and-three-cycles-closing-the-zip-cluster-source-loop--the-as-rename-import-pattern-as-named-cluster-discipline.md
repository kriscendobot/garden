---
title: §the-`as`-rename-import-pattern as named cluster discipline
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

The zip cluster uses **a `as`-rename-import for every "top-level public name" it then re-exports**: format-reader.js exports `readZip` (the format-level read), reader.js wants to export `readZip` (the high-level read). The rename `readZip as readZipFormat` *resolves the collision in the simplest possible way* — same name in two namespaces, distinguished by the `Format` suffix at the consuming site. §the-suffix-IS-`Format`-naming-the-narrower-format-level-shape.
