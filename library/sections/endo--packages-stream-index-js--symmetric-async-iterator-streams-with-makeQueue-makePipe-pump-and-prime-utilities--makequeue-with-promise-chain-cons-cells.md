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
title: §makeQueue with promise-chain cons-cells
parent: endo--packages-stream-index-js--symmetric-async-iterator-streams-with-makeQueue-makePipe-pump-and-prime-utilities
---

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
