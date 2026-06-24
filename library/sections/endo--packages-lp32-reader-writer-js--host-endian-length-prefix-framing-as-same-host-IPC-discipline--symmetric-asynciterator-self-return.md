---
source: packages/lp32/{reader,writer}.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/tree/master/packages/lp32
source_path: packages/lp32/reader.js, packages/lp32/writer.js, packages/lp32/src/host-endian.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - streams
  - captp
genre: §endo-source-comment-fragment
cycle: 179
lane: chat
status: current
title: §Symmetric-asyncIterator-self-return
parent: endo--packages-lp32-reader-writer-js--host-endian-length-prefix-framing-as-same-host-IPC-discipline
---

```js
[Symbol.asyncIterator]() {
  return writer;
},
```

§The-writer-is-its-own-asyncIterator. §`for await (const x of writer)`-
would-call-next-without-arguments which would fail; but a
write-side iterator isn't meant to be iterated. §This-
declaration-is-here-so-that-the-writer-can-be-passed-anywhere-
that-expects-an-AsyncIterable<T,R,N>-with-N=Uint8Array.

§Cycle-171-stream/index.js documented the asymmetry: readers
yield (no `next(arg)`); writers consume (`next(arg)` is the
useful direction). §The-`[Symbol.asyncIterator]`-self-return
is the §type-compatibility-handshake — it makes a `Writer` an
`AsyncIterableIterator` even though one direction of the
duality is unused.
