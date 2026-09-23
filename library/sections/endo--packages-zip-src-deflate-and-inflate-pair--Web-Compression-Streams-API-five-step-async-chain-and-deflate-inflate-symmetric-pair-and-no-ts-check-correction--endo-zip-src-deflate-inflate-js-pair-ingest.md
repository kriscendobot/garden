---
title: "`@endo/zip/src/{deflate,inflate}.js` (pair ingest)"
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

Two near-symmetric files implementing the zip cluster's **compression and decompression** primitives via the **Web Compression Streams API** (`CompressionStream` + `DecompressionStream`). Each file follows an *internal-helper + external-default-export* shape: `compress`/`decompress` is the internal pump, `deflate`/`inflate` is the named external wrapper that fixes the algorithm to `'deflate-raw'`.
