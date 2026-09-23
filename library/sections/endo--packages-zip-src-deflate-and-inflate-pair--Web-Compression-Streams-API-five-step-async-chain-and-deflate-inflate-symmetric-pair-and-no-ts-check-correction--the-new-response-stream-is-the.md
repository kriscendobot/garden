---
title: §the-`new Response(stream)` IS the named way to drain a stream into bytes (first-explicit-observation)
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

A `Response` constructed from a `ReadableStream` lets you call `.blob()`, `.arrayBuffer()`, `.text()`, `.json()` on it — **§the-Response-IS-the-named-stream-drain-utility**. This is a Web Platform idiom: instead of writing a loop that reads chunks and accumulates them, you wrap the stream in a Response and let the Response's built-in methods do the accumulation.

§the-Response-IS-NOT-just-for-HTTP — even though `Response` is named after HTTP responses, it serves as a *general-purpose stream-to-bytes adapter*. **§the-API-shape-IS-reused-beyond-its-original-purpose** — a named Web Platform pattern.
