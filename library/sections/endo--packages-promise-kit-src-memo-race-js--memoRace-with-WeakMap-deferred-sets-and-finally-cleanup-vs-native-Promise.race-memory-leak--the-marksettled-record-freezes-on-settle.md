---
section: memoRace-with-WeakMap-deferred-sets-and-finally-cleanup-vs-native-Promise.race-memory-leak
source: endo--packages-promise-kit-src-memo-race-js
topics: [eventual-send, hardened-javascript, async-flow]
status: current
title: The §markSettled — §record-freezes-on-settle
parent: endo--packages-promise-kit-src-memo-race-js--memoRace-with-WeakMap-deferred-sets-and-finally-cleanup-vs-native-Promise.race-memory-leak
---

```js
const markSettled = record => {
  if (!record || record.settled) return new Set();
  const { deferreds } = record;
  Object.assign(record, {
    deferreds: undefined,
    settled: true,
  });
  Object.freeze(record);
  return deferreds;
};
```

The §atomic-transition discipline:

1. Read the deferreds Set.
2. *Replace* the record's `deferreds` with `undefined` and
   set `settled: true`.
3. `Object.freeze(record)` — future mutations throw.
4. Return the captured deferreds Set.

The §freeze-after-transition makes the post-settled record
*immutable*: any subsequent code that holds a stale reference
to the record can't accidentally mutate it. The §state-
machine-with-frozen-terminal-state idiom.

The §`if (!record || record.settled) return new Set()` short-
circuit handles two cases:

- Called on `undefined` (e.g. record GC'd by WeakMap due to
  value going out of scope elsewhere — *can't happen here*,
  but defensive).
- Called twice (e.g. by a stale reference). The second call
  finds `settled: true` and returns an empty Set. The §idempotent-
  markSettled property.
