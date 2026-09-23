---
title: Reader + writer behavior + harden discipline + dependencies + specimen
source: designs/cbors.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 0a99c7bc4a83b61b0b488146e262de08a588a998
source_date: 2026-05-05
source_authors: [Kriscendo Bot]
ingested: 2026-05-14
ingested_by: scholar
topics: [streams, hardened-javascript]
status: current
notes: maxMessageLength is enforced **before** allocation — the head's declared length is checked first; an oversize length throws without buffering. The chunked option lets the writer apply backpressure mid-frame by splitting an encoded frame across multiple output.next calls. Yielded Uint8Array payloads are NOT auto-hardened (callers may freeze, but the reader doesn't, to keep the hot path allocation-free).
---

> Abstract: **Reader**: a small state machine reading `Uint8Array` chunks. Per iteration: (1) wait for head bytes (1-9 for plain; 3-11 with tag-24 wrapper); (2) decode declared length; (3) wait for payload bytes; (4) yield as `Uint8Array`; (5) retain any unread suffix. Mid-frame stream end throws with stream `name` + byte offset (mirrors netstring's "Unexpected dangling message at offset"). `maxMessageLength` checked **before allocation** when the head declares an oversized payload. **Writer**: one CBOR byte-string frame per `next(bytes)`; with `tagged: true`, prepends the tag-24 wrapper. Shortest argument form (canonical RFC 8949 § 4.2 encoding). Two write modes: default (one `output.next` per frame); `chunked: true` (may split a frame across multiple `output.next` calls for mid-frame backpressure). `return()` / `throw()` propagate to the underlying byte writer. **Harden**: `makeCborsReader` / `makeCborsWriter` are hardened immediately after declaration; iterators are hardened; yielded payloads are returned as-is (caller may freeze; reader doesn't, for allocation-free hot path). **Dependencies**: `@endo/harden`, `@endo/init`, `@endo/promise-kit`, `@endo/stream` — same set as netstring, no CBOR-codec dependency, no peer-package dependency. The three framing packages (netstring / syrup-frame / cbors) are peers; head-parsing scaffolding is intentionally duplicated rather than extracted into a shared "framing primitives" package.

### Reader behavior

The reader consumes incoming `Uint8Array` chunks and feeds a small state machine that recognizes the CBOR byte-string head (with or without a leading tag-24 wrapper). On each iteration:

1. Wait until the head bytes are present (1 to 9 bytes for a plain byte-string head; 3 to 11 bytes when wrapped in tag 24).
2. Decode the declared length.
3. Wait until the declared payload bytes have arrived.
4. Yield the payload as a `Uint8Array`.
5. Retain any unread suffix as the prefix of the next frame.

If the input stream ends mid-frame (an incomplete head, a payload shorter than the declared length, an unterminated tag wrapper), the reader throws with a message that identifies the stream `name` and the byte offset where the truncated frame began. This mirrors `@endo/netstring`'s "Unexpected dangling message at offset" error.

The `maxMessageLength` cap is enforced *before* allocation: when the head declares a payload length greater than the cap, the reader throws without buffering the payload.

### Writer behavior

The writer accepts a `Uint8Array` per `next(bytes)` call and emits one CBOR byte-string frame per call. With `tagged: false` (the default), the frame is the plain byte-string head followed by the payload. With `tagged: true`, the frame is the tag-24 wrapper followed by the plain byte-string head followed by the payload.

The head uses the shortest argument form (the canonical RFC 8949 § 4.2 encoding for the length).

Writer mode follows the netstring template:

- Default (`chunked: false`): one `output.next` per frame.
- `chunked: true`: the writer may split the encoded bytes into multiple `output.next` calls so the underlying stream can apply backpressure mid-frame.

`return()` and `throw()` propagate to the underlying byte writer.

### Harden discipline

Every named export is hardened immediately after declaration: `harden(makeCborsReader)`, `harden(makeCborsWriter)`. The reader and writer return hardened async iterators. Yielded `Uint8Array` payloads are returned as-is (callers may freeze them if they wish; the reader does not, to keep the hot path allocation-free).

### Dependencies

```json
{
  "dependencies": {
    "@endo/harden": "workspace:^",
    "@endo/init": "workspace:^",
    "@endo/promise-kit": "workspace:^",
    "@endo/stream": "workspace:^"
  }
}
```

This is the same dependency set as `@endo/netstring`. The package does not depend on any CBOR codec library, on `@endo/netstring`, or on `@endo/syrup-frame`. The three framing packages are peers: taking a dependency on one of them does not entrain a dependency on any of the others. A small amount of head-parsing scaffolding is duplicated across the three rather than extracted into a shared "framing primitives" package, so that each can be adopted independently and audited on its own.

### Specimen example

```js
import { makeCborsReader, makeCborsWriter } from '@endo/cbors';
import { makePipe } from '@endo/stream';

const [input, output] = makePipe();
const writer = makeCborsWriter(output);
const reader = makeCborsReader(input);

const enc = new TextEncoder();
await writer.next(enc.encode('hello'));
await writer.next(enc.encode('A'));
await writer.return();

const dec = new TextDecoder();
for await (const bytes of reader) {
  console.error(dec.decode(bytes));
}
// hello
// A
```

Source: [designs/cbors.md](https://github.com/endojs/endo-but-for-bots/blob/0a99c7bc4a83b61b0b488146e262de08a588a998/designs/cbors.md) at commit `0a99c7bc` on branch `llm`.
