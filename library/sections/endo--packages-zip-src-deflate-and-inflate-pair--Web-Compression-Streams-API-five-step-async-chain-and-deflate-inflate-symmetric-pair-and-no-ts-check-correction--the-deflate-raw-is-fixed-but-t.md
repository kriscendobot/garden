---
title: §the-`'deflate-raw'`-IS-fixed-but-the-internal-parameter-IS-the-future-extension-point (first-explicit-observation)
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

`compress` accepts `compressionMethodName` as a parameter; `deflate` fixes it to `'deflate-raw'`. **§the-internal-IS-the-future-multi-algorithm-API + the-external-IS-the-present-single-algorithm-API**. If the cluster later supports `'gzip'`, only the type union needs to widen, and a new `gzip = ...` wrapper added. The internal need not change.

§the-named-future-extension-shape IS encoded in the type system today. The type IS the bouncer: future additions are anticipated by the union shape.
