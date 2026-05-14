---
title: Combinators: Map, Pipe, Pump, Prime
source: packages/stream/README.md
source_repo: endojs/endo
source_commit: 1aafa86e
source_date: 2022-01-21
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [streams]
status: current
---

> Abstract: Four stream combinators consolidated: map (transform each value), pipe (connect input to output), pump (push values through), prime (initialize a stream with a value). The functional building blocks for stream-pipeline composition.

## Map

To map a reader to a reader through a synchronous value transform, use `mapReader`.

```js
const doubleReader = mapReader(singleReader, n => n * 2);
```

In this example, any value read from doubleReader will be double what was read
from singleReader.

To map a writer to a writer through a synchronous value transform, use
`mapWriter`.

```js
const singleWriter = mapWriter(doubleWriter, n => n * 2);
```

In this example, any value written to singleWriter will be writ double to
doubleWriter.

## Pipe

The `makePipe` function returns an entangled pair of streams.
Use one as a reader and the other as a writer.
Pipes are useful for mocking streams in tests.

```js
const [writer, reader] = makePipe();
```

Pipes use `makeStream` and `makeQueue`.
`makeQueue` creates an async promise queue: a collection type like a queue
except that `get` returns a promise and `put` accepts a promise, so `get` can
be called before `put`.
An async queue ensures that the promises returned by `get` and accepted by
`put` are matched respectively, but provides no guarantee about the order in
which promises settle.
A stream is consequently a pair of queues that transport iteration results,
one to send messages forward and another to receive acknowledgements.

## Pump

The `pump` function pumps iterations from a reader to a writer.
The pump must be primed with the first acknowledgement to send to the reader,
typically `undefined`, as in `reader.next(undefined)`.
This makes the parity of a pump "odd", because the reader needs a free
acknowledgement to start.
This is in contrast to a pipe, which has "even" parity, because the reader and
writer can both proceed initially.

So, for example, we can implement `cat` in Node.js by pumping stdin to stdout.

```js
import { makeNodeWriter, makeNodeReader } from '@endo/stream-node';

const writer = makeNodeWriter(process.stdout);
const reader = makeNodeReader(process.stdin);
await pump(writer, reader);
```

## Prime

Async generator functions are very useful for making reader adapters.

```js
async function *double(reader) {
  for await (const value of reader) {
    yield value * 2;
  }
  return undefined;
}
```

However, async generator functions can also serve as writers, because `yield`
evaluates to the argument passed to `next`.
However, generator writers have odd parity, meaning the first value sent to a
generator function has nowhere to go and gets discarded as the program counter
proceeds from the beginning of the function to the first `yield`, `return`, or
`throw`.

The `prime` function compensates for this by sending a primer to the generator
once.

```js
async function *logGenerator() {
  for (;;) {
    console.log(yield);
  }
}

const writer = prime(logGenerator());
await writer.next('First message is not discarded');
```


Source: [packages/stream/README.md](https://github.com/endojs/endo/blob/1aafa86e/packages/stream/README.md) at commit `1aafa86e`.
