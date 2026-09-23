---
title: "`@endo/zip/src/reader.js` (full file)"
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

A 60-line file (the smallest of the zip cluster's three source files we've ingested) that mirrors cycle 280's `writer.js` exactly in shape: a `ZipReader` **sync mutable class** + a `readZip` **async-adapter factory** that wraps it and returns an `ArchiveReader` interface. **Closes the zip cluster source-file loop**: cycle 280 ingested the writer, cycle 282 ingested the typedef vocabulary, cycle 284 ingests the reader — three sibling files producing, declaring, and consuming the same typedef set.
