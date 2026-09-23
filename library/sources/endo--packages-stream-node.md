---
title: "@endo/stream-node — Node.js Reader/Writer adapters to Endo Stream<Uint8Array>"
source-slug: endo--packages-stream-node
url: https://github.com/endojs/endo/tree/master/packages/stream-node
authors: [Endo contributors]
repo: endojs/endo
path:
  - packages/stream-node/reader.js
  - packages/stream-node/writer.js
  - packages/stream-node/index.js
  - packages/stream-node/README.md
total-lines: 150 source (54 reader + 94 writer + 2 index) + 1-line README
license: Apache-2.0
ingest-cycle: 213
ingest-date: 2026-06-06
lane: chat
status: current
---

# @endo/stream-node

§Adapters from Node.js Readable/Writable streams to Endo's `Stream<Uint8Array>`. §The-load-bearing-discipline: §adapt-Node.js-streams (which iterate Buffer values and aren't hardened) to §Endo's-async-iterable-streams (which expect Uint8Array and harden).

## Two named compensations

> Node.js readable streams satisfy the signature of an async iterable iterator. They however iterate Node.js Buffer values and are not hardened, so this implementation compensates for both.

§Buffer-becomes-Uint8Array + §iterable-becomes-hardened-Stream.

## Key design moves

- **§Two-files-for-two-directions** (reader.js + writer.js).
- **§readableObjectMode-and-readableEncoding guards** with named-error-messages.
- **§Buffer-to-Uint8Array zero-copy conversion** via `new Uint8Array(buffer.buffer, buffer.byteOffset, buffer.length)`.
- **§Stream-must-have-return-and-throw** (stricter than AsyncIterator) — adapter fills in the missing methods.
- **§iterator.return preserved via assert** before use.
- **§input.destroy(error) on throw** to propagate Stream error to underlying Node Reader.
- **§Self-referential-asyncIterator** via `[Symbol.asyncIterator]() { return reader; }` (sibling to cycle 211 common's makeIterator).
- **§Promise.race-with-finalIteration** in writer.next — three completion paths (finalIteration completes / write returns false → wait for drain / write returns true → resolve immediately).
- **§Three-Node-event-handlers** (error → reject, finish → resolve, close → resolve) with §honest-comment-about-defensive-redundancy ("watching close is redundant but makes us feel safer").
- **§Cleanup-after-first-fire** — writer.off all three + writer.on('error', sink) to defang post-cleanup errors.
- **§sink-for-Node-14-unhandled-error-race-defense** — `const sink = harden(() => {})` listener after cleanup; §named-Node-version-compat-hack with explanatory comment.
- **§Back-pressure-via-await-on-write** — caller must await each `next` before calling again; promise doesn't resolve until drain if back-pressuring.
- **§writer.write-callback-and-drain-coordination** — write returns false on back-pressure; listen for `drain` event.
- **§Pre-hardened-nonFinalIterationResult-constant** — single hardened `{done: false, value: undefined}` returned by every successful write; avoids per-call allocation.
- **§Fail-on-write-after-finalized** — pre-condition rejects writes after stream has ended.
- **§Hybrid-async-iterator-plus-generator** as named Writer shape (in writer.js comment).

## The Promise.race shape

```js
return Promise.race([
  finalIteration,  // error / finish / close
  new Promise((resolve, reject) => {
    if (!writer.write(value, err => { if (err) reject(err); })) {
      writer.once('drain', () => resolve(nonFinalIterationResult));
    } else {
      resolve(nonFinalIterationResult);
    }
  }),
]);
```

§Multiple-completion-sources via Promise.race. §finalIteration-or-write-or-drain — whichever resolves first wins.

## Node-version-compat hack — sink for Node-14-error-race

```js
const sink = harden(() => {});
// after cleanup:
writer.on('error', sink);
```

> Prevent Node 14 from triggering a global unhandled error if we race

§Named-Node-version-compat-hack — §post-cleanup-error-listener with a §no-op-sink. Three-different-runtime-version-or-environment-compat-hacks now in library: cycle 199 nat (Apps-Script-bigint-literal-workaround) + cycle 205 evasive-transform (Babel-traverse-default-import-workaround) + cycle 213 stream-node (Node-14-unhandled-error-race-defense).

## Ingest scope

Cycle 213 (chat-lane): full ingest of reader.js + writer.js + index.js + README. One section.

## Related material in the library

- **`@endo/stream`** (target API; not yet ingested separately): the package these adapters target.
- **cycle 211 endo--packages-common**: §makeIterator/makeArrayIterator hardening-analog sibling — both designs §provide-harden-friendly-iterator-shapes; cycle 213 adapts existing Node iterators; cycle 211 makes new ones from scratch.
- **cycle 199 trampoline-memoize-nat-trio**: §sync/async-two-color-sharing-via-generator sibling at iterator-protocol layer.
- **cycle 201 immutable-arraybuffer**: §by-copy-network-protocol kinship — Uint8Array is the marshalled wire shape for bulk binary data.
- **cycle 189 marshal-justin + marshal-stringify**: §passable-leaf substrate which Uint8Array becomes via this adapter.
- **cycle 204 weblet-next**: §Promise.race between transport-close and CapTP-close sibling — both designs use §Promise.race-for-multiple-completion-sources.
- **cycle 199 nat**: §Apps-Script-bigint-literal-workaround sibling — three named runtime-version-or-environment-compat-hacks now in library.
- **cycle 205 evasive-transform**: §Babel-traverse-default-import-workaround sibling.
- **cycle 197 panic**: §lastResortError pre-frozen exported constant sibling for §pre-hardened-constants-for-frequently-returned-values.
