---
title: §readableObjectMode and §readableEncoding guards with §named-error-messages
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

```js
!input.readableObjectMode ||
  Fail`Cannot convert Node.js object mode Reader to AsyncIterator<Uint8Array>`;
input.readableEncoding === null ||
  Fail`Cannot convert Node.js Reader with readableEncoding ${q(
    input.readableEncoding,
  )} to a AsyncIterator<Uint8Array>`;
```

§Two-pre-condition-checks at the start of makeNodeReader. §The-error-messages-name-the-Node-API-shape that's incompatible (object-mode + encoding). §Q-template-quotes the value for safe interpolation.

§Borrowable-pattern: §pre-condition-checks-with-named-error-messages for §adapters-between-incompatible-shapes.

§Sibling-pattern to cycle 199 nat's §two-different-error-types (TypeError vs RangeError) — cycle 213 uses uniform `Fail` template but each error names §the-named-incompatibility.
