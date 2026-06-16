---
section: pareto-pair-entries-merging-with-anti-rank-tie-breaking-for-collection-comparison
source: endo--packages-patterns-src-keys-keycollection-operators-js
topics: [patterns, marshal]
status: current
title: "*Maintain a single-result buffer for each iterator*"
parent: endo--packages-patterns-src-keys-keycollection-operators-js--pareto-pair-entries-merging-with-anti-rank-tie-breaking-for-collection-comparison
---

The merge loop uses the §single-result `{ done, key, value }` buffer
pattern:

```js
let xDone; let xKey; let xValue;
let yDone; let yKey; let yValue;
const nonEntry = [undefined, undefined];
const nextX = () => {
  !xDone || Fail`Internal: nextX must not be called once done`;
  const result = xValue;
  ({ done: xDone, value: [xKey, xValue] = nonEntry } = x.next());
  return result;
};
nextX();
```

The pattern *pre-advances* — `nextX()` is called once before the
loop starts so that `xKey`/`xValue` hold the first entry. Each
subsequent `nextX()` returns the *current* value and advances the
iterator. The same shape applies to `nextY`. The §`!xDone || Fail`
guard prevents calling `nextX` once exhausted (an internal-error
invariant; should be unreachable by design).

The `nonEntry = [undefined, undefined]` array is used as the
destructuring default when the iterator finishes — `value` becomes
`nonEntry` and `[xKey, xValue]` destructures to `[undefined,
undefined]`. The §destructure-with-default idiom avoids a special
branch for the iterator-done case.
