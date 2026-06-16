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
title: §Single-growing-buffer-with-copyWithin-shift
parent: endo--packages-lp32-reader-writer-js--host-endian-length-prefix-framing-as-same-host-IPC-discipline
---

§The-buffer-grows-but-never-shrinks. §Compare-to-cycle-177-
netstring which uses two buffers (`lengthBuffer` array of
digits + `dataBuffer` Uint8Array).

```js
if (length + chunk.byteLength >= capacity) {
  while (length + chunk.byteLength >= capacity) {
    capacity *= 2;
  }
  const replacement = new Uint8Array(capacity);
  replacement.set(array8, 0);
  array8 = replacement;
  data = new DataView(array8.buffer);
}
array8.set(chunk, length);
length += chunk.byteLength;
```

§Doubling-growth-strategy. §Amortized-O(1)-append. §The-
DataView-must-be-replaced-when-the-underlying-buffer-changes
(DataViews are bound to ArrayBuffers, not to Uint8Arrays).

§After-yielding-a-message: §shift-the-remainder-to-the-front:

```js
array8.copyWithin(0, envelopeLength);
length -= envelopeLength;
```

§`copyWithin(0, envelopeLength)` shifts bytes from
`[envelopeLength, length)` to `[0, length - envelopeLength)`
**in place**. §No-second-allocation. §The-tail-of-the-buffer-
(beyond-the-new-length) is left dirty but unreachable through
`length`.

§Compare-to-cycle-177-netstring: netstring's dataBuffer is
allocated fresh per message and disposed after yield. §lp32-
keeps-one-buffer-for-the-lifetime-of-the-stream and reuses
it. §Tradeoff: §lp32-uses-less-allocation-pressure-but-cannot-
shrink-after-a-large-message; §netstring-can-have-arbitrarily-
small-resident-memory-but-allocates-per-message.
