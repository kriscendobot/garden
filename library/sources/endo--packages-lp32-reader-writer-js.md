---
title: '@endo/lp32: reader.js, writer.js, src/host-endian.js'
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/tree/master/packages/lp32
source_paths:
  - packages/lp32/reader.js
  - packages/lp32/writer.js
  - packages/lp32/src/host-endian.js
authors:
  - Kris Kowal (prompted)
ingested: 2026-06-03
ingested_by: scholar
topics:
  - streams
  - captp
sections:
  - endo--packages-lp32-reader-writer-js--host-endian-length-prefix-framing-as-same-host-IPC-discipline.md
genre: §endo-source-comment-fragment
cycle: 179
lane: chat
---

# @endo/lp32: length-prefixed binary message framing (host byte order)

## Files

| File | Lines | Role |
|------|-------|------|
| `packages/lp32/reader.js`            | 82 | Async iterator: chunks → messages |
| `packages/lp32/writer.js`            | 49 | Writer: messages → chunks |
| `packages/lp32/src/host-endian.js`   |  9 | Module-load endianness probe |
| `packages/lp32/index.js`             |  2 | Re-export barrel |
| `packages/lp32/types.d.ts`           |  3 | Type re-exports |

## §Abstract

`@endo/lp32` implements the **length-prefixed framing protocol
used by WebExtension Native Messaging**: each message is
encoded as `[length:uint32-host-byte-order][payload]`, with a
1 MiB default ceiling matching Chrome/Firefox's spec.

The reader is an async generator that maintains a single
growing `Uint8Array` buffer (doubling-growth strategy). On
each input chunk it appends to the buffer, then drains as
many complete envelopes as fit. Each yielded message is a
**copy** via `array8.slice(4, envelopeLength)` with the
explicit comment "Must allocate to support concurrent reads"
— callers may hold yielded messages while the decoder
continues writing to its buffer. The remainder is shifted
forward with `array8.copyWithin(0, envelopeLength)`.

The writer allocates one fresh `Uint8Array(4 + N)` per
message, writes the length prefix at offset 0, copies the
payload starting at offset 4, and hands the whole envelope
to the downstream writer as one atomic `next` call.

`host-endian.js` runs a one-shot probe at module-load time
(`new Uint16Array(Uint8Array([1,0]).buffer)[0] === 1`) and
exports the result as a constant. Both reader and writer
pass this constant to every `DataView.getUint32` /
`setUint32` call — DataView's default is network byte order,
which would mismatch the WebExtension spec.

## §Provenance and dependencies

- §Built-on `@endo/stream` (cycle 171: §symmetric-stream-
  interface) — both reader and writer implement
  `Reader<Uint8Array, void>` / `Writer<Uint8Array, undefined>`.
- §Built-on `@endo/harden` (cycle 175: §race-to-install-harden)
  — every factory and resulting iterator is hardened.
- §Built-on `@endo/errors` for `Fail` template and `q` quoting
  in the diagnostic messages.
- §Spec-source: Mozilla's WebExtension Native Messaging docs
  ([linked in the README](https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/Native_messaging)).

## §Related sources in the library

- §Cycle 177 (`packages/netstring/reader.js`) — the sibling
  encoding using ASCII-decimal length prefix + colon + data +
  comma. Endian-free; self-describing on wire; two-state
  iterator with zero-copy fast-path. §Compared-section-by-
  section in this cycle's section file.
- §Cycle 171 (`packages/stream/index.js`) — the §symmetric-
  stream-interface that both lp32 and netstring implement.
- §Cycle 167 (`packages/where/index.js`) — names netstring-
  framed-CapTP as the daemon's CLI socket protocol; lp32 is
  the parallel choice for WebExtension deployment.
- §Cycle 175 (`packages/harden/make-selector.js`) — the
  §race-to-install-harden discipline that lp32's `harden`
  wrappers consume.
- §Cycle 141 (`daemon-cas-management.md`) — uses netstring
  for envelope-bus framing; lp32 is the alternative for
  same-host stdio IPC where the host protocol mandates it.
- §Cycle 176 (`daemon-endor-architecture.md`) — mentions
  WebExtension as one of the daemon's potential hosts; lp32
  is the framing layer that makes that deployment possible.
- §Cycle 174 (`gateway-package.md`) — names multiple wire
  framings as a forward-compatibility hedge; lp32 and
  netstring are the two already in-tree.

## §Comment fragments worth preserving

```js
// DataView does not default to host byte order like TypedArrays, so we must
// pass an explicit endianness argument.
```

§Justifies-the-existence-of-host-endian-js. §Without-the-
DataView-quirk-typed-arrays-could-have-been-used-directly.

```js
// Must allocate to support concurrent reads.
yield array8.slice(4, envelopeLength);
```

§The-key-correctness-comment. §slice-not-subarray-because-
the-caller-may-hold-the-yielded-message-while-the-decoder-
keeps-writing-to-array8.

```js
// Shift
array8.copyWithin(0, envelopeLength);
```

§In-place-buffer-compaction. §Single-buffer-strategy-distinct-
from-cycle-177-netstring's-two-buffer-pattern.
