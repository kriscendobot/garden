---
source: packages/netstring/reader.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/blob/master/packages/netstring/reader.js
source_path: packages/netstring/reader.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Mathieu Hofman (prompted)
topics:
  - streams
  - patterns
  - captp
genre: §endo-source-comment-fragment
cycle: 177
lane: chat
status: current
title: §Zero-copy-fast-path
parent: endo--packages-netstring-reader-js--two-state-iterator-with-zero-copy-fast-path-and-allocate-on-multi-chunk
---

```js
if (buffer.length > remainingDataLength) {
  const remainingData = buffer.subarray(0, remainingDataLength);
  const data = dataBuffer
    ? (dataBuffer.set(remainingData, ...), dataBuffer)
    : remainingData;
  ...
  yield data;
}
```

§If-data-fits-in-current-chunk-no-allocation. §subarray-is-
zero-copy. §The-fast-path-pays-zero-byte-copy.

§Slow-path-allocates: §dataBuffer-pre-allocated-to-
remainingDataLength.

§Why-this-matters: §netstring-framing-is-the-hot-path on
the daemon socket; §zero-copy-decoding-keeps-latency-low.

§Allocation-elision-for-common-case (§cycle-169-atomics.js
sibling: §special-case-done-on-first-try uses the same
discipline at a different layer).
