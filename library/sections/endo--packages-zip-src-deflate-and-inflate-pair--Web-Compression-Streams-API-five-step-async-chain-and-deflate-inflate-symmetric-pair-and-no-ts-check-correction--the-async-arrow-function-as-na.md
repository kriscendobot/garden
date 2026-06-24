---
title: §the-async-arrow-function-as-named-substrate-of-the-helper (first-explicit-observation in this context)
section-slug: endo--packages-zip-src-deflate-and-inflate-pair--Web-Compression-Streams-API-five-step-async-chain-and-deflate-inflate-symmetric-pair-and-no-ts-check-correction
source-slug: endo--packages-zip-src-deflate-and-inflate-pair
url: https://github.com/endojs/endo/blob/master/packages/zip/src/{deflate,inflate}.js
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/zip/src/{deflate.js,inflate.js}
total-lines: 58 (31 deflate + 27 inflate)
ingest-cycle: 288
ingest-date: 2026-06-10
lane: chat
scope: full
parent: endo--packages-zip-src-deflate-and-inflate-pair--Web-Compression-Streams-API-five-step-async-chain-and-deflate-inflate-symmetric-pair-and-no-ts-check-correction
---

Both internal helpers are `async (..., ...) => { ... }` — async arrow functions, not async-named-function-declarations. **§the-async-arrow-IS-the-cluster-canonical-form-for-multi-step-async-chains**. The arrow form is terser; the function-declaration form would be `async function compress(...)` and add a few characters.

§the-arrow-form-IS-the-named-cluster-style — sibling-pattern to cycle 280's `writeZip = async (files) => ...`.
