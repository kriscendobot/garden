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
title: §Allocate-on-multi-chunk
parent: endo--packages-netstring-reader-js--two-state-iterator-with-zero-copy-fast-path-and-allocate-on-multi-chunk
---

```js
} else if (buffer.length) {
  if (!dataBuffer && buffer.length === remainingDataLength) {
    dataBuffer = buffer;
  } else {
    dataBuffer = dataBuffer || new Uint8Array(remainingDataLength);
    dataBuffer.set(buffer, dataBuffer.length - remainingDataLength);
  }
  remainingDataLength -= buffer.length;
  buffer = buffer.subarray(buffer.length);
}
```

§Three-sub-cases:

1. **§First-chunk-fills-exactly**: assign `buffer`
   directly to `dataBuffer` (zero-copy, but commits to
   waiting for more).
2. **§First-chunk-partial**: allocate `dataBuffer` of
   `remainingDataLength`, copy `buffer` to start.
3. **§Subsequent-chunks**: copy into existing `dataBuffer`
   at the right offset.

§Allocate-once-per-message-not-per-chunk. §The-allocation-
is-amortized-across-chunks.

§Tail-call-by-buffer.subarray: §progress-is-made-by-
shrinking-buffer. §Loop-exits-when-buffer-empty.
