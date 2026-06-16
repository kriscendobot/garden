---
section: weak-value-map-via-WeakRef-and-FinalizationRegistry-with-gc-as-side-channel-warning-and-end-of-turn-stability
source: endo--packages-captp-src-finalize-js
topics: [captp, hardened-javascript, capability-security]
status: current
title: "The §issue-#1514 TODO"
parent: endo--packages-captp-src-finalize-js--weak-value-map-via-WeakRef-and-FinalizationRegistry-with-gc-as-side-channel-warning-and-end-of-turn-stability
---

```js
// UNTIL https://github.com/endojs/endo/issues/1514
// Prefer: get: key => keyToRef.get(key)?.deref(),
get: key => {
  const wr = keyToRef.get(key);
  if (!wr) {
    return wr;
  }
  return wr.deref();
},
```

The §TODO-with-issue-link discipline: the cleaner *preferred*
form is named, blocked on a tracked issue. The §commented-out-
preferred-form pattern keeps the future-cleanup visible at the
site.

The §`if (!wr) return wr` shape: returns `undefined` when the
key isn't in the map. Returning `wr` (which is `undefined`)
instead of `return undefined` is a §TypeScript-narrowing
nudge — the inferred return type is *the type of `wr`*, not
*the type of `wr.deref()`*. The §preserve-the-undefined-not-
the-typeof-deref-result discipline (the workaround the TODO
points to).
