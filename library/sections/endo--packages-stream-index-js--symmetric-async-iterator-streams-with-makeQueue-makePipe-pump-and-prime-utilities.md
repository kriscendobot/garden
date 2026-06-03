---
source: packages/stream/index.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/blob/master/packages/stream/index.js
source_path: packages/stream/index.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - streams
  - patterns
  - captp
genre: §endo-source-comment-fragment
cycle: 171
lane: chat
status: current
---

# Symmetric async-iterator streams with makeQueue makePipe pump and prime utilities

> §Chat-lane after cycle 170's designs-lane. §Endo-source-
> comment-fragment genre. §The-canonical-async-stream-
> substrate referenced by cycle 137's daemon-message-
> streaming, cycle 163's ocap-kernel glossary, and CapTP's
> wire transport.

`packages/stream/index.js` (247 lines) is the **§Endo-async-
stream-substrate**. Exports seven utilities: `makeQueue`,
`makeStream`, `makePipe`, `pump`, `prime`, `mapReader`,
`mapWriter`. The single most structurally interesting move
is the **§symmetric-stream-interface** where Reader and
Writer differ only by convention, not by structure.

## §Why-this-file-exists (the opening comment)

> *`makeQueue`, `makeStream`, and `makePipe` are utilities
> for creating async iterator "streams". A Stream is
> compatible with AsyncIterator and Generator but differ in
> that every method and argument of both is required. For
> example, streams always have `return` and `throw` for
> closing the write side. The `Stream` interface is
> symmetric, but a stream that sends data and receives
> undefined is conventionally a `Writer` whereas a stream
> that receives data and sends undefined is conventionally
> a `Reader`.*

§Compatible-with-AsyncIterator-and-Generator-but-stricter.
§Every-method-and-argument-required. §Standard-iteration-
protocols-have-optional-methods (`return`, `throw` are
optional in vanilla iterators); §streams-require-all-three.

§The-symmetric-stream-interface: §Reader-vs-Writer-by-
convention-not-structure. The same object shape serves both
ends; the §convention names §sends-data-and-receives-
undefined as Writer; §receives-data-and-sends-undefined as
Reader.

§This-symmetry-is-load-bearing: §makePipe creates two
streams from cross-wired queues; either end can be called
Reader or Writer depending on use.

## §makeQueue with promise-chain cons-cells

```js
export const makeQueue = () => {
  let { promise: tailPromise, resolve: tailResolve } = makePromiseKit();
  return {
    put(value) {
      const { resolve, promise } = makePromiseKit();
      tailResolve(freeze({ value, promise }));
      tailResolve = resolve;
    },
    get() {
      const promise = tailPromise.then(next => next.value);
      tailPromise = tailPromise.then(next => next.promise);
      return harden(promise);
    },
  };
};
```

§The-functional-async-queue idiom. The queue is a chain of
§{value, promise} cons-cells where each promise resolves to
the §next-cell.

§Producer-makes-cons-cell: `tailResolve(freeze({value,
promise}))` extends the chain; updates tailResolve to the
new cell's resolve.

§Consumer-walks-chain: `tailPromise.then(next => next.
value)` extracts the value; `tailPromise.then(next => next.
promise)` advances to the next cell.

§Promise-as-pointer: each `.promise` in a cell is the §lazy-
next-pointer. §Resolution-is-the-write.

§No-bounded-buffer: arbitrarily many puts can race ahead of
gets; the chain just gets longer. §Producer-never-blocks.

§Cycle-152's-memo-race had a similar §functional-async-
shape but for race semantics, not queues.

## §makeStream pairs acks-and-data

```js
export const makeStream = (acks, data) => {
  return harden({
    next(value) {
      data.put(freeze({ value, done: false }));
      return acks.get();
    },
    return(value) { data.put(freeze({ value, done: true })); return acks.get(); },
    throw(error) { data.put(harden(Promise.reject(error))); return acks.get(); },
    [Symbol.asyncIterator]() { return stream; },
  });
};
```

§Stream-is-just-a-cross-wired-pair-of-queues. `next(value)`
puts to data, gets from acks. §The-caller-sends-by-putting-
and-waits-for-acknowledgment-by-getting.

§Three-symmetric-methods (next / return / throw). §All-put-
to-data, all-get-from-acks. §Symmetry-across-the-three-
states-of-iteration.

§throw-puts-a-rejected-promise (not the error directly).
§Errors-flow-through-the-data-queue-as-rejections. §Receiver-
sees-it-as-an-iterator-result-rejection.

§Done-flag-on-return: `{value, done: true}`. §Reader-sees-
done-and-can-stop-iterating.

§Shallow-freeze-because-typed-arrays-are-not-freezable: the
wrapper `{value, done}` is frozen but `value` itself isn't.
§Defensive-against-typed-array-edge-case.

## §makePipe — two queues, cross-wired

```js
export const makePipe = () => {
  const data = makeQueue();
  const acks = makeQueue();
  const reader = makeStream(acks, data);
  const writer = makeStream(data, acks);
  return harden([writer, reader]);
};
```

§Two-queues-one-pipe. The Reader has (acks, data); the
Writer has (data, acks) — §args-flipped. §What-Reader-puts-
in-data-is-what-Writer-gets-from-data.

§Three-line-implementation reveals the simplicity. §The-
symmetric-makeStream-makes-this-possible: §swap-args-get-
the-other-direction.

§Conceptually-Reader-receives-from-data-and-acks-back-via-
acks. §Writer-sends-to-data-and-awaits-ack-via-acks. §Each-
operation-handshakes (no fire-and-forget).

§Why-handshake: §back-pressure. The writer's `next()`
doesn't resolve until the reader has acked. §The-rate-of-
flow-is-rate-of-acks.

## §pump with tick/tock mutual recursion

```js
export const pump = async (writer, reader, primer) => {
  const tick = promise =>
    E.when(promise, result => {
      if (result.done) return writer.return(result.value);
      return tock(writer.next(result.value));     // mutual recursion
    }, error => writer.throw(error));
  const tock = promise =>
    E.when(promise, result => {
      if (result.done) return reader.return(result.value);
      return tick(reader.next(result.value));
    }, error => reader.throw(error));
  await tick(reader.next(primer));
};
```

§Behold-mutual-recursion (literal comment in the code).

§tick processes a reader-result; calls writer.next; passes
the writer's ack-promise to tock.
§tock processes a writer-result; calls reader.next; passes
the reader's ack-promise to tick.

§Two-functions-name-the-two-roles in the handshake. §The-
cycle-of-promises-walks-the-pump.

§E.when-not-await: §let-this-work-on-remote-eventual-send-
values. The pump can drive a stream where one end is across
a CapTP connection (cycle 137's daemon-message-streaming
relies on this).

§Done-propagates: when either side returns done, the other
side is closed via .return(). §Symmetric-shutdown.

§Errors-propagate-via-.throw: §errors-on-one-side-close-
the-other-with-throw.

§Primer-is-the-first-value-the-reader-receives: §the-
reader-needs-to-be-told-something-to-start.

## §prime captures first-returned-promise

```js
export const prime = (generator, primer) => {
  const first = generator.next(primer);     // captured
  let result;
  return harden({
    async next(value) {
      if (result === undefined) {
        result = await first;
        if (result.done) return result;
      }
      return generator.next(value);
    },
    async return(value) { ... },
    async throw(error) { ... },
  });
};
```

§Async-generator-needs-priming because the first value is
sent at generator-creation, not via .next(). §The-first-
.next(value)-is-actually-the-second-value.

§Capture-first-then-forward: the wrapper holds the §first-
promise; the first call to any method awaits it before
proceeding.

§Three-methods-all-wait-for-first: §uniform-discipline-
across-the-iterator-protocol.

§Why-this-matters: async-generators have a §timing-
asymmetry between creation and first iteration. §Prime-
makes-the-timing-uniform.

## §mapReader and mapWriter — asymmetric shapes

```js
export const mapReader = (reader, transform) => {
  async function* transformGenerator() {
    for await (const value of reader) {
      yield transform(value);
    }
  }
  return harden(transformGenerator());
};

export const mapWriter = (writer, transform) => {
  return harden({
    async next(value) { return writer.next(transform(value)); },
    async throw(error) { return writer.throw(error); },
    async return(value) { return writer.return(value); },
    [Symbol.asyncIterator]() { return transformedWriter; },
  });
};
```

§Two-different-shapes-for-the-same-pattern. §Reader-side-
uses-async-generator (consume + yield transformed);
§writer-side-uses-method-wrapping (intercept next, leave
throw/return as pass-through).

§Why-the-asymmetry: §the-iteration-direction-is-different.
- Reader: data flows *out* — for-await-of consumes; yield
  produces. §Easy-to-express-as-async-generator.
- Writer: data flows *in* — next(value) is called by the
  consumer. §Method-wrapping-is-natural.

§The-symmetry-of-the-stream-interface (Reader and Writer
are structurally identical) doesn't translate to the
§implementation-of-transformers: §the-direction-of-
iteration-matters-for-implementation-shape.

§Throw-and-return-pass-through-unchanged: §only-data-is-
transformed, not control signals.

## §Harden-everything-individually

```js
harden(makeQueue);
harden(makeStream);
harden(makePipe);
harden(pump);
harden(prime);
harden(mapReader);
harden(mapWriter);
```

§Defensive-harden-discipline. Each export is individually
hardened, not just the module export. §Harden-the-factory-
not-just-the-result.

§Why: a transitive caller could mutate the factory object
before calling it. §Harden-at-definition closes this
window.

§Cycle-108's-coordinated-update-cluster (commit `e56bf00f`)
adopted `@endo/harden` as the standard import.

## §The-stream-substrate-ecosystem

§This-file-is-the-substrate-many-files-depend-on:

- **Cycle 137 daemon-message-streaming**: uses streams to
  carry §progressive-text-delivery across CapTP. The
  design's §stream-formula leans on this file's makePipe.
- **Cycle 163 ocap-kernel glossary**: notes `@endo/stream`
  as the shared substrate between Endo's stream concept
  and ocap-kernel's channel concept. §Different-vocabulary-
  same-substrate.
- **Cycle 154 trap.js**: the synchronous-trap mechanism
  doesn't use streams directly, but cycle 169's atomics.js
  has the §async-generator-as-resumable-state-machine
  pattern that mirrors §makeStream's three-method shape.
- **Cycle 158 loopback.js**: cross-wires two CapTP
  instances using two streams.
- **@endo/captp wire transport**: any CapTP connection is
  built on a Reader/Writer pair.

§Cycle-156-finalize.js's-WeakValueMap-GC is unrelated to
streams directly but the patterns are sibling: §async-data-
structures-with-careful-lifecycle.

## §Comparison with ocap-kernel's stream

> *§Channel = communication-pathway; §stream = remote-async-
> iterator from @endo/stream (shared substrate)* (from
> cycle 163's glossary section).

§Vocabulary-drift-where-substrate-is-shared (cycle 163
named this).

| System | Term | Meaning |
|--------|------|---------|
| ocap-kernel | channel | bidirectional comm pathway |
| ocap-kernel | stream | unidirectional async iterator |
| @endo/stream | Stream | symmetric (Reader OR Writer) |
| @endo/captp | connection | bidirectional CapTP wire |

§Three-different-vocabularies for §two-or-three-different-
things. The §symmetric-stream from this file is more
general than ocap-kernel's *stream* (which is
unidirectional).

§Synthesis-target: clarifying the relationship between
§Reader/Writer/Pipe in @endo/stream and §unidirectional-
stream / §bidirectional-channel in ocap-kernel could help
the OCapN specification.

## §The-promise-kit-foundation

This file uses `makePromiseKit` from `@endo/promise-kit`
(cycle 152's memo-race.js sibling). §Promise-kit-is-the-
substrate. §Every-cons-cell-uses-a-promise-kit.

§Cycle-152's-memo-race is for racing-with-cleanup; this
file's makeQueue is for sequencing-with-back-pressure.
§Two-promise-based-async-primitives in the @endo
ecosystem.

## §Gap-revealing-comparison with garden cycles

| Cycle | Connection |
|-------|------------|
| 137 (daemon-message-streaming) | §Uses-this-substrate for progressive-text-delivery |
| 163 (ocap-kernel glossary) | §Vocabulary-drift-where-substrate-is-shared |
| 158 (loopback.js) | §Two-CapTP-instances-cross-wired uses streams under the hood |
| 154 (trap.js) | §Async-generator-as-resumable-state-machine sibling pattern |
| 152 (memo-race.js) | §Promise-kit-substrate sibling; different async primitive |
| 169 (atomics.js) | §SharedArrayBuffer-transport for synchronous Trap; this is the async substrate |

## §Tier-1 vocabulary borrowing candidates

§Symmetric-stream-interface (Reader/Writer by convention),
§makePipe-from-two-cross-wired-queues, §functional-async-
queue (promise-chain cons-cells), §back-pressure-via-acks,
§prime-captures-first-returned-promise, §async-generator-
for-reader-transform / method-wrapping-for-writer-
transform, §E.when-not-await for §remote-eventual-send-
compatibility, §harden-everything-individually.

§Tier-2: §every-method-and-argument-required (vs vanilla
iterators' optional methods), §three-method-symmetry-next-
return-throw.

## §Synthesis-target

The §symmetric-stream-interface pattern is borrowable:
when designing a two-ended async protocol, consider
whether the two ends can be §structurally-identical-
differing-only-by-convention. §Less-code-than-asymmetric-
shapes.

§makePipe-from-two-queues idiom: when you need a paired
channel, build it from two opposing queues. §The-pipe-is-
just-cross-wiring.

§Slot machine library will need stream-like primitives for
its game-state-stream and player-action-stream. §Reuse-
this-substrate.

## §Small-file-but-foundational

247 lines, 7 exports. §Foundational-not-peripheral. Many
other files in @endo and downstream code depend on this.
§Reading-this-file-tells-you-Endo's-async-pattern-
vocabulary.

§Sibling-to-cycle-167's-where/index.js and cycle-169's
atomics.js as §small-files-with-large-knowledge-density.
§The-substrate-files-are-often-the-shortest.
