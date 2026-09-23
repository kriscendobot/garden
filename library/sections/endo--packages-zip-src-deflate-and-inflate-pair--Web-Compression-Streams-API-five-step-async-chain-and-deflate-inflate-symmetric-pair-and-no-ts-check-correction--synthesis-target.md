---
title: Synthesis target
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

Slot machine library `@game/replay/src/{compress,decompress}.js`: deflate-inflate pair using Web Compression Streams API; `'deflate-raw'` literal-union-type for future-extension; five-step async chain (Blob → Stream → Response → Blob → ArrayBuffer → Uint8Array); MIME type `'application/octet-stream'` discipline; inline `@type {BlobPart}` cast for Web Platform typing workaround; internal `compress`/`decompress` algorithm-parameterized + external `deflate`/`inflate` algorithm-fixed; one-line arrow wrapper; `export default` discipline; "tentatively just DEFLATE-RAW" named-tentativeness-marker; descriptive variable names with state-prefix (`uncompressed*` vs `compressed*`); seven named intermediate values for narrative clarity; `new Response(stream)` as stream-drain utility; three nested awaits decomposed for debugging.
