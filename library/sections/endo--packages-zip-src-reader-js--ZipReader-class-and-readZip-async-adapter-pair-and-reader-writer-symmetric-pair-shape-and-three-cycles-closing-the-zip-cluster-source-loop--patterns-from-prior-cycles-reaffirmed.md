---
title: Patterns from prior cycles, reaffirmed
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

- **§the-`// @ts-check`-directive** (cycle 273 project CLAUDE.md observation; reaffirmed cycle 282; now four cycles).
- **§the-sync-class-wrapped-by-async-adapter-pattern** (cycle 280 first-explicit-observation; reaffirmed here at minimal expression).
- **§import-rename-to-avoid-collision-with-export** (cycle 280 first-explicit-observation; second cycle in same cluster).
- **§the-class-and-async-adapter-pair-as-named-discipline** (cycle 280; second cycle).
- **§the-`Error()`-without-`new`-shorthand** (cycle 280; second cycle).
- **§the-Map-for-files-IS-a-named-insertion-order-preserving-store** (cycle 280; second cycle — but only implicitly; reader doesn't iterate in order).
- **§the-sync-snapshot-method** — analogue here is sync read and sync stat (cycle 280's snapshot was sync too).
- **§explicit-confinement-by-omission** (234 + 238 + 259 + 284 — fourth cycle; now also applied to API-design, not just security).
- **§five-cycles-with-`// @ts-check`-on-every-file-of-the-zip-cluster** if we count signature.js (278) + writer.js (280) + types.js (282) + reader.js (284) + the implicit observation from the other files we haven't yet ingested.
