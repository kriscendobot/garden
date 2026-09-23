---
section: safe-promise-definition-with-toStringTag-tolerance-and-node-async-hooks-explicit-allowlist
source: endo--packages-pass-style-src-safe-promise-js
topics: [pass-style, eventual-send]
status: current
title: The §four-conjunction safety check
parent: endo--packages-pass-style-src-safe-promise-js--safe-promise-definition-with-toStringTag-tolerance-and-node-async-hooks-explicit-allowlist
---

The §confirmSafePromise body is a four-conjunction:

```js
return (
  (isFrozen(pr) || (reject && reject`${pr} - Must be frozen`)) &&
  (isPromise(pr) || (reject && reject`${pr} - Must be a promise`)) &&
  (getPrototypeOf(pr) === Promise.prototype ||
    (reject && reject`${pr} - Must inherit from Promise.prototype: ${q(...)}`)) &&
  confirmPromiseOwnKeys(pr, reject)
);
```

The four-condition check:

1. **§Must be frozen** — `isFrozen(pr)`. Tampering with the
   promise after the check is the easiest reentrancy vector;
   freezing prevents it.

2. **§Must be a promise** — `isPromise(pr)` from
   `@endo/promise-kit`. The check uses Node's internal promise
   detector rather than `instanceof Promise` (which is realm-
   dependent).

3. **§Must inherit from Promise.prototype directly** —
   `getPrototypeOf(pr) === Promise.prototype`. No subclassing
   (the prototype chain must be *exactly* Promise.prototype, not
   a subclass). The §strict-prototype-check rules out *promise
   subclasses* that might override behavior.

4. **§Own-keys-clean** — `confirmPromiseOwnKeys` enforces the
   own-property allowlist (covered below).

Each condition is the `||` of *the check passing* OR *invoke the
rejector with a diagnostic message*. The §rejector-as-callback
pattern lets the same function serve both `isSafePromise` (which
returns boolean) and `assertSafePromise` (which throws).
