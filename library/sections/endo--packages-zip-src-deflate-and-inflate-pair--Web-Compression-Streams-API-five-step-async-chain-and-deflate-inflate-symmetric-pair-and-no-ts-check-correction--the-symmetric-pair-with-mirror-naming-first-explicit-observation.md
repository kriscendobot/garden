---
title: §the-symmetric-pair-with-mirror-naming (first-explicit-observation)
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

| Aspect | deflate.js | inflate.js |
|---|---|---|
| Internal helper | `compress(uncompressedBytes, compressionMethodName)` | `decompress(compressedBytes, compressionMethodName)` |
| External wrapper | `deflate` | `inflate` |
| Lines | 31 | 27 |
| Web API | `CompressionStream` | `DecompressionStream` |
| `// @ts-check` | absent | absent |
| Default export | `deflate` | `inflate` |
| Variable name pattern | `uncompressed*` prefix | `compressed*` + `decompressed*` prefix |

**§named-variable-prefix-pairs as state-tracking discipline**: in compress, the variables flow `uncompressedBlob → compressionStream → compressedStream → compressedResponse → compressedBlob → compressedArrayBuffer → bytes`. The prefix `uncompressed` vs `compressed` IS a named marker that **encodes the data's current state in the variable name**. This is **§the-variable-prefix-IS-the-state-marker** — at any point in the function the reader can see which side of the compression boundary each value sits on.

§the-state-tracking-via-prefix IS sibling-pattern to Hungarian notation but used for *data-flow state* not *type*. The compress function has 7 distinct names that *narrate* the conversion.
