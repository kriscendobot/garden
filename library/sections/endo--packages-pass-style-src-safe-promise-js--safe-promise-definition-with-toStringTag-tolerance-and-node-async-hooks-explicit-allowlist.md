---
section: safe-promise-definition-with-toStringTag-tolerance-and-node-async-hooks-explicit-allowlist
source: endo--packages-pass-style-src-safe-promise-js
topics: [pass-style, eventual-send]
status: current
---

# Safe-promise definition with @@toStringTag tolerance and Node async_hooks explicit allowlist

> *Under Hardened JS a promise is "safe" if its `then` method can
> be called synchronously without giving the promise an
> opportunity for a reentrancy attack during that call.*
>
> — `packages/pass-style/src/safe-promise.js` §confirmSafePromise JSDoc

`safe-promise.js` (158 lines, Kris Kowal-last-touched 2026-02-24
in commit `e56bf00f` — same coordinated-update cluster as cycles
108/110/115/118/123/125/132/134/136) defines what a *safe
promise* is. The file exports `isSafePromise` and
`assertSafePromise` (both wrap the private `confirmSafePromise`
with `false`/`Fail` rejector).

## The §safety-via-no-reentrancy-during-then thesis

The §confirmSafePromise JSDoc gives the *operational definition*:

> *Under Hardened JS a promise is "safe" if its `then` method
> can be called synchronously without giving the promise an
> opportunity for a reentrancy attack during that call.*

The §reentrancy-attack threat shape: a malicious thenable can
override `.then` to *run code while the caller is in the middle
of operating on it*, gaining synchronous re-entry into the
caller's state. Safe promises are the *defense*: a promise whose
`.then` method *cannot do that*.

The §reentrancy-via-test-itself meta-hazard:

> *https://github.com/Agoric/agoric-sdk/issues/9 raises the
> issue of testing that a specimen is a safe promise such that
> the test also does not give the specimen a reentrancy
> opportunity. That is well beyond the ambition here.*

The §honest-limitation discipline: the safety check itself
*touches the specimen* (via `getPrototypeOf`, `ownKeys`, etc.).
A perfectly-paranoid implementation would test in a way that
*doesn't* call into the specimen at all. This file *doesn't*
achieve that; the JSDoc names the gap.

## The §four-conjunction safety check

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

## The §@@toStringTag-tolerance — the only allowed symbol own
property

The §confirmPromiseOwnKeys function exists because *some*
symbol-named own properties are allowed:

```js
const unknownKeys = keys.filter(
  key => typeof key !== 'symbol' || !hasOwn(Promise.prototype, key),
);
```

The §filter-out-symbols-on-Promise.prototype discipline: any
symbol-named key that's *also* on `Promise.prototype` is treated
as a *potential override* and validated separately (via
`checkSafeOwnKey`); other symbols are unknown and reject.

The §three-property toStringTag invariant in `checkSafeOwnKey`:

> *Explicitly tolerate a `toStringTag` symbol-named
> non-enumerable data property whose value is a string.*

Three sub-conditions for an own `@@toStringTag`:

1. Must be a *data property* (not an accessor): `hasOwn(tagDesc,
   'value')`.
2. Value must be a *string*: `typeof tagDesc.value === 'string'`.
3. Must be *non-enumerable*: `!tagDesc.enumerable`.

The §TODO note:

> *TODO should we also enforce anything on the contents of the
> string, such as that it must start with `'Promise'`?*

The current implementation accepts *any* string; future PRs may
narrow.

## The §Node-async_hooks-explicit-allowlist

The §checkSafeOwnKey function has a *Node-specific* branch for
non-toStringTag keys:

```js
const val = pr[key];
if (val === undefined || typeof val === 'number') {
  return true;
}
if (
  typeof val === 'object' &&
  val !== null &&
  isFrozen(val) &&
  getPrototypeOf(val) === Object.prototype
) {
  const subKeys = ownKeys(val);
  if (subKeys.length === 0) {
    return true;
  }
  if (
    subKeys.length === 1 &&
    subKeys[0] === 'destroyed' &&
    val.destroyed === false
  ) {
    return true;
  }
}
return reject && reject`Unexpected Node async_hooks additions to promise: ...`;
```

The §inline-comment cites Node's source verbatim:

```js
function destroyTracking(promise, parent) {
  trackPromise(promise, parent);
  const asyncId = promise[async_id_symbol];
  const destroyed = { destroyed: false };
  promise[destroyedSymbol] = destroyed;
  registerDestroyHook(promise, asyncId, destroyed);
}
```

The §three-allowed-shapes:

1. **`undefined` or `number`** — the `async_id_symbol` value is
   a number (the asyncId).
2. **Frozen `Object`-prototype object with no own keys** — an
   empty `{}` sentinel.
3. **Frozen `Object`-prototype object with exactly one key
   `destroyed: false`** — the literal `{ destroyed: false }`
   shape from Node's code.

The §exact-shape-match discipline: each Node-async_hooks
addition has a *specific* expected shape; deviations fail.

The §cite-Node-source-verbatim-in-comment discipline is
structurally interesting: when the safety check has to *tolerate
host-specific quirks*, the host's exact source code becomes
*part of the safety surface*. If Node's async_hooks changes the
shape, this file must update.

The §destroyed-must-be-false sub-invariant: a freshly-tracked
promise has `destroyed === false`. The check allows that
specific value (not `true`); a *destroyed* promise's marker
would fail this branch. This *probably* doesn't matter
operationally (the destroyed marker is set asynchronously, on
GC), but the strict check catches any unexpected mutation.

## The §isSafePromise-vs-assertSafePromise pair

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

## The §hideAndHardenFunction vs harden

The §`hideAndHardenFunction` (vs `harden`) is structurally
worth noting:

- **`harden(fn)`** freezes the function and its prototype chain.
- **`hideAndHardenFunction(fn)`** does that *plus* sets the
  function's `name` and other metadata to be non-revealing.

The §rationale (from `@endo/errors`): when an assertion function
throws, its name appears in the stack trace. The hideAndHarden
variant prevents the function's name from being shown,
*reducing information leak* from the assertion's call site.

Cycle 134's `remotable.js` used `hideAndHardenFunction(assertIface)`
for the same reason — assertion functions hide their identity
from the stack trace.

## How safe-promises fit the pass-style + eventual-send picture

The §file-level use case: safe-promises are what
`@endo/eventual-send`'s `E()` and `HandledPromise` *trust to be
non-reentrant*. Cycle 66's `handled-promise.js` §handler-protocol
section describes the dispatcher; cycle 132's `local.js`
defines the local-delivery primitives. Both rely on the
*incoming-promise-must-be-safe* invariant.

The §pass-style relationship: safe-promises are *not themselves*
a pass-style (cycle 71's passStyleOf.js doesn't return a
`'promise'` style). They're a *pre-condition* for safe pass-by-
reference of promises. Cycle 87's `error.js` (passing errors)
has a similar discipline: validate first, *then* pass.

## Related sections

- cycle 66 (§handler-protocol)
  [[endo--packages-eventual-send-src-handled-promise-js--handler-protocol]]
  — the HandledPromise dispatcher that depends on this file's
  safe-promise invariant when promises cross handler boundaries.
- cycle 132
  [[endo--packages-eventual-send-src-local-js--three-local-delivery-primitives-with-debugger-breakpoint-integration-and-getMethodNames-introspection]]
  — the local-delivery primitives that *trust* the safe-promise
  invariant when calling `apply()`.
- cycle 134
  [[endo--packages-pass-style-src-remotable-js--what-a-remotable-is-with-tag-record-inheritance-and-distinct-object-vs-function-remotable-shapes]]
  — uses `hideAndHardenFunction(assertIface)` for the same
  stack-trace-name-hiding rationale this file applies to
  `isSafePromise`/`assertSafePromise`.
- cycle 71
  [[endo--packages-pass-style-src-passstyleof-js--passstyleof-classifier-internals]]
  — the dispatcher that *doesn't* classify promises as a pass-
  style; the safe-promise discipline is *adjacent* to pass-style
  rather than *inside* it.
