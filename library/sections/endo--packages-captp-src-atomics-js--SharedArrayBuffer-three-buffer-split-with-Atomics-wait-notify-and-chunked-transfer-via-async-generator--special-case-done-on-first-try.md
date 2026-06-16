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
title: §Special-case-done-on-first-try
parent: endo--packages-captp-src-atomics-js--SharedArrayBuffer-three-buffer-split-with-Atomics-wait-notify-and-chunked-transfer-via-async-generator
---

```js
if (!encoded) {
  if (done) {
    // Special case: we are done on first try, so we don't
    // need to copy anything.
    encoded = databuf.subarray(0, datalen);
    break;
  }
  // Allocate our buffer for the remaining data.
  encoded = new Uint8Array(remaining);
}
```

§Allocation-elision-for-common-case. When the encoded JSON
fits entirely in databuf on the first try, the guest *uses
databuf as the encoded buffer* via subarray (zero copy).
§The-common-case-is-fast; §the-multi-chunk-case-allocates-
once.

§Subarray-aliases-not-copies: `databuf.subarray(0, datalen)`
shares memory with databuf. The guest §reads-it-immediately-
before-databuf-is-reused for the next transfer (which never
happens because we break).

§Optimization-by-shape-recognition: the common case
(message fits in one chunk) is detected and §special-cased
for §lower-allocation-pressure.
