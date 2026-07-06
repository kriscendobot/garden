---
created: 2026-06-17
updated: 2026-07-06
author: researcher
status: draft
---

# Concept: exo-stream

`@endo/exo-stream` is the CapTP streaming package that replaces the older
`reader-ref.js` / `ref-reader.js` pattern in `@endo/daemon`. It bridges
local JavaScript async iterators to remote-passable stream objects using a
bidirectional promise chain protocol (synchronize chain and acknowledge chain).
The package lives at `packages/exo-stream/` and is already present on the
`llm` branch of `endojs/endo-but-for-bots` (added in commit `3e240f9ff`
from the `kriskowal-exo-stream` sidetrack).

## Four public conversion functions

| Function | Direction | Bytes? | Side |
|---|---|---|---|
| `readerFromIterator` | local iter → `PassableReader` | no | responder / producer |
| `bytesReaderFromIterator` | local `Uint8Array` iter → `PassableBytesReader` | yes (base64) | responder / producer |
| `writerFromIterator` | local iter → `PassableWriter` | no | responder / consumer |
| `bytesWriterFromIterator` | local `Uint8Array` iter → `PassableBytesWriter` | yes (base64) | responder / consumer |
| `iterateReader` | `PassableReader` ref → local iter | no | initiator / consumer |
| `iterateBytesReader` | `PassableBytesReader` ref → local `Uint8Array` iter | yes (base64) | initiator / consumer |
| `iterateWriter` | `PassableWriter` ref → local iter | no | initiator / producer |
| `iterateBytesWriter` | `PassableBytesWriter` ref → local `Uint8Array` iter | yes (base64) | initiator / producer |

Low-level pumps (`makeReaderPump`, `makeWriterPump`) and utilities
(`asyncIterate`, `type-guards.js`) are also exported for custom Exo
construction.

## What this replaces

- `makeIteratorRef` (from `packages/daemon/src/reader-ref.js`) → `readerFromIterator`
- `makeReaderRef` (from `packages/daemon/src/reader-ref.js`) → `bytesReaderFromIterator`
- `makeRefIterator` (from `packages/daemon/src/ref-reader.js`) → `iterateReader`
- `makeRefReader` (from `packages/daemon/src/ref-reader.js`) → `iterateBytesReader`

The `streamBase64()` no-arg method on `EndoReadable` (old protocol) becomes a
`streamBase64(synPromise)` method that receives the head of the synchronize
chain (new protocol). Callers use `iterateBytesReader(readable)` instead of
`makeRefReader(E(readable).streamBase64())`.

## Relevant upstream material

- Upstream PR: `endojs/endo#3036` (head `ce7293d6`).
- Status on `llm` branch: `@endo/exo-stream` package is present and nearly
  identical to upstream; the daemon / CLI callers are NOT yet migrated
  (they still use the old `reader-ref.js` / `ref-reader.js` API).
  Upstream PR #3036 is the migration guide.

## Gap: no non-backpressured push side (design pending)

Every export is pull-based and backpressured by design; nothing covers an
imperative fire-and-forget `push` from an event-driven producer. Composing
`@endo/stream` `makeQueue` with `readerFromIterator` does not close the gap:
`makeReaderPump`'s loop is strictly sequential (await a syn node, then await
`iterator.next()`), so while parked on an idle producer it cannot observe the
initiator's early close, deferring `iterator.return()` (and any abort hook)
until the producer's next value. Design to add a push-fed
`makeBufferedReader` export, consolidating the twin `buffered-channel.js`
copies in `packages/floot` and `packages/claude-sandbox`:
`designs/buffered-channel-exo-stream-consolidation.md` on the `llm` branch
(endojs/endo-but-for-bots PR #613, dispatched from PR #486 review).

## See also

- `[[promise-pipelining]]` — the bidirectional promise chain protocol that powers the stream transport.
- `[[captp-bounded-transient-pin]]` — related CapTP flow-control patterns.
