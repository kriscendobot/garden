---
title: §Import-rename to avoid collision with export
source-slug: endo--packages-zip-src-writer-js
section-slug: ZipWriter-class-and-writeZip-async-adapter-pair-and-import-rename-to-avoid-collision-with-export-and-Unix-permission-default-and-preserved-JSDoc-typo
source-url: https://github.com/endojs/endo/blob/master/packages/zip/src/writer.js
source-repo: endojs/endo
source-path: packages/zip/src/writer.js
source-author: Endo project (collective)
total-lines: 64
ingest-cycle: 280
ingest-date: 2026-06-10
lane: chat
parent: endo--packages-zip-src-writer-js--ZipWriter-class-and-writeZip-async-adapter-pair-and-import-rename-to-avoid-collision-with-export-and-Unix-permission-default-and-preserved-JSDoc-typo
---

Line 4: `import { writeZip as writeZipFormat } from './format-writer.js';`

§The-`writeZip`-from-`./format-writer.js` IS renamed to `writeZipFormat` because line 55's `export const writeZip = () => {...}` would collide.

§First-explicit-observation in library: **§import-rename-to-avoid-collision-with-export — §the-imported-symbol-IS-renamed-at-import-site + §the-renamed-symbol-IS-used-internally + §the-original-name-IS-reused-as-the-public-export + §sibling-pattern to many cluster conventions where the internal function and the public factory share a name**.

§Two-named-`writeZip`-symbols-disambiguated-via-import-rename:
1. **Internal `writeZipFormat`** (from `./format-writer.js`) — the actual ZIP format writer.
2. **Public `writeZip`** (this file's export) — the async-adapter factory.

§The-internal-function-and-the-public-API-share-the-conceptual-name + §the-rename-resolves-the-syntactic-collision-while-preserving-the-conceptual-correspondence; §first-explicit-observation in library.
