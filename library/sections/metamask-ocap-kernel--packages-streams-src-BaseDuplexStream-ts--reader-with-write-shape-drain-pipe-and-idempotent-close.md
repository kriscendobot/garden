---
title: "The duplex stream as a Reader with write(): the reader/writer-backed shape, drain/pipe, and idempotent return/throw/end close"
source: packages/streams/src/BaseDuplexStream.ts
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/packages/streams/src/BaseDuplexStream.ts
source_kind: comment-fragment
source_path: packages/streams/src/BaseDuplexStream.ts
source_line_range: "80-166, 280-355"
source_branch: main
source_commit: 8c4f04ba2889c442f5e0cc4eb43f5b6b9d80c39c
source_date: 2026-01-13
comment_subject: BaseDuplexStream is a BaseReader-with-write() backed by separate reader and writer instances; it is its own async iterator; drain() forwards each value to a handler and pipe() drains into another duplex sink; return()/throw()/end() are idempotent close paths that settle synchronization and close both underlying halves, returning a done result; and the exported DuplexStream type narrows the class to its public surface.
source_authors: [Erik Marks, Dimitris Marlagkoutsos]
ingested: 2026-07-06
ingested_by: scholar
topics: [streams]
status: current
notes: External sibling implementation — MetaMask/ocap-kernel, a SwingSet-lineage object-capability kernel distinct from @endo (same root, different code). Comment-fragment ingest of the duplex-stream shape and close lifecycle in BaseDuplexStream.ts. Fifteenth ocap-kernel ingest; first from packages/streams. See [[ocap-kernel]].
---

## Abstract

`BaseDuplexStream` presents itself as a `Reader<Read>` — "essentially a `BaseReader` with a `write()` method" — while delegating to **separate underlying `BaseReader` and `BaseWriter` instances** held in private fields. It is its own async iterator (`[Symbol.asyncIterator]()` returns `this`), so `for await` works directly. Two consumption helpers ride on that: `drain(handler)` pulls every value and passes it to a handler, and `pipe(sink)` drains this stream into another duplex stream's `write`. Three **idempotent close paths** — `return()` (clean), `throw(error)` (error), and `end(error?)` (sugar picking between them) — each settle the synchronization promise (resolve on `return`, reject on `throw`) and then close *both* underlying halves before returning a done `IteratorResult`. The exported `DuplexStream<Read, Write>` type narrows the class to exactly its public surface (`next` / `write` / `drain` / `pipe` / `return` / `throw` / `end` / async-iterator), the shape consumers and the `pipe` sink parameter are typed against.

## Body

### A Reader with write(), backed by two halves

The class JSDoc states the shape plainly:

```
 * The base of a duplex stream. Essentially a {@link BaseReader} with a `write()` method.
 * Backed up by separate {@link BaseReader} and {@link BaseWriter} instances under the hood.
```

```ts
export abstract class BaseDuplexStream<
  Read,
  ReadStream extends BaseReader<Read>,
  Write = Read,
  WriteStream extends BaseWriter<Write> = BaseWriter<Write>,
> implements Reader<Read>
{
  readonly #reader: ReadStream;   // "The underlying reader for the duplex stream."
  readonly #writer: WriteStream;  // "The underlying writer for the duplex stream."
  // ...
}
```

`Read` and `Write` are separate type parameters (`Write` defaults to `Read`), so a duplex stream may read one type and write another. The class composes a reader and a writer rather than inheriting one — the `write()` method (and the synchronization machinery) is the value it adds over a bare `BaseReader`. It `implements Reader<Read>`, which is why it can be handed anywhere a reader is expected.

### It is its own async iterator; drain and pipe consume it

```ts
[Symbol.asyncIterator](): typeof this {
  return this;
}

async drain(handler: (value: Read) => void | Promise<void>): Promise<void> {
  for await (const value of this) {
    await handler(value);
  }
}

async pipe<Read2>(sink: DuplexStream<Read2, Read>): Promise<void> {
  await this.drain(async (value) => {
    await sink.write(value);
  });
}
```

Because `[Symbol.asyncIterator]()` returns `this`, the stream is directly iterable, and `drain` is the natural `for await` consumer: it forwards every value to `handler`, awaiting each (so a slow handler applies back-pressure through the gated `next()`). `pipe` is `drain` with the handler fixed to the sink's `write` — it forwards this stream's `Read` values into another duplex stream whose `Write` type is `Read` (note the `DuplexStream<Read2, Read>` sink type: the sink writes what this stream reads).

### Idempotent close: return / throw / end

```ts
async return(): Promise<IteratorResult<Read, undefined>> {
  this.#completeSynchronization();
  await Promise.all([this.#writer.return(), this.#reader.return()]);
  return makeDoneResult();
}

async throw(error: Error): Promise<IteratorResult<Read, undefined>> {
  this.#failSynchronization(error);
  // eslint-disable-next-line promise/no-promise-in-callback
  await Promise.all([this.#writer.throw(error), this.#reader.throw(error)]);
  return makeDoneResult();
}

async end(error?: Error): Promise<IteratorResult<Read, undefined>> {
  return error ? this.throw(error) : this.return();
}
```

All three JSDocs say "**Idempotent**." The idempotency is inherited from the terminal sync transitions (from the [handshake section](metamask-ocap-kernel--packages-streams-src-BaseDuplexStream-ts--syn-ack-synchronization-handshake-and-four-state-machine.md)): `#completeSynchronization` / `#failSynchronization` short-circuit once the status is ended, so a second `return()`/`throw()` re-settles nothing, and `#writer.return()` / `#reader.return()` are themselves idempotent per the underlying stream contract. Each close path **settles the sync promise first** — this matters because a pending gated read or write is parked on `#syncKit.promise`, and closing must unblock it (a clean `return` resolves it so parked operations proceed to a done half; a `throw` rejects it so they reject). Both halves are then closed **in parallel** (`Promise.all`), and the method returns `makeDoneResult()` (the shared `{ value: undefined, done: true }` from `./utils.ts`). `end(error?)` is pure sugar: an error routes to `throw`, its absence to `return`.

### The public-surface type

```ts
export type DuplexStream<Read, Write = Read> = Pick<
  BaseDuplexStream<Read, BaseReader<Read>, Write, BaseWriter<Write>>,
  'next' | 'write' | 'drain' | 'pipe' | 'return' | 'throw' | 'end'
> & {
  [Symbol.asyncIterator]: () => DuplexStream<Read, Write>;
};
```

`DuplexStream` — "essentially a `Reader` with a `write()` method" — is a `Pick` of the concrete class narrowed to its seven public methods plus a self-returning async iterator. This is the type `pipe`'s `sink` parameter and external consumers are written against, hiding the class's type parameters (`ReadStream` / `WriteStream`) and its private synchronization internals behind a two-parameter surface.

## Notice / drift check

The class JSDoc ("a `BaseReader` with a `write()` method … backed by separate `BaseReader` and `BaseWriter` instances") matches the composition (`#reader` / `#writer` fields, `implements Reader<Read>`, an added `write`). The "Idempotent" annotations on `return`/`throw`/`end` are backed by the `isEnded`-guarded sync transitions plus the underlying halves' own idempotency. The `pipe` sink type `DuplexStream<Read2, Read>` correctly expresses "the sink writes what this stream reads." No comment-versus-code drift in this cluster. ocap-kernel is a read-only reference shelf (not a garden fork), so no boatman missive is available regardless.

## Lineage note

The reader/writer-plus-close shape is where `@metamask/streams` most resembles `@endo/stream`: both model a stream as an async iterator with `next` / `return` / `throw`, and both harden aggressively (`harden(this)` in the constructor, `harden(BaseDuplexStream)` at module scope — the same individual-hardening discipline Endo's stream package follows). The **duplex** framing (one object that both reads and writes, with `pipe` forwarding between two such) has no single-object analog in `@endo/stream`, whose `makePipe` instead returns a *pair* of reader/writer ends; ocap-kernel packages the pair into one `BaseDuplexStream` because a vat↔kernel link is inherently bidirectional. See the streams README's [gtor + @endo/stream lineage note](metamask-ocap-kernel--packages-streams-readme--ses-compatible-streams-gtor-endo-stream-lineage.md), the Endo counterparts under the [`streams` topic](../topics/streams.md), and [[ocap-kernel]].

Source: [packages/streams/src/BaseDuplexStream.ts](https://github.com/MetaMask/ocap-kernel/blob/8c4f04ba2889c442f5e0cc4eb43f5b6b9d80c39c/packages/streams/src/BaseDuplexStream.ts) (lines 80-166, 280-355) at commit `8c4f04b`.
