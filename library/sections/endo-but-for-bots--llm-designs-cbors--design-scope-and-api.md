---
title: Design — scope + API shape
source: designs/cbors.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 0a99c7bc4a83b61b0b488146e262de08a588a998
source_date: 2026-05-05
source_authors: [Kriscendo Bot]
ingested: 2026-05-14
ingested_by: scholar
topics: [streams, marshal]
status: current
notes: The "byte-string framing only" scope rule is the load-bearing limitation; lets the package stay small + auditable + free of full-CBOR-codec dependencies. A reader that sees an unexpected initial byte throws. The optional `tagged: true` writer option wraps frames in CBOR tag 24 (Encoded CBOR data item) — makes the wire self-describing to a generic packet analyzer.
---

> Abstract: **Scope**: byte-string framing only, just enough of RFC 8949 to read/write CBOR major-type-2 heads (optionally wrapped in tag 24, major type 6 argument 24). Rejects any other major type or tag. **API shape**: `makeCborsReader(input, {name?, maxMessageLength?})` takes an Iterable/AsyncIterable of `Uint8Array` and returns an `@endo/stream` Reader of `Uint8Array`. `makeCborsWriter(output, {chunked?, tagged?, name?})` takes an `@endo/stream` Writer of `Uint8Array` and returns the same shape. Both reader and writer carry **byte strings** at their boundaries. `tagged: true` requests tag-24 wrapping on output; the reader accepts both wrapped and unwrapped frames transparently.

## Design

### Scope

`@endo/cbors` is byte-string framing only. The package implements just enough of [RFC 8949](https://www.rfc-editor.org/rfc/rfc8949.html) to read and write the head bytes for a CBOR byte string (major type 2), optionally wrapped in CBOR tag 24 (Encoded CBOR data item, major type 6). It does not parse or emit any other CBOR type. A reader that encounters bytes whose initial byte is not a permitted byte-string head (or a permitted tag 24 wrapping a byte-string head) throws.

This narrow scope keeps the package small, auditable, and free of dependencies on a full CBOR codec.

### API shape

```js
// index.js
export { makeCborsReader } from './reader.js';
export { makeCborsWriter } from './writer.js';
```

```js
/**
 * @param {Iterable<Uint8Array> | AsyncIterable<Uint8Array>} input
 * @param {object} [opts]
 * @param {string} [opts.name]
 * @param {number} [opts.maxMessageLength]
 * @returns {import('@endo/stream').Reader<Uint8Array, undefined>}
 */
export const makeCborsReader = (input, opts) => { ... };
```

```js
/**
 * @param {import('@endo/stream').Writer<Uint8Array, undefined>} output
 * @param {object} [opts]
 * @param {boolean} [opts.chunked]
 * @param {boolean} [opts.tagged]
 * @param {string} [opts.name]
 * @returns {import('@endo/stream').Writer<Uint8Array, undefined>}
 */
export const makeCborsWriter = (output, opts) => { ... };
```

The `name` and `maxMessageLength` semantics are identical to `@endo/netstring`. Both reader and writer carry **byte strings** at their boundaries: the writer's `next` accepts a `Uint8Array`, and the reader yields a `Uint8Array`. The optional `tagged` option on the writer requests that each frame be wrapped in CBOR tag 24 (see Wire format). The reader accepts both wrapped and unwrapped frames transparently.

Source: [designs/cbors.md](https://github.com/endojs/endo-but-for-bots/blob/0a99c7bc4a83b61b0b488146e262de08a588a998/designs/cbors.md) at commit `0a99c7bc` on branch `llm`.
