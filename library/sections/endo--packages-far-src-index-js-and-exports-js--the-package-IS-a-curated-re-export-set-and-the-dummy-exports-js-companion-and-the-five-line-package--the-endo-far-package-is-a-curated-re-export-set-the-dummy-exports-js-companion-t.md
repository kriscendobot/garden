---
title: The `@endo/far` package IS a curated re-export set + the dummy `exports.js` companion + the five-line package
source-slug: endo--packages-far-src-index-js-and-exports-js
source-url: https://github.com/endojs/endo/blob/master/packages/far/src/index.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/far/src/index.js + packages/far/src/exports.js
total-lines: 7 (5 + 2)
ingest-cycle: 258
ingest-date: 2026-06-10
lane: chat
parent: endo--packages-far-src-index-js-and-exports-js--the-package-IS-a-curated-re-export-set-and-the-dummy-exports-js-companion-and-the-five-line-package
---

[`@endo/far/src/index.js`](../sources/endo--packages-far-src-index-js-and-exports-js.md) is a §five-line-file that re-exports four canonical capability operations from two upstream packages, plus a `export * from './exports.js'` that pulls in the package's typedef vocabulary. The sibling [`@endo/far/src/exports.js`](../sources/endo--packages-far-src-index-js-and-exports-js.md) is a §two-line-dummy-file containing `export {};` whose purpose is to "use exports.d.ts and satisfy runtime imports."

§The-package's-entire-runtime-surface is **seven lines** (5 + 2). §First-direct-ingest from `@endo/far/src/`.
