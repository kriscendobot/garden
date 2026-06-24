---
title: §Node-stream-adapters with §readableObjectMode-and-readableEncoding-guards + §Buffer-to-Uint8Array conversion via mapReader + §self-referential-asyncIterator (return-this) + §Stream-must-have-return-and-throw + §Promise.race-with-finalIteration in writer.next + §three-Node-event-handlers (error / finish / close) with §watching-close-is-redundant-but-makes-us-feel-safer comment + §sink-for-Node-14-unhandled-error-race-defense + §back-pressure-via-await-on-write + §honest-Streams-should-emit-either-error-or-finish-disclosure + §pre-hardened-nonFinalIterationResult-constant — @endo/stream-node
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
kind: index
section_count: 14
---

Sections:

- [Source](endo--packages-stream-node--node-stream-adapters-with-buffer-to-uint8array-conversion-and-promise-race-with-finalIteration-and-three-event-handlers-and-back-pressure-via-await--source.md)
- [Single most structurally interesting move](endo--packages-stream-node--node-stream-adapters-with-buffer-to-uint8array-conversion-and-promise-race-with-finalIteration-and-three-event-handlers-and-back-pressure-via-await--single-most-structurally-interesting-move.md)
- [§readableObjectMode and §readableEncoding guards with §named-error-messages](endo--packages-stream-node--node-stream-adapters-with-buffer-to-uint8array-conversion-and-promise-race-with-finalIteration-and-three-event-handlers-and-back-pressure-via-await--readableobjectmode-and-readabl.md)
- [§Stream-must-have-return-and-throw — stricter than AsyncIterator](endo--packages-stream-node--node-stream-adapters-with-buffer-to-uint8array-conversion-and-promise-race-with-finalIteration-and-three-event-handlers-and-back-pressure-via-await--stream-must-have-return-and-th.md)
- [§mapReader Buffer-to-Uint8Array conversion](endo--packages-stream-node--node-stream-adapters-with-buffer-to-uint8array-conversion-and-promise-race-with-finalIteration-and-three-event-handlers-and-back-pressure-via-await--mapreader-buffer-to-uint8array-conversion.md)
- [§makeNodeWriter — §Promise.race-with-finalIteration + §back-pressure-via-await](endo--packages-stream-node--node-stream-adapters-with-buffer-to-uint8array-conversion-and-promise-race-with-finalIteration-and-three-event-handlers-and-back-pressure-via-await--makenodewriter-promise-race-wi.md)
- [§sink-for-Node-14-unhandled-error-race-defense](endo--packages-stream-node--node-stream-adapters-with-buffer-to-uint8array-conversion-and-promise-race-with-finalIteration-and-three-event-handlers-and-back-pressure-via-await--sink-for-node-14-unhandled-error-race-defense.md)
- [§Promise.race-with-finalIteration in writer.next](endo--packages-stream-node--node-stream-adapters-with-buffer-to-uint8array-conversion-and-promise-race-with-finalIteration-and-three-event-handlers-and-back-pressure-via-await--promise-race-with-finaliteration-in-writer-next.md)
- [§back-pressure-via-await-on-write](endo--packages-stream-node--node-stream-adapters-with-buffer-to-uint8array-conversion-and-promise-race-with-finalIteration-and-three-event-handlers-and-back-pressure-via-await--back-pressure-via-await-on-write.md)
- [§pre-hardened-nonFinalIterationResult constant](endo--packages-stream-node--node-stream-adapters-with-buffer-to-uint8array-conversion-and-promise-race-with-finalIteration-and-three-event-handlers-and-back-pressure-via-await--pre-hardened-nonfinaliterationresult-constant.md)
- [§Fail-on-write-after-finalized](endo--packages-stream-node--node-stream-adapters-with-buffer-to-uint8array-conversion-and-promise-race-with-finalIteration-and-three-event-handlers-and-back-pressure-via-await--fail-on-write-after-finalized.md)
- [§Borrowable patterns (tier-1)](endo--packages-stream-node--node-stream-adapters-with-buffer-to-uint8array-conversion-and-promise-race-with-finalIteration-and-three-event-handlers-and-back-pressure-via-await--borrowable-patterns-tier-1.md)
- [§Synthesis-target](endo--packages-stream-node--node-stream-adapters-with-buffer-to-uint8array-conversion-and-promise-race-with-finalIteration-and-three-event-handlers-and-back-pressure-via-await--synthesis-target.md)
- [§Cycle 213 meta-observations](endo--packages-stream-node--node-stream-adapters-with-buffer-to-uint8array-conversion-and-promise-race-with-finalIteration-and-three-event-handlers-and-back-pressure-via-await--cycle-213-meta-observations.md)
