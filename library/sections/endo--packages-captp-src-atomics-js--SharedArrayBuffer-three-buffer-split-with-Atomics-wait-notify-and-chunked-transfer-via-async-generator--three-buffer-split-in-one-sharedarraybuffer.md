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
title: §Three-buffer-split-in-one-SharedArrayBuffer
parent: endo--packages-captp-src-atomics-js--SharedArrayBuffer-three-buffer-split-with-Atomics-wait-notify-and-chunked-transfer-via-async-generator
---

```js
const splitTransferBuffer = transferBuffer => {
  const lenbuf = new BigUint64Array(transferBuffer, 0, 1);
  const statusbuf = new Int32Array(transferBuffer, lenbuf.byteLength, 1);
  const databuf = new Uint8Array(transferBuffer, overheadLength);
  return harden({ statusbuf, lenbuf, databuf });
};
```

§Single-allocation-three-views over one SharedArrayBuffer:

| View | Type | Size | Purpose |
|------|------|------|---------|
| `lenbuf` | `BigUint64Array` | 8 bytes | Remaining-data length (64-bit; can address up to 2^64 bytes) |
| `statusbuf` | `Int32Array` | 4 bytes | Status flags (Atomics-compatible) |
| `databuf` | `Uint8Array` | rest | Payload chunk |

§Why-Int32Array-for-status — cited from MDN in the comment:

> *The documentation says that this needs to be an Int32Array
> for use with Atomics.notify:
> https://developer.mozilla.org/en-US/docs/Web/JavaScript/
> Reference/Global_Objects/Atomics/notify#syntax*

§Standard-API-constraint-acknowledged-in-comment.
§Atomics.notify-requires-Int32Array (the §32-bit-atomic-
integer is the canonical wake-target). §BigUint64Array-can't-
be-used-here even though it would express the value more
naturally.

§Why-BigUint64Array-for-length: §message-can-exceed-32-bits
in size. §Future-proofing-via-bigint avoids the §4GiB-cap.
§Encoded-as-bigint at write site, §converted-to-Number on
read.

§TRANSFER_OVERHEAD_LENGTH = 12 bytes (8 + 4). §Const-derived-
from-other-consts (`BigUint64Array.BYTES_PER_ELEMENT +
Int32Array.BYTES_PER_ELEMENT`) — §self-documenting-arithmetic.
