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
---

# @endo/stream-node — §Node-stream-adapters with §Buffer-to-Uint8Array + §Promise.race-with-finalIteration + §three-event-handlers + §Node-14-race-defense

## Source

- `endo packages/stream-node/reader.js` — 54 lines (makeNodeReader)
- `endo packages/stream-node/writer.js` — 94 lines (makeNodeWriter)
- `endo packages/stream-node/index.js` — 2 lines (re-exports both)
- `endo packages/stream-node/README.md` — 1 line description
- Cycle 213 of `/loop resume the librarian work.` (chat-lane; alternates from cycle 212's designs-lane outliner-design-doc; §forty-seventh consecutive designs/chat alternation cycle 166-213)

§Twenty-fifth-member of §small-files-with-large-knowledge-density family.

## Single most structurally interesting move

§Two-files-for-two-directions (reader.js + writer.js) + §Buffer-to-Uint8Array conversion via mapReader from @endo/stream + §readableObjectMode-and-readableEncoding-guards with named-error-messages + §Stream-must-have-return-and-throw (stricter than AsyncIterator) + §Promise.race-with-finalIteration in writer.next for concurrent-completion-sources + §three-Node-event-handlers (error / finish / close) with §sink-for-Node-14-unhandled-error-race-defense + §back-pressure-via-await-on-write.

§The-load-bearing-discipline: §adapt-Node.js-streams (which iterate Buffer values and aren't hardened) to §Endo's-async-iterable-streams (which expect Uint8Array and harden). §The-comment-names-the-rationale: "This module provided for sake of fewer head scratches. Node.js readable streams satisfy the signature of an async iterable iterator. They however iterate Node.js Buffer values and are not hardened, so this implementation compensates for both".

§Two-named-compensations: §Buffer-becomes-Uint8Array + §iterable-becomes-hardened-Stream.

## §readableObjectMode and §readableEncoding guards with §named-error-messages

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

## §Stream-must-have-return-and-throw — stricter than AsyncIterator

> Adapt the AsyncIterator to the more strict interface of a Stream: must have return and throw methods.

§Stream-is-stricter-than-AsyncIterator. §JavaScript-AsyncIterator-allows-return-and-throw-to-be-optional; §Endo-Stream-requires-them.

§The-adapter-fills-in-the-gaps:

```js
const iterator = input[Symbol.asyncIterator]();
assert(iterator.return);

const reader = {
  async next() { return iterator.next(); },
  async return() {
    assert(iterator.return);
    return iterator.return();
  },
  async throw(error) {
    input.destroy(error);
    assert(iterator.return);
    return iterator.return();
  },
  [Symbol.asyncIterator]() { return reader; },
};
```

§iterator.return-preserved-via-assert — §the-Node-AsyncIterator-might-not-have-it; §the-adapter-asserts-and-uses-it.

§input.destroy(error)-on-throw — §propagates-the-Stream-error-to-the-underlying-Node-Reader.

§Self-referential-asyncIterator via `[Symbol.asyncIterator]() { return reader; }` — §the-reader-is-its-own-iterable. §Sibling-pattern to cycle 211 common's §makeIterator self-iterable pattern.

§Borrowable-pattern: §adapt-AsyncIterator-to-stricter-Stream-interface by §filling-in-missing-methods + §self-iterable-via-Symbol.iterator-returns-self.

## §mapReader Buffer-to-Uint8Array conversion

```js
return mapReader(reader, buffer => {
  assert(typeof buffer !== 'string');
  return new Uint8Array(buffer.buffer, buffer.byteOffset, buffer.length);
});
```

§Zero-copy-conversion using `new Uint8Array(buffer.buffer, buffer.byteOffset, buffer.length)` — §shares-the-underlying-ArrayBuffer.

§Assert-typeof-buffer-is-not-string — §defense-against-text-mode-Reader (already guarded above but defense-in-depth).

§Sibling-pattern to cycle 201 immutable-arraybuffer's §Uint8Array-handling and cycle 181 base64's §Reflect.apply-captured-at-module-load.

## §makeNodeWriter — §Promise.race-with-finalIteration + §back-pressure-via-await

```js
let finalized = false;
const finalIteration = new Promise((resolve, reject) => {
  const finalize = () => {
    cleanup();
    resolve(harden({ done: true, value: undefined }));
  };
  const error = err => {
    cleanup();
    reject(err);
  };
  const cleanup = () => {
    finalized = true;
    writer.off('error', error);
    writer.off('finish', finalize);
    writer.off('close', finalize);
    writer.on('error', sink);
  };
  writer.on('error', error);
  writer.on('finish', finalize);
  writer.on('close', finalize);
});
```

§Three-Node-event-handlers wired in one go: §error → reject; §finish → resolve as done; §close → resolve as done.

§Cleanup-after-first-fire: §writer.off all three; then §writer.on('error', sink) to defang any post-cleanup errors.

§Honest-comment on the redundant watch:

> Streams should emit either error or finish and then may emit close. So, watching close is redundant but makes us feel safer.

§Borrowable-pattern: §honest-comment-about-defensive-redundancy with §named-feeling-safer rationale.

## §sink-for-Node-14-unhandled-error-race-defense

```js
const sink = harden(() => {});

// ... after cleanup ...
writer.on('error', sink);
```

§The-comment:

> Prevent Node 14 from triggering a global unhandled error if we race

§Node-14-specific-defense — §post-cleanup-error-listener with §a-no-op-sink. §Named-Node-version-compat-hack.

§Sibling-pattern to cycle 199 nat's §Apps-Script-bigint-literal-workaround (named-runtime-compatibility-hack with explanatory comment).

§Borrowable-pattern: §named-runtime-version-compat-hack with §explanatory-comment + §no-op-sink-as-error-defense.

## §Promise.race-with-finalIteration in writer.next

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

## §back-pressure-via-await-on-write

> Back pressure emerges from awaiting on the promise returned by `next` before calling `next` again.

§The-back-pressure-discipline: §the-caller-must-await-each-next before calling next again. §If-the-Node-stream-is-applying-back-pressure (write returns false), §the-promise-doesn't-resolve-until-drain.

§Sibling-pattern to cycle 199 trampoline's §sync/async-two-color-sharing — both designs §use-promise-resolution-as-the-coordination-primitive.

## §pre-hardened-nonFinalIterationResult constant

```js
const nonFinalIterationResult = harden({ done: false, value: undefined });
```

§Single-pre-hardened-object returned by `writer.next` for every successful write. §No-allocation-per-call — §the-same-object-is-returned.

§Borrowable-pattern: §pre-hardened-constants-for-frequently-returned-values to §avoid-per-call-allocation.

§Sibling-pattern to cycle 197 panic's §lastResortError (also a pre-frozen exported constant for identity-equality checks).

## §Fail-on-write-after-finalized

```js
!finalized || Fail`Cannot write into closed Node stream`;
```

§Pre-condition-on-every-next-call. §If-the-stream-has-finalized (via error/finish/close), §reject-the-write.

§Sibling-pattern to cycle 199 memoize's §recursion-protection — both designs §reject-the-call-with-a-named-error when §the-state-is-incompatible.

## §Borrowable patterns (tier-1)

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

## §Synthesis-target

Slot machine library §game-event-stream-adapter:

- §Buffer-to-Uint8Array zero-copy conversion borrowable for any §adapter-between-Node-and-Endo-streams.
- §Promise.race-with-finalIteration borrowable for §game-event-streams that can end via multiple completion sources (player disconnect / game over / timeout).
- §Back-pressure-via-await-on-write borrowable for §rate-limiting-events-naturally via the iterator-protocol contract.
- §Three-event-handlers (error / finish / close) with §cleanup-after-first-fire borrowable for §robust-stream-finalization.
- §Pre-hardened-constants borrowable for §hot-path-iteration-results.
- §Self-iterable-via-Symbol.iterator-returns-self for §game-event-iterators.

## §Cycle 213 meta-observations

§The-forty-seventh-consecutive-designs/chat-alternation-cycle 166-213.

§Papers-lane-blocked 107+ consecutive cycles (since cycle ~106).

§Library-reaches-718-sections at cycle 213.

§Twenty-fifth-member of §small-files-with-large-knowledge-density family.

§Three-Node-version-compat-hacks now in library:
- Cycle 199 nat: §Apps-Script-bigint-literal-workaround (BigInt(0) not 0n).
- Cycle 205 evasive-transform: §Babel-traverse-default-import-workaround (`babelTraverse.default || babelTraverse`).
- Cycle 213 stream-node: §Node-14-unhandled-error-race-defense (`writer.on('error', sink)` after cleanup).

§Three-different-runtime-version-or-environment-compat-hacks at §three-different-layers.

§Promise.race-as-the-coordination-primitive observation:
- Cycle 204 weblet-next: §Promise.race between transport-close and CapTP-close.
- Cycle 213 stream-node: §Promise.race-with-finalIteration in writer.next.

§Two-different-uses-of-Promise.race for §multiple-completion-sources.
