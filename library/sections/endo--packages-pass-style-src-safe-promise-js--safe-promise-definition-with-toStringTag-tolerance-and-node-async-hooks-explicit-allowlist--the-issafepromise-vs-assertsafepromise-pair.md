---
section: safe-promise-definition-with-toStringTag-tolerance-and-node-async-hooks-explicit-allowlist
source: endo--packages-pass-style-src-safe-promise-js
topics: [pass-style, eventual-send]
status: current
title: The §isSafePromise-vs-assertSafePromise pair
parent: endo--packages-pass-style-src-safe-promise-js--safe-promise-definition-with-toStringTag-tolerance-and-node-async-hooks-explicit-allowlist
---

The two exports:

```js
export const isSafePromise = pr => confirmSafePromise(pr, false);
hideAndHardenFunction(isSafePromise);

export const assertSafePromise = pr => confirmSafePromise(pr, Fail);
hideAndHardenFunction(assertSafePromise);
```

Both wrap `confirmSafePromise`:

- `isSafePromise(pr)` passes `false` as the rejector → falsy
  conjunctions short-circuit to `false`; the function returns
  boolean.
- `assertSafePromise(pr)` passes `Fail` (the throwing rejector)
  → falsy conjunctions invoke `Fail` which throws.

The §rejector-pattern visible across many @endo files: one
internal predicate function takes a *rejector* argument; the
public surface is *two* exports (boolean-returning and throw-on-
failure-asserting).
