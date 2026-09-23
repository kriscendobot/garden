---
title: §the-error-message-naming-both-names shape (first-explicit-observation)
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

The error message includes *both* names: the missing file name AND the archive's own name. `Cannot find file ${name} in Zip file ${this.name}`. The reader was given a name (defaulting to `<unknown>`) precisely so that this kind of error message can identify which archive complained.

§the-error-naming-both-the-missing-thing-AND-the-container-IS-a-debuggability-discipline; §the-archive-needs-a-name-precisely-so-errors-can-name-it.
