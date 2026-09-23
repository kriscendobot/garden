---
title: §the-`location`-vs-`name` parameter-naming drift (first-explicit-observation)
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

The `readZip` async-adapter takes `(data, location)`; it then passes `location` to `ZipReader`'s constructor under the parameter name `name` (`new ZipReader(data, { name: location })`). **The same string is called `location` at the outer surface and `name` at the inner surface**. The class abstracts away the "where the file is" specificity into the more general "name" concept.

§named-rename-at-the-API-boundary as a small pattern: the outer-facing API uses the domain term (`location` = "where this zip came from") and the inner-facing class uses the generic term (`name` = "what to call this archive in error messages"). §the-outer-API-IS-domain-specific + §the-inner-class-IS-domain-general — a deliberate abstraction step at the boundary.
