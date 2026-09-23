---
title: Map
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

Source: [packages/stream/README.md](https://github.com/endojs/endo/blob/1aafa86e/packages/stream/README.md) at commit `1aafa86e`.
