---
title: §the-import-rename-to-avoid-collision-with-export reaffirmed
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

Cycle 280 noted: `import { writeZip as writeZipFormat }` in writer.js — the file *renames the format-level import on the way in* so it can *export its own `writeZip` name*. Reader.js does the **exact same** thing: `import { readZip as readZipFormat } from './format-reader.js';`. **§two-cycles-with-import-rename-to-avoid-collision-with-export in the same cluster** (280 + 284).
