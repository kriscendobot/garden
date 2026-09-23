---
title: Prime
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
