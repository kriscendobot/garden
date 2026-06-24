---
source: packages/captp/src/atomics.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/blob/master/packages/captp/src/atomics.js
source_path: packages/captp/src/atomics.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - captp
  - patterns
  - tooling
genre: §endo-source-comment-fragment
cycle: 169
lane: chat
status: current
title: §Chunked-transfer-by-buffer-size
parent: endo--packages-captp-src-atomics-js--SharedArrayBuffer-three-buffer-split-with-Atomics-wait-notify-and-chunked-transfer-via-async-generator
---

```js
const subenc = encoded.subarray(i, i + databuf.length);
databuf.set(subenc);
const remaining = BigInt(encoded.length - i);
lenbuf[0] = remaining;
i += subenc.length;
done = i >= encoded.length;
```

§Arbitrarily-large-JSON-message-split-into-databuf-sized-
chunks. §Send-remaining-byte-count-in-lenbuf — guest knows
how many bytes are still to come.

§Bigint-conversion-at-write: `BigInt(encoded.length - i)`.
§Number-conversion-at-read: `Number(lenbuf[0])` (in guest).
§Asymmetric-types-because-typed-arrays-are-typed.

§Decode-then-chunk: the encoded array is `te.encode(json)`
*once*; the chunks are §subarrays-not-new-allocations.
§Allocate-once-zero-copy-chunk.
