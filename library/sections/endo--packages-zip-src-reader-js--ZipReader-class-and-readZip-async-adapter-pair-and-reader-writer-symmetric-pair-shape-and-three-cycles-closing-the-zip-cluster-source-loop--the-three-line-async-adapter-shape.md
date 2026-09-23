---
title: §the-three-line-async-adapter shape
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

`readZip`'s body is *three statements in five lines including blank-line padding*: construct, type-annotate-and-bind read, return narrowed interface. **The async-adapter pattern can be this tight** when the underlying class already does the work; cycle 280's `writeZip` was much longer (60 lines for its body) because it composed reader-from-keys + per-file iteration + snapshot.

§named-spectrum-of-async-adapter-density: dense (cycle 280's writeZip ~60 lines wrapping write+snapshot loop) vs sparse (cycle 284's readZip ~5 lines).
