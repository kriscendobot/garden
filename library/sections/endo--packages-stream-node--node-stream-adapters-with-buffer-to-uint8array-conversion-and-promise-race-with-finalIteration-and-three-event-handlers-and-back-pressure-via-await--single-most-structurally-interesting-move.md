---
title: Single most structurally interesting move
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

§Two-files-for-two-directions (reader.js + writer.js) + §Buffer-to-Uint8Array conversion via mapReader from @endo/stream + §readableObjectMode-and-readableEncoding-guards with named-error-messages + §Stream-must-have-return-and-throw (stricter than AsyncIterator) + §Promise.race-with-finalIteration in writer.next for concurrent-completion-sources + §three-Node-event-handlers (error / finish / close) with §sink-for-Node-14-unhandled-error-race-defense + §back-pressure-via-await-on-write.

§The-load-bearing-discipline: §adapt-Node.js-streams (which iterate Buffer values and aren't hardened) to §Endo's-async-iterable-streams (which expect Uint8Array and harden). §The-comment-names-the-rationale: "This module provided for sake of fewer head scratches. Node.js readable streams satisfy the signature of an async iterable iterator. They however iterate Node.js Buffer values and are not hardened, so this implementation compensates for both".

§Two-named-compensations: §Buffer-becomes-Uint8Array + §iterable-becomes-hardened-Stream.
