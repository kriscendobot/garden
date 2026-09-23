---
title: §Promise.race-with-finalIteration in writer.next
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
async next(value) {
  !finalized || Fail`Cannot write into closed Node stream`;

  return Promise.race([
    finalIteration,
    new Promise((resolve, reject) => {
      if (
        !writer.write(value, err => {
          if (err) reject(err);
        })
      ) {
        writer.once('drain', () => {
          resolve(nonFinalIterationResult);
        });
      } else {
        resolve(nonFinalIterationResult);
      }
    }),
  ]);
}
```

§Three-completion-paths via Promise.race:
1. §finalIteration-completes (error / finish / close) — §the-stream-ended-mid-write.
2. §writer.write-returns-false → §wait-for-drain → resolve as non-final-iteration. §Back-pressure-via-drain-event.
3. §writer.write-returns-true → §resolve-immediately as non-final-iteration. §No-back-pressure-needed.

§The-callback-can-also-reject if `writer.write(value, callback)` reports an error.

§Borrowable-pattern: §Promise.race-with-finalIteration for §concurrent-completion-sources where §multiple-events-can-end-the-operation.

§Sibling-pattern to cycle 204 weblet-next's §Promise.race-between-transport-close-and-CapTP-close (both designs §use-Promise.race-for-multiple-completion-sources).
