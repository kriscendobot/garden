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
title: §The-implicit-state-machine (no two-state iterator)
parent: endo--packages-lp32-reader-writer-js--host-endian-length-prefix-framing-as-same-host-IPC-discipline
---

§Compare-to-cycle-177-netstring's explicit two-state iterator
(waiting-for-length / waiting-for-data, with `lengthBuffer
=== null` as the state discriminator). §lp32-needs-no-such-
state: the length is **always** at offset 0 of the buffer.

```js
let capacity = Math.max(4, initialCapacity);
let length = 0;
let array8 = new Uint8Array(capacity);
let data = new DataView(array8.buffer);
let offset = 0;
```

§Single-growing-buffer-with-DataView-view. §`length` is the
**fill level** (how many bytes are currently in the buffer);
§`offset` is the **cumulative byte position** in the input
stream (used only in the dangling-message error message).

§The-decode-loop is one pass:

```js
let drained = false;
while (!drained && length >= 4) {
  const messageLength = data.getUint32(0, hostIsLittleEndian);
  messageLength <= maxMessageLength || Fail`...`;
  const envelopeLength = 4 + messageLength;
  drained = envelopeLength > length;
  if (!drained) {
    // Must allocate to support concurrent reads.
    yield array8.slice(4, envelopeLength);
    // Shift
    array8.copyWithin(0, envelopeLength);
    length -= envelopeLength;
    offset += envelopeLength;
  }
}
```

§Drain-as-many-complete-messages-as-possible. §Each iteration:
read length at +0 → check bound → if we have envelope → yield
payload → shift buffer left → loop. §When we can't fit a full
envelope (`envelopeLength > length`), set `drained = true` and
fall back to reading more chunks.

§State-is-positional-not-flag-based. §No-`null`-vs-array
discriminator like netstring. §The-position-of-the-cursor
encodes everything: §if-length<4-we-need-more-bytes-for-the-
length-prefix-itself; §if-length>=4-but-envelopeLength>length-
we-need-more-bytes-for-the-payload.
