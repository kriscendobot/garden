---
title: Reading
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

To read from a stream, await the value returned by the next method.

```js
for await (const value of reader) {
  // ...
}
```

Source: [packages/stream/README.md](https://github.com/endojs/endo/blob/1aafa86e/packages/stream/README.md) at commit `1aafa86e`.
