---
title: §the-asymmetric-line-count-with-symmetric-shape (first-explicit-observation)
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

Why is deflate.js 31 lines and inflate.js 27 lines if they're structurally symmetric? The difference IS 4 lines — accounted for by:

- The deflate Blob construction wraps the array argument across multiple lines (`[/** @type {BlobPart} */ (uncompressedBytes)]` on a separate line); the inflate version inlines it (`[/** @type {BlobPart} */ (compressedBytes)]` inside the Blob constructor call).
- The deflate JSDoc opens with `Compresses bytes with the DEFLATE-RAW algorithm.` (2 lines); the inflate JSDoc has only `@param` (1 line of JSDoc on the wrapper).

**§the-formatting-asymmetry-IS-the-cause-of-the-line-count-asymmetry-not-the-substance**. Both files do the same shape of work; the file lengths differ because of formatting choices around the Blob constructor and JSDoc verbosity. §the-line-count-IS-NOT-the-substance.
