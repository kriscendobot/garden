---
title: §the-three-nested-awaits-as-named-completion-discipline (first-explicit-observation)
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

```javascript
const compressedBlob = await compressedResponse.blob();
const compressedArrayBuffer = await compressedBlob.arrayBuffer();
const bytes = new Uint8Array(compressedArrayBuffer);
```

**Three separate awaits in three statements**, NOT one chained await. **§the-named-decomposed-await-shape**: each statement names its intermediate value; the reader can pause and inspect at any line. Compare the alternative `const bytes = new Uint8Array(await (await compressedResponse.blob()).arrayBuffer())` — denser but harder to read.

§named-intermediate-await-results-IS-the-debug-friendly-discipline. The code IS optimized for *future-reader debuggability* over *current-writer terseness*.
