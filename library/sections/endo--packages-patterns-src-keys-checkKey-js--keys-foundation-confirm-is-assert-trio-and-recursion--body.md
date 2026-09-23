---
title: Body
source: packages/patterns/src/keys/checkKey.js
source_repo: endojs/endo
source_branch: master
source_commit: beab78998642c19d9420ec5bc819a6545327fa5e
source_date: 2026-04-22
source_authors: [Turadg Aleahmad]
source_lines: "1-103, 483-544 (Atom/Scalar entry + Keys with memoization + the late-file confirmKeyInternal recursion)"
topics: [hardened-javascript, patterns]
status: current
notes: |
  Thirteenth comment-fragment ingest. Turadg Aleahmad-authored
  Keys-foundation surface of @endo/patterns. The file defines the
  *Confirm/Is/Assert trio* pattern that every key-shaped check
  follows: one underlying `confirmX(val, reject)` boolean predicate
  with an optional Rejector that doubles as `false` (silent boolean
  return) or `Fail` (throw with diagnostic). Three structural ideas:
  (1) the §Rejector-as-dual-mode parameter — the same internal
  function services *isX* (silent) and *assertX* (throw) without
  duplication; (2) the §`keyMemo` WeakSet with the *don't memoize
  negatives* discipline — caching positives speeds up repeated key
  checks; caching negatives would silence the diagnostic on a
  later `assertX` retry; (3) the §`hideAndHardenFunction` discipline
  applied to all is/assert exports so the function name doesn't
  leak as a privileged identifier through `.name`. The §recursion
  in `confirmKeyInternal` dispatches on passStyle with explicit
  `error`/`promise` rejection paths and an *unexpected passStyle
  throws* discipline that preserves the *unexpected-state-is-bug*
  trichotomy. Pairs structurally with the §cycle 84 rankOrder.js
  ingest (Mark Miller-authored marshal sister surface) and the
  §cycle 87 pass-style/error.js ingest (the underlying passStyle
  validation that this module's `passStyleOf` calls).
parent: endo--packages-patterns-src-keys-checkKey-js--keys-foundation-confirm-is-assert-trio-and-recursion
---

### §The Confirm/Is/Assert trio pattern

The §opening Atom/Scalar block (lines 21-53) introduces the *Confirm/Is/Assert trio* pattern that every key-shaped check follows. The §three functions for the *ScalarKey* notion:

```js
export const confirmScalarKey = (val, reject) => {
  if (isAtom(val)) return true;
  const passStyle = passStyleOf(val);
  if (passStyle === 'remotable') return true;
  return reject && reject`A ${q(passStyle)} cannot be a scalar key: ${val}`;
};

export const isScalarKey = val => confirmScalarKey(val, false);
hideAndHardenFunction(isScalarKey);

export const assertScalarKey = val => {
  confirmScalarKey(val, Fail);
};
hideAndHardenFunction(assertScalarKey);
```

The §three-function shape:

- **`confirmX(val, reject)`** — the underlying boolean predicate. Returns `true` for the positive case; returns `reject && reject\`diagnostic\`` for the negative case. The `Rejector` parameter is a callable, `false`, or `Fail`.
- **`isX(val)`** — silent boolean form via `confirmX(val, false)`. The `reject && reject\`...\`` expression short-circuits to `false` when `reject` is `false`.
- **`assertX(val)`** — throw-on-failure form via `confirmX(val, Fail)`. When the predicate returns `Fail\`diagnostic\``, the `Fail` tagged-template throws.

The §design discipline: *one internal predicate, three external entry points*. No duplication. The `Rejector` parameter is the *single discriminator* between silent and throwing modes.

The §`Rejector` parameter (imported from `@endo/errors/rejector.js`) is documented as a callable-or-false. The §callable case lets a test framework substitute a *collecting* rejector that captures diagnostics without throwing — useful for testing the diagnostic messages without testing the throwing behavior.

### §The `hideAndHardenFunction` discipline

The §three is/assert functions (`isScalarKey`, `assertScalarKey`, `isKey`, `assertKey`, etc.) are wrapped with `hideAndHardenFunction` (imported from `@endo/errors`):

```js
hideAndHardenFunction(isScalarKey);
```

The §discipline: *the function's `.name` doesn't leak the SES-identifier name*. By default a function expression assigned to `export const isScalarKey = ...` would carry `name: 'isScalarKey'`. Code holding a reference to the function could `fn.name` and observe `'isScalarKey'` — which could be used to construct an authority-relevant lookup or pattern match.

The §`hideAndHardenFunction` removes the name and freezes the function. The §note: only the *publicly-named* functions get this treatment. The internal `confirmX(val, reject)` functions get the plain `harden()` since they aren't exported under their own name (they're consumed via the is/assert wrappers).

The §pattern is reusable for any *public-API function whose name should not be observable through its identity*. The discipline matters more for capability-confined code that might use function-name as an authority discriminator.

### §The `keyMemo` WeakSet with don't-memoize-negatives

The §Keys section (lines 55-103) defines the general `Key` notion with memoization:

```js
// Non-atom Keys are memoized. Atom keys are handled by the early return
// in confirmKey and cannot inhabit a WeakSet.
/** @type {WeakSet<Exclude<Key, Atom | void>>} */
const keyMemo = new WeakSet();
```

The §two-line comment names two interleaved disciplines:

- **Non-atom keys are memoized** — repeated `confirmKey` calls on the same non-atom value short-circuit via the WeakSet.
- **Atom keys cannot inhabit a WeakSet** — atoms (strings, numbers, bigints, booleans, undefined, null, symbols, registered symbols) are primitive-typed and can't be WeakSet keys. They get an early return in `confirmKey`.

The §`confirmKey` body (lines 67-84):

```js
export const confirmKey = (val, reject) => {
  if (isAtom(val)) return true;
  if (keyMemo.has(/** @type {Exclude<Key, Atom | void>} */ (val))) return true;
  const result = confirmKeyInternal(val, reject);
  if (result) {
    // Don't cache the undefined cases, so that if it is tried again
    // with `Fail` it'll throw a diagnostic again
    keyMemo.add(/** @type {Exclude<Key, Atom | void>} */ (val));
  }
  // Note that we must not memoize a negative judgement, so that if it is tried
  // again with `Fail`, it will still produce a useful diagnostic.
  return result;
};
```

The §three-phase check:

1. **Atom early return** — primitive types can't be hardened and can't inhabit a WeakSet; they're either trivially keys (numbers, strings, symbols) or trivially not (but `isAtom` handles both — the atoms-that-are-keys subset of all atoms).
2. **Memo lookup** — non-atom keys that were previously confirmed get an O(1) short-circuit.
3. **Recursive descent + memoize-positive-only** — call `confirmKeyInternal`; if it returns truthy, add to memo; otherwise return the original result (which may be `false` from silent-mode or have thrown from `Fail`-mode).

The §*don't memoize negatives* discipline is structurally significant. Two scenarios:

- **First call with `false` rejector** → silent boolean `false`. If we memoized this, the value would be remembered as *not a key*.
- **Later call with `Fail` rejector** → if memoized-as-negative, we'd return `false` again (silent). But the caller wants the diagnostic.

The §discipline ensures the second call *re-runs the predicate* and the `Fail`-rejector path executes, producing the diagnostic. The §performance trade-off is *intentional*: positive judgements are common-and-stable (the same value is checked many times in a session); negative judgements are *less common-and-want-diagnostic* (often the negative is an error path the caller wants to attribute).

### §The `confirmKeyInternal` recursion-on-passStyle

The §`confirmKeyInternal` (lines 483-544) is the recursive descent. It is called only after `confirmKey` has determined that `val` is not an atom:

```js
const confirmKeyInternal = (val, reject) => {
  const checkIt = child => confirmKey(child, reject);

  const passStyle = passStyleOf(val);
  switch (passStyle) {
    case 'remotable': {
      return true; // ScalarKey corner case; remotable not an atom
    }
    case 'copyRecord': {
      return Object.values(val).every(checkIt);
    }
    case 'copyArray': {
      return val.every(checkIt);
    }
    case 'tagged': {
      const tag = getTag(val);
      switch (tag) {
        case 'copySet': return confirmCopySet(val, reject);
        case 'copyBag': return confirmCopyBag(val, reject);
        case 'copyMap': return (
          confirmCopyMap(val, reject) &&
          everyCopyMapValue(val, checkIt)
        );
        default: return (
          reject && reject`A passable tagged ${q(tag)} is not a key: ${val}`
        );
      }
    }
    case 'error':
    case 'promise': {
      return reject && reject`A ${q(passStyle)} cannot be a key`;
    }
    default: {
      throw Fail`unexpected passStyle ${q(passStyle)}: ${val}`;
    }
  }
};
```

The §dispatch table:

| passStyle | Handling | Diagnostic shape |
|---|---|---|
| `remotable` | trivially a key | (positive) |
| `copyRecord` | recurse on `Object.values` | (per-value diagnostic) |
| `copyArray` | recurse on each element | (per-element diagnostic) |
| `tagged: 'copySet'` | delegate to `confirmCopySet` | (set-specific) |
| `tagged: 'copyBag'` | delegate to `confirmCopyBag` | (bag-specific) |
| `tagged: 'copyMap'` | delegate to `confirmCopyMap` + recurse on values | (map-specific + per-value) |
| `tagged: <other>` | not a key | `A passable tagged X is not a key` |
| `error` | not a key | `An error cannot be a key` |
| `promise` | not a key | `A promise cannot be a key` |
| `<unexpected>` | **throw** | `unexpected passStyle X: <val>` |

The §*unexpected passStyle throws* discipline is structurally significant. The §comment names the trichotomy:

> Unexpected tags are just non-keys, but an unexpected passStyle is always an error.

The §three categories:

- **Expected positives** — `remotable`, `copyRecord`, `copyArray`, the three known tagged types — get the standard predicate.
- **Expected negatives** — `error`, `promise`, unexpected `tagged: X` — reject with diagnostic (return `false` if silent; throw if `Fail`).
- **Unexpected state** — a `passStyle` value not in the above list — *always throws*, ignoring the `reject` parameter.

The §*unexpected-state-is-bug* trichotomy is the canonical *expected vs unexpected* discipline. A new passStyle would mean the pass-style enumeration has expanded; this module needs updating. Throwing surfaces the gap immediately; returning silently would mask the missing case.

### §The CopyMap recursion subtlety

The §`copyMap` tag case has a subtle two-step:

```js
case 'copyMap': {
  return (
    confirmCopyMap(val, reject) &&
    everyCopyMapValue(val, checkIt)
  );
}
```

The §two checks:

1. **`confirmCopyMap`** — validates the copyMap *structure* (it's a `tagged` with tag `copyMap`; its payload is a copyRecord with `keys` + `values` arrays and nothing else; keys are themselves keys; same number of keys and values).
2. **`everyCopyMapValue` recursion** — *additionally* checks that every *value* is itself a key.

The §comment in the source explains:

> For a copyMap to be a key, all its keys and values must be keys. Keys already checked by `confirmCopyMap` since that's a copyMap requirement in general.

The §discipline: a copyMap *as a structure* requires its keys to be keys (you can't have non-key keys); but a copyMap as a *Key value* additionally requires its values to be keys (so the whole map is itself eligible for use as a key in another collection). The two requirements are layered.

### §The Rejector-doubles-as-false short-circuit

The §canonical idiom across all confirm functions:

```js
return reject && reject`A ${q(passStyle)} cannot be a scalar key: ${val}`;
```

The §two-step short-circuit:

- **`reject` is `false`** → the `&&` short-circuits to `false`. No diagnostic constructed; no call to the tagged template.
- **`reject` is `Fail` (or a callable)** → evaluate `reject\`A ${q(passStyle)} cannot be...\``. The template-tag call constructs the diagnostic; if `reject` is `Fail`, it throws; if `reject` is a test-collecting callable, it captures.

The §performance benefit: silent-mode (`isX`) doesn't pay the diagnostic-construction cost. The §correctness benefit: assert-mode (`assertX`) gets the full diagnostic with the actual `val` and `passStyle` substituted.

The §pattern is reusable for any *predicate-with-optional-diagnostic* check. The single-parameter dual-mode discipline cleanly separates the *judgement* logic from the *reporting* logic.
