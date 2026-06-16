---
title: Single most structurally interesting move
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

**§the-class-exposes-stat-but-the-async-adapter-only-exposes-read** — the async-adapter **deliberately narrows the public interface**. The `ArchiveReader` typedef (from cycle 282's types.js) names *only* `read`; `stat` is a sync convenience on the class but is NOT part of the cross-package contract. The factory enforces this narrowing by destructuring `{ read }` from the constructed reader at the return point, not by hiding the class entirely.

This is **§the-typedef-IS-the-public-contract + the-class-IS-the-private-implementation**, with the factory at the boundary doing the narrowing. The class can grow more methods over time without changing the cross-package contract; the contract is the typedef, not the class. §named-public-private-boundary-via-typedef-narrowing — a distinct discipline from "hide the class entirely" (which would be heavier-handed).
