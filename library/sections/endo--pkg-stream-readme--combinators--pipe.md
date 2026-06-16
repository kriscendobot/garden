---
title: Pipe
source: packages/stream/README.md
source_repo: endojs/endo
source_commit: 1aafa86e
source_date: 2022-01-21
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [streams]
status: current
parent: endo--pkg-stream-readme--combinators
---

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

Source: [packages/stream/README.md](https://github.com/endojs/endo/blob/1aafa86e/packages/stream/README.md) at commit `1aafa86e`.
