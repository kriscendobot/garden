---
title: Pump
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

Source: [packages/stream/README.md](https://github.com/endojs/endo/blob/1aafa86e/packages/stream/README.md) at commit `1aafa86e`.
