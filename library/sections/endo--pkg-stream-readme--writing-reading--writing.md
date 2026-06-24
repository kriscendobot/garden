---
title: Writing
source: packages/stream/README.md
source_repo: endojs/endo
source_commit: 1aafa86e
source_date: 2022-01-21
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [streams]
status: current
parent: endo--pkg-stream-readme--writing-reading
---

To write to a stream, give a value to the next method.

```js
// ...
await writer.next(value);
```

Awaiting the returned promise slows the writer to match the pace of the reader.

Source: [packages/stream/README.md](https://github.com/endojs/endo/blob/1aafa86e/packages/stream/README.md) at commit `1aafa86e`.
