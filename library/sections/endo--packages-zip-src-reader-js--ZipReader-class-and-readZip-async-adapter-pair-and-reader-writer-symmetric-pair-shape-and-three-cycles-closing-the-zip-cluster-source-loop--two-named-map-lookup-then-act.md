---
title: §two-named-Map-lookup-then-act-shapes in one class (first-explicit-observation)
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

Both `read` and `stat` do `this.files.get(name)`. They diverge on what to do when the result is undefined: `read` throws, `stat` returns undefined. **The branch on undefined is the API decision point**, not the lookup mechanism. This is **§the-presence-check-IS-the-API-branch** — the same data, two named missing-behaviors.

§read-throws-on-missing (forcing the caller to handle) + §stat-returns-undefined (letting the caller probe).
