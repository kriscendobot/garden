---
title: §the-content-field-is-deliberately-not-in-stat (first-explicit-observation)
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

The `ArchivedFile` typedef (cycle 282) includes `content: string` + the four stat fields. The `ArchivedStat` typedef explicitly **omits** `content`. The `stat` method's projection therefore **deliberately omits content** — `stat` lets the caller inspect metadata without paying the cost of materializing the bytes. §the-stat-IS-a-strict-subset-of-the-archived-file-shape; §the-omission-IS-the-named-design-decision (cycle 259's §confinement-by-omission-the-omission-IS-the-defense shape, now applied to API design rather than security).

§the-confinement-by-omission-pattern-applied-to-API-design: in cycle 259 (Page interface) the omission was a security defense (no cookies, no localStorage, no network); here the omission is a *cost-deferred-read* discipline. **The same shape applied to two different concerns**.

§four-cycles-with-explicit-confinement-by-omission (234 + 238 + 259 + 284).
