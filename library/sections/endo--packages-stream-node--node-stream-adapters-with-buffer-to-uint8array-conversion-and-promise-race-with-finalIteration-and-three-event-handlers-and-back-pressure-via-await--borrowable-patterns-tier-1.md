---
title: §Borrowable patterns (tier-1)
source: endo packages/stream-node/{reader.js,writer.js,index.js,README.md}
source-slug: endo--packages-stream-node
ingest-cycle: 213
ingest-date: 2026-06-06
lane: chat
authors: [Endo contributors]
related:
  - endo--packages-common (cycle 211; makeIterator/makeArrayIterator hardening-analog sibling)
  - endo--packages-trampoline-memoize-nat-trio (cycle 199; §sync/async-two-color-sharing-via-generator sibling at iterator-protocol layer)
  - endo--packages-marshal-src-marshal-justin-and-marshal-stringify-js (cycle 189; passable-leaf substrate which Uint8Array becomes via this adapter)
  - endo--packages-immutable-arraybuffer (cycle 201; by-copy bulk binary data — Uint8Array is the marshalled wire shape)
  - endo--packages-stream (the package this adapter targets; not yet ingested separately)
keywords:
  - Node-stream-adapters (makeNodeReader + makeNodeWriter)
  - readableObjectMode-and-readableEncoding guards
  - Buffer-to-Uint8Array conversion via mapReader
  - self-referential-asyncIterator (return this)
  - Stream-must-have-return-and-throw (stricter than AsyncIterator)
  - iterator.return preserved via assert
  - input.destroy(error) on throw
  - Promise.race-with-finalIteration in writer.next
  - three-Node-event-handlers (error / finish / close)
  - watching-close-is-redundant-but-makes-us-feel-safer comment
  - sink-for-Node-14-unhandled-error-race-defense (`writer.on('error', sink)` after cleanup)
  - back-pressure-via-await-on-write
  - writer.write-callback-and-drain-coordination
  - pre-hardened-nonFinalIterationResult-constant
  - Fail-on-write-after-finalized
  - honest-Streams-should-emit-either-error-or-finish-and-then-may-emit-close disclosure
  - hybrid-async-iterator-plus-generator (Writer modeled as)
  - cycle 213 chat-lane
  - twenty-fifth-member of small-files-with-large-knowledge-density family
  - forty-seventh consecutive designs/chat alternation cycle 166-213
parent: endo--packages-stream-node--node-stream-adapters-with-buffer-to-uint8array-conversion-and-promise-race-with-finalIteration-and-three-event-handlers-and-back-pressure-via-await
---

1. **§Adapter-between-incompatible-shapes** with §pre-condition-checks-with-named-error-messages.
2. **§Buffer-to-Uint8Array zero-copy conversion** via `new Uint8Array(buffer.buffer, buffer.byteOffset, buffer.length)`.
3. **§Stream-must-have-return-and-throw** (stricter than AsyncIterator) — §fill-in-missing-methods + §self-iterable-via-Symbol.iterator-returns-self.
4. **§Self-referential-asyncIterator** via `[Symbol.asyncIterator]() { return reader; }`.
5. **§iterator.return preserved via assert** before use.
6. **§input.destroy(error) on throw** to propagate Stream error to underlying Node Reader.
7. **§Promise.race-with-finalIteration** for §concurrent-completion-sources.
8. **§Three-Node-event-handlers** (error / finish / close) with §honest-comment-about-defensive-redundancy ("watching close is redundant but makes us feel safer").
9. **§Cleanup-after-first-fire** — writer.off all + writer.on('error', sink) to defang post-cleanup errors.
10. **§sink-for-Node-14-unhandled-error-race-defense** — §named-runtime-version-compat-hack with explanatory comment + no-op sink.
11. **§Back-pressure-via-await-on-write** — caller must await each `next` before calling again; promise doesn't resolve until drain if stream is back-pressuring.
12. **§writer.write-callback-and-drain-coordination** — `writer.write(value, callback)` returns false on back-pressure; listen for `drain` event.
13. **§Pre-hardened-constants-for-frequently-returned-values** (nonFinalIterationResult) to avoid per-call allocation.
14. **§Fail-on-write-after-finalized** — pre-condition rejects writes after stream has ended.
15. **§Hybrid-async-iterator-plus-generator** as named-Writer-shape (in writer.js comment).
