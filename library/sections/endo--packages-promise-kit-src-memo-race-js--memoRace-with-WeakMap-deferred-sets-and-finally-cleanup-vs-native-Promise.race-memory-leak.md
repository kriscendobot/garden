---
section: memoRace-with-WeakMap-deferred-sets-and-finally-cleanup-vs-native-Promise.race-memory-leak
source: endo--packages-promise-kit-src-memo-race-js
topics: [eventual-send, hardened-javascript, async-flow]
status: current
---

# `memoRace` with WeakMap deferred-sets and finally-cleanup vs native `Promise.race` memory leak

> *Unlike `Promise.race` it cleans up after itself so a
> non-resolved value doesn't hold onto the result promise.*
>
> — `packages/promise-kit/src/memo-race.js` line 128

`memo-race.js` (170 lines, single export `memoRace`) is the
@endo/promise-kit *memory-safe-race* primitive. The file's
opening header credits **Brian Kim** ([nodejs/node#17469
comment](https://github.com/nodejs/node/issues/17469#issuecomment-685216777),
2017) and dedicates the code to the public domain via the
**Unlicense**. Last-touched 2025-10-09 by Kris Kowal in cycle
108's coordinated-update commit `e56bf00f` (the @endo/harden
migration). Prior touches: Mark S. Miller 2025-06-23
(faster-isObject refactor), Turadg Aleahmad 2024-08-19 / 2022-
09-30 (TypeScript), Mark S. Miller 2022-07-27 (more-hardens).

## The §load-bearing-bug — §native-Promise.race-memory-leak

The §load-bearing observation is named in the JSDoc:

> *Unlike `Promise.race` it cleans up after itself so a
> non-resolved value doesn't hold onto the result promise.*

The §native-Promise.race-memory-leak: when `Promise.race(P1,
P2, P3, ...)` is called, the engine internally attaches
`.then(resolve, reject)` to *every* `Pi`. If `P1` settles
first and `P2`, `P3`, ..., `Pn` *never settle*, then their
attached resolve/reject handlers — which retain references to
the race-result-promise — are *never released*. The
race-result-promise stays alive as long as *any* unresolved
input promise stays alive.

In a long-running session this leaks: every `Promise.race`
ever called pins its result for the lifetime of the longest-
lived input. The §long-lived-promise-pins-races problem.

The fix is to *clean up* — after the race settles, *remove*
the deferred from the still-pending inputs so they no longer
hold the result promise.

## The §single most structurally interesting move — §WeakMap-shared-deferred-sets

The §`knownPromises` WeakMap is the architectural keystone:

```js
const knownPromises = new WeakMap();
// keys: input values; values: PromiseMemoRecord
```

Each WeakMap entry is a `PromiseMemoRecord`:

```js
{ settled: false, deferreds: Set<Deferred> }  // pending
{ settled: true, deferreds: undefined }       // settled, frozen
```

The §shared-record-across-races discipline: if the *same value*
appears in *multiple* races (a common pattern when one promise
is a member of many races), they share *one* memo record. The
§once-per-value-then-handler discipline is the §one-then-per-
value-lifetime invariant:

```js
if (!record) {
  record = { deferreds: new Set(), settled: false };
  knownPromises.set(value, record);
  Promise.resolve(value).then(
    val => { for (const { resolve } of markSettled(record)) resolve(val); },
    err => { for (const { reject } of markSettled(record)) reject(err); },
  );
}
```

The §`.then()` is *called once* per value (gated by `if
(!record)`). Subsequent races on the same value find the
record already in the WeakMap and just *register their
deferred* in the existing Set. The §amortize-one-then-across-
many-races optimization.

The §when-the-value-settles broadcast: `Promise.resolve(value).then`
fires *once* (when the value settles), and at that point
`markSettled(record)` returns the *entire Set of waiting
deferreds*. The handler iterates the set and notifies each
deferred. The §broadcast-pattern-via-shared-set.

## The §markSettled — §record-freezes-on-settle

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

## The §primitive-fake-settled-record idiom

```js
if (isPrimitive(value)) {
  // If the contender is a primitive, attempting to use it as a key in the
  // weakmap would throw an error. Luckily, it is safe to call
  // `Promise.resolve(contender).then` on a primitive value multiple times
  // because the promise fulfills immediately. So we fake a settled record.
  return harden({ settled: true });
}
```

The §primitive-bypass-via-fake-record discipline: primitives
(`undefined`, `null`, `boolean`, `number`, `bigint`, `string`,
`symbol`) cannot be WeakMap keys. Rather than special-case the
caller, the function returns a *hardened fake record* signaling
"settled". The caller then calls `Promise.resolve(value).then(...)`
which fires *immediately* (primitives are not thenable; the
spec resolves them in the microtask queue).

The §harden-the-fake-record discipline: even the fake record
is hardened, matching the §frozen-after-transition discipline
of real records. The §uniform-record-shape across primitive
and object cases.

§TODO marker at the top: *Consolidate with `isPrimitive`
that's currently in `@endo/pass-style`. Layering constraints
make this tricky, which is why we haven't yet figured out how
to do this*. The §honest-duplication acknowledgment — cycle
142's `passStyle-helpers.js` also duplicated `isPrimitive`
(its version dropped the cycle's §safer-but-slower-on-XS
trade-off). The §layering-constraints-block-DRY observation:
@endo/promise-kit sits *below* @endo/pass-style in the
dependency graph; importing it would create a cycle.

## The §finally-cleanup — the §memory-leak fix

```js
return result.finally(() => {
  for (const value of cachedValues) {
    const { deferreds } = getMemoRecord(value);
    if (deferreds) {
      deferreds.delete(deferred);
    }
  }
});
```

The §finally-as-cleanup-hook idiom. After `result` settles
(by resolution or rejection of *any* input), the `.finally`
runs and *removes* the race's deferred from every input
value's deferred-Set. After this cleanup:

- Settled inputs: their `deferreds` field is already
  `undefined`, so `if (deferreds) deferreds.delete(deferred)`
  is a no-op.
- Pending inputs: the deferred is removed from their Set.

The §`if (deferreds)` short-circuit handles both cases
uniformly.

The §the-deferred-no-longer-holds-the-result-promise: once
the deferred is removed, *no* path from a still-pending input
holds the result promise. GC can reclaim the result.

The §finally-vs-then-for-cleanup choice: `.finally` runs
*after* `result` settles (in *both* resolve and reject paths)
*without* affecting the chain's value. A `.then(cleanup,
cleanup)` would work but visually conflates cleanup with
result handling. `.finally` makes the cleanup intent visible.

## The §cachedValues — §iterable-might-not-be-rerunnable defense

```js
const cachedValues = [];
// ...
for (const value of values) {
  cachedValues.push(value);
  ...
}
// ... later, in finally:
for (const value of cachedValues) { ... }
```

The §iterable-might-not-be-rerunnable defense: the input
`values` is `T extends readonly unknown[] | []`, but
TypeScript types don't enforce *re-iterability*. Generators
and other one-shot iterables would *exhaust* on the first
`for` loop; the finally would see an empty iterable. Caching
into a fresh array preserves the values for the finally
cleanup.

The §single-pass-with-cached-array idiom is the standard
defense against one-shot iterables that need traversal twice.

## The §`this`-as-PromiseConstructor subclassability

```js
const C = this;
const result = new C((resolve, reject) => { ... });
```

The §subclassable-design discipline: `memoRace` takes `this`
as the Promise constructor. Default-call (`memoRace(values)`)
uses *whatever* `this` is bound to (typically global Promise);
subclasses can call `MyPromise.memoRace(values)` to get
results in the subclass.

The §this-as-constructor pattern matches the standard
ECMAScript Promise.* static methods (Promise.all, Promise.race,
Promise.allSettled). The §interop-with-promise-subclasses
property.

## The §object-syntax-name-trick

```js
const { race } = {
  race(values) { ... },
};
// ...
export { race as memoRace };
```

The §named-function-via-object-destructure idiom. The
function's `.name` is `'race'` because it's the method-name in
the object literal. If `const race = (values) => { ... }`
were used, the name would still be `'race'` (assignment
inference), but the §method-syntax has a subtle benefit: the
function is *non-constructable* and lacks a prototype property.
The §don't-let-callers-`new`-this-function discipline.

The §`export { race as memoRace }` rename: external API uses
`memoRace`; internal name is `race`. The §api-name-vs-impl-
name asymmetry.

## How this file fits the @endo/promise-kit cluster

`memo-race.js` is one of four files in `packages/promise-kit/
src/`:

- `is-promise.js` (12 lines) — promise detection.
- `memo-race.js` (this file) — memory-safe race.
- `promise-executor-kit.js` (55 lines) — `makePromiseKit()` /
  `racePromises()` factory pair.
- `types.js` (138 lines) — JSDoc typedefs for ERef, etc.

The package surfaces `makePromiseKit` (cycle 138's safe-
promise.js consumes this) + `memoRace` + `isPromise`. This
file is the *only* one with substantial structural cleverness;
the others are thin.

§Related-but-distinct from cycle 66's `handled-promise.js`:
HandledPromise is the *eventual-send* substrate; memoRace is
*memory hygiene*. Both share the §promise-as-substrate
worldview but operate at different layers.

## Related sections

- cycle 66
  [[endo--packages-eventual-send-src-handled-promise-js--handler-protocol]]
  — the HandledPromise substrate that consumes promise-kit's
  primitives.
- cycle 138
  [[endo--packages-pass-style-src-safe-promise-js--safe-promise-definition-with-toStringTag-tolerance-and-node-async-hooks-explicit-allowlist]]
  — defines what a *safe* promise is; this file's *racing*
  shape complements the *definition* shape.
- cycle 142
  [[endo--packages-pass-style-src-passStyle-helpers-js--PASS_STYLE-symbol-typed-as-string-literal-and-confirmTagRecord-factory-for-object-vs-function-tag-records]]
  — duplicates `isPrimitive` (different trade-off); this file
  acknowledges the duplication with §honest-TODO and
  §layering-constraints-block-DRY observation.
- cycle 108
  [[endo--packages-exo-src-exo-makers-js--defineExoClass-defineExoClassKit-and-makeExo-factory-trio]]
  — same coordinated-update commit `e56bf00f` (the
  @endo/harden migration that touched many @endo files
  simultaneously).
