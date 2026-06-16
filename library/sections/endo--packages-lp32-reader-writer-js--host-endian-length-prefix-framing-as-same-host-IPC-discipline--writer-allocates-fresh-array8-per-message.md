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
title: §Writer-allocates-fresh-array8-per-message
parent: endo--packages-lp32-reader-writer-js--host-endian-length-prefix-framing-as-same-host-IPC-discipline
---

```js
async next(message) {
  message.byteLength <= maxMessageLength || Fail`...`;
  const array8 = new Uint8Array(4 + message.byteLength);
  const data = new DataView(array8.buffer);
  data.setUint32(0, message.byteLength, hostIsLittleEndian);
  array8.set(message, 4);
  return output.next(array8);
},
```

§Per-message-allocation-on-the-write-side. §Each-call-to-`next`
allocates a fresh `Uint8Array(4 + N)`, writes the length
prefix, copies the payload, and hands it to the downstream
writer.

§Why-not-write-the-length-and-payload-as-two-separate-`next`-
calls? §Because-async-iterators-don't-guarantee-atomicity
between successive `next` calls. §If-two-concurrent-callers
each called `writer.next(message)`, their length prefixes and
payloads could interleave. §Single-`next`-call-with-prefixed-
payload-is-atomic by the underlying writer's contract.

§Cycle-171-stream/index.js documented §symmetric-stream-
interface; §lp32-writer-respects-the-Writer<Uint8Array>-
contract: one `next` call equals one downstream byte buffer.
