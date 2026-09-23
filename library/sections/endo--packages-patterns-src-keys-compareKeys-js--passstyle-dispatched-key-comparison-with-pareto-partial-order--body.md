---
title: Body
source: packages/patterns/src/keys/compareKeys.js
source_repo: endojs/endo
source_branch: master
source_commit: c63b8b709ecb25a32469f5eae1003a719c7f3608
source_date: 2026-03-26
source_authors: [Turadg Aleahmad]
source_lines: "1-265 (full file)"
topics: [hardened-javascript, patterns]
status: current
notes: |
  Fourteenth comment-fragment ingest. Sister file to cycle 102's
  checkKey.js (same author, same package, same shared idioms).
  Where checkKey.js defines the *Confirm/Is/Assert trio* validation
  pattern, this file defines the *partial-order comparison* surface
  for keys + collections. Four structurally interesting moves:
  (1) the *partial-order vs total-order* distinction — keys form a
  *partial order* (some pairs are incommensurate, signaled by `NaN`)
  unlike rank order which is a *total order* (every pair has a
  defined comparison); (2) the *Pareto-partial-order* algorithm for
  copyRecord comparison — same property set required; element-wise
  comparison must all-go-the-same-direction-or-be-equal else NaN;
  (3) the *ABSENT Symbol sentinel* unused-but-preserved scaffolding
  for the future copyMap-comparison decision, with a TODO that
  *names the cross-reference* (endo PR #1737 review thread); (4) the
  *number NaN special case* — NaN === NaN compares as 0 in this
  module (NaN is equal to itself) but NaN vs any non-NaN number
  returns NaN (incommensurate). Single-section cohesion-honest ingest
  (like cycle 103) — the 264-line file is *one comparison surface*
  with specialized handling per passStyle, plus the five-predicate
  wrapper suite.
parent: endo--packages-patterns-src-keys-compareKeys-js--passstyle-dispatched-key-comparison-with-pareto-partial-order
---

### §The partial-order vs total-order distinction

The §central structural fact: *keys form a partial order, not a total order*. Some key pairs are *incommensurate* — neither is smaller, neither is larger, neither is equal. The `NaN` return value signals incommensurability.

The §contrast with rank order: rank order (defined in `endo/marshal/rankOrder.js`, cycle 84) is a *total order* — every pair has a defined comparison result (`-1`, `0`, or `1`). Rank order exists to support sorting and range-searching; key order exists to support *key equality and partial-order reasoning* (e.g., *is this CopySet a subset of that one*).

The §incommensurate cases (returning NaN):

- **Different passStyles** — `compareKeys(42, 'foo')` returns NaN. A number and a string have no comparison relationship as keys.
- **NaN vs non-NaN number** — `compareKeys(NaN, 3)` returns NaN. NaN's IEEE-754 self-inequality is preserved at the rank-order layer, but special-cased here for *NaN is equal to itself*.
- **Non-identical remotables** — `compareKeys(remoteA, remoteB)` returns NaN unless `remoteA === remoteB`. Remotables are *opaque to comparison except by reference identity*.
- **copyRecords with different property sets** — `compareKeys({a:1, b:2}, {a:1, c:3})` returns NaN. Pareto-partial-order requires the same axes.
- **copyRecords with mixed-direction values** — `compareKeys({a:1, b:5}, {a:2, b:3})` returns NaN. Some properties go one way; others go the other way; no global direction.
- **Tagged with different tags** — `compareKeys(copySet, copyBag)` returns NaN. Different tags are *incommensurate as keys*.

The §`Number.isNaN`-aware partial-order discipline is the canonical pattern for *some-pairs-are-incommensurate*. The §callers must handle NaN explicitly — `compareKeys(x, y) < 0` is *false for incommensurate pairs*; `compareKeys(x, y) === NaN` (or `Number.isNaN(...)`) is the test for incommensurability.

### §The setCompare / bagCompare collection-comparison factories

The §setCompare (lines 22-42):

```js
/**
 * CopySet X is smaller than CopySet Y iff all of these conditions hold:
 * 1. For every x in X, x is also in Y.
 * 2. There is a y in Y that is not in X.
 *
 * X is equivalent to Y iff the condition 1 holds but condition 2 does not.
 */
export const setCompare = makeCompareCollection(
  collection => harden(getCopySetKeys(collection).map(key => [key, 1])),
  0,
  compareNumerics,
);
```

The §three parameters to `makeCompareCollection`:

- **`getEntries`** — a function that maps the collection to `Array<[Key, value]>` entries.
- **`defaultValue`** — the value for absent keys (for sets, `0` means *count-absent-is-zero*).
- **`compareValues`** — the comparator for values (here `compareNumerics`).

The §discipline: *set comparison reduces to multi-set comparison with all counts being 1*. The §`getCopySetKeys(collection).map(key => [key, 1])` shape produces uniform `[key, 1]` entries; the makeCompareCollection logic then handles the rest.

The §JSDoc names the subset semantics:

- *X is smaller than Y* iff X is a proper subset of Y.
- *X is equivalent to Y* iff X is exactly Y (same elements).

The §bagCompare (lines 44-59):

```js
/**
 * CopyBag X is smaller than CopyBag Y iff all of these conditions hold:
 * 1. For every x in X, x is also in Y and count(X, x) <= count(Y, x).
 * 2. There is a y in Y such that y is not in X or count(X, y) < count(Y, y).
 */
export const bagCompare = makeCompareCollection(
  collection => getCopyBagEntries(collection),
  0n,
  compareNumerics,
);
```

The §differences from setCompare:

- **Default value is `0n`** (bigint zero) instead of `0` (number zero) — bag counts are bigints.
- **`getCopyBagEntries`** returns the raw `Array<[Key, bigint]>` (no `.map` needed since the entries already have counts).

The §multi-set semantics:

- *X is smaller than Y* iff X is a proper sub-multi-set of Y (every count in X ≤ count in Y; at least one strictly smaller or absent).
- *X is equivalent to Y* iff X is exactly Y (same multi-set).

### §The ABSENT Symbol sentinel and the unused _mapCompare

The §unused-but-preserved `_mapCompare` (lines 61-104) carries scaffolding for the future copyMap-comparison decision. The §opening TODO:

> The desired semantics for CopyMap comparison have not yet been decided. See https://github.com/endojs/endo/pull/1737#pullrequestreview-1596595411 The below is a currently-unused extension of CopyBag semantics (i.e., absent entries treated as present with a value that is smaller than everything).

The §ABSENT sentinel (lines 65-71):

```js
/**
 * A unique local value that is guaranteed to not exist in any inbound data
 * structure (which would not be the case if we used `Symbol.for`).
 * Note that `ABSENT` is not passable, and so only exists at the JS level of
 * abstraction, not pass-style.
 */
const ABSENT = Symbol('absent');
```

The §two structural commitments:

- **`Symbol('absent')` not `Symbol.for('absent')`** — `Symbol.for` interns the symbol in the global registry, making it *the same symbol* across compartments. A `Symbol(...)` constructor produces a *unique* symbol scoped to this module. The discipline ensures `ABSENT` *cannot collide* with any inbound data.
- **`ABSENT` is not passable** — pass-style only permits registered symbols. The `Symbol('absent')` is at *the JS abstraction level* but cannot cross compartment boundaries. The discipline keeps `ABSENT` as a private sentinel.

The §value-comparator that handles ABSENT (lines 88-103):

```js
(leftValue, rightValue) => {
  if (leftValue === ABSENT && rightValue === ABSENT) {
    throw Fail`Internal: Unexpected absent entry pair`;
  } else if (leftValue === ABSENT) {
    return -1;
  } else if (rightValue === ABSENT) {
    return 1;
  } else {
    return compareKeys(leftValue, rightValue);
  }
}
```

The §three-branch dispatch:

- **Both absent** — *internal error*. The makeCompareCollection layer shouldn't produce this case; if it does, we have a bug.
- **Only left absent** — `left < right` (absent is smaller).
- **Only right absent** — `left > right` (present is larger).
- **Both present** — recursive `compareKeys` on the values.

The §discipline: *the unused scaffolding documents the semantic the author favors*. If the project ever decides to implement copyMap comparison, this is the algorithm the codebase has prepared.

The §honest-deferral via TODO + cross-reference is the canonical *named-dependency-in-todo* shape: the maintainer reading the code can follow the link to the PR review thread to understand why the decision is pending.

### §compareKeys main function — passStyle dispatch

The §compareKeys function (lines 106-249) is the centerpiece. The §opening (lines 107-115):

```js
export const compareKeys = (left, right) => {
  assertKey(left);
  assertKey(right);
  const leftStyle = passStyleOf(left);
  const rightStyle = passStyleOf(right);
  if (leftStyle !== rightStyle) {
    // Different passStyles are incommensurate
    return NaN;
  }
  // ...switch on leftStyle...
};
```

The §three opening steps:

1. **`assertKey(left)` + `assertKey(right)`** — input validation. Both arguments must be valid Keys (the `confirmKey` predicate from checkKey.js with `Fail` mode).
2. **`passStyleOf` both sides** — get the canonical passStyle.
3. **Cross-style → NaN early return** — different passStyles are *incommensurate*.

The §dispatch on `leftStyle`:

| passStyle | Comparison | Notes |
|---|---|---|
| `undefined`/`null`/`boolean`/`bigint`/`string`/`byteArray`/`symbol` | `compareRank(left, right)` | Key order = rank order for these atomic types. |
| `number` | `compareRank` with NaN special-case | NaN is equal to itself in *key* sense; NaN vs non-NaN returns NaN. |
| `remotable` | `left === right ? 0 : NaN` | Identity-only; non-identical remotables are incommensurate. |
| `copyArray` | Lexicographic with length-tiebreak | Prefix is smaller. |
| `copyRecord` | Pareto partial order | Same property sets required; mixed directions → NaN. |
| `tagged: 'copySet'` | `setCompare(left, right)` | Set inclusion. |
| `tagged: 'copyBag'` | `bagCompare(left, right)` | Multi-set inclusion. |
| `tagged: 'copyMap'` | `throw Fail\`Map comparison not yet implemented\`` | Honest-not-implemented; matches the §TODO above. |
| `tagged: <other>` | `throw Fail\`unexpected tag\`` | Unexpected tag throws. |
| `<unexpected passStyle>` | `throw Fail\`unexpected passStyle\`` | Unexpected passStyle throws (matches checkKey.js discipline). |

### §The number NaN special-case

The §number branch (lines 127-140):

```js
case 'number': {
  const rankComp = compareRank(left, right);
  if (rankComp === 0) {
    return 0;
  }
  if (Number.isNaN(left) || Number.isNaN(right)) {
    // NaN is equal to itself, but incommensurate with everything else
    assert(!Number.isNaN(left) || !Number.isNaN(right));
    return NaN;
  }
  // Among non-NaN numbers, key order is the same as rank order. Note that
  // in both orders, `-0` is in the same equivalence class as `0`.
  return rankComp;
}
```

The §three-step logic:

1. **If `compareRank` says equal (`0`)** → return `0`. This handles NaN-vs-NaN (which rank-order treats as equal because rank order is *deliberately self-equal for NaN*); also handles `-0 === 0` (both `0` and `-0` are in the same rank-order equivalence class).
2. **If either is NaN (and ranks weren't equal)** → return NaN. The §assertion confirms *exactly one* is NaN (since rank-equal-NaN was handled above). One-sided NaN is *incommensurate*.
3. **Otherwise (both non-NaN, ranks differ)** → return the rank comparison directly.

The §IEEE-754-vs-key-semantics: in IEEE-754, `NaN !== NaN` returns true (NaN is incommensurate with itself). In *key* semantics, NaN is *equal to itself* because keys must support reflexive equality (a Key must equal itself for use in sets/maps). The §discipline: at the rank-order layer, NaN-equals-NaN is enforced; this module inherits that and adds the NaN-vs-non-NaN → NaN clarification.

The §`-0` vs `0` invariant: in rank order, `-0` and `0` are in the same equivalence class. The §comment names this explicitly. This means `compareKeys(0, -0)` returns `0` — they are key-equal even though `Object.is(0, -0)` returns false.

### §The copyRecord Pareto partial order

The §copyRecord branch (lines 168-215):

```js
case 'copyRecord': {
  const leftNames = recordNames(left);
  const rightNames = recordNames(right);

  if (!keyEQ(leftNames, rightNames)) {
    return NaN;
  }
  const leftValues = recordValues(left, leftNames);
  const rightValues = recordValues(right, rightNames);
  let result = 0;
  for (let i = 0; i < leftValues.length; i += 1) {
    const comp = compareKeys(leftValues[i], rightValues[i]);
    if (Number.isNaN(comp)) {
      return NaN;
    }
    if (result !== comp && comp !== 0) {
      if (result === 0) {
        result = comp;
      } else {
        assert(
          (result === -1 && comp === 1) || (result === 1 && comp === -1),
        );
        return NaN;
      }
    }
  }
  return result;
}
```

The §Pareto-partial-order algorithm:

1. **Property-set equality required**. If `leftNames !== rightNames` (as sorted arrays), the records are *incommensurate*. Different property sets means they're *different shapes*; no comparison is meaningful.
2. **Value-by-value comparison**. For each property (in sorted-property-name order), compare the left/right values.
3. **Mixed-direction detection**. The running `result` is `0` initially; each property's `comp` updates it:
   - **`comp === 0`** (equal at this property) → no change to `result`.
   - **`result === 0`** (no direction yet) → set `result` to `comp`. The first non-zero comparison establishes the direction.
   - **`result === comp`** (same direction) → no change.
   - **`result !== comp` and both non-zero** → mixed directions → return NaN.
4. **Return `result`**. If all comparisons agreed (or were equal), the running result is the overall direction.

The §Pareto-partial-order semantics: *X ≤ Y iff for every property, X.prop ≤ Y.prop, and at least one is strictly smaller*. Mixed directions (some properties going one way, others another) make the records *incommensurate*.

The §comment on rank-order alignment:

> If copyRecord X is smaller than copyRecord Y, then they must have the same property names and every value in X must be smaller or equal to the corresponding value in Y (with at least one value smaller). The rank order of X and Y is based on lexicographic rank order of their values, as organized by reverse lexicographic order of their property names. Thus if compareKeys(X,Y) < 0 then compareRank(X,Y) < 0.

The §discipline: *the key order is a refinement of the rank order*. If two records compare as `compareKeys(X,Y) < 0` (key-smaller), then `compareRank(X,Y) < 0` (rank-smaller) follows. The §implication: code that sorts records by rank order also yields a *valid topological order* for the key-partial-order. The two orderings are *consistent*; key order is just *more partial*.

### §The copyArray lexicographic-with-prefix-shorter rule

The §copyArray branch (lines 149-167):

```js
case 'copyArray': {
  const len = Math.min(left.length, right.length);
  for (let i = 0; i < len; i += 1) {
    const result = compareKeys(left[i], right[i]);
    if (result !== 0) {
      return result;
    }
  }
  return compareRank(left.length, right.length);
}
```

The §discipline:

- **Element-by-element comparison up to the shorter length**. The first differing element determines the result.
- **If all matching elements are equal, the shorter array is smaller**. `compareRank(left.length, right.length)` returns `-1` if `left.length < right.length`, `0` if equal, `1` if longer.

The §design intent: *array X is a prefix of array Y → X is smaller than Y*. Lexicographic ordering with the prefix-is-smaller rule matches string-comparison conventions.

The §key-vs-rank invariant: the comment notes *Rank order of arrays is lexicographic by rank order*. So if `compareKeys(a, b) < 0` (key-smaller via element comparisons), then `compareRank(a, b) < 0` (rank-smaller, since the element-wise key-smaller-or-equal extends to rank-smaller-or-equal). The §element-wise alignment is the bridge.

### §The remotable identity-only rule

The §remotable branch (lines 141-148):

```js
case 'remotable': {
  if (left === right) {
    return 0;
  }
  return NaN;
}
```

The §two-case rule:

- **`left === right`** → return `0`. Identical remotables are *key-equal*.
- **`left !== right`** → return NaN. Non-identical remotables are *incommensurate as keys*.

The §discipline: *remotables are opaque to comparison except by reference identity*. The §rationale: remotables represent capabilities; capabilities don't have a *value semantics* they can be compared on. Two remotables might point to *the same logical entity* (e.g., two facets of the same exo) but still not be `===`; the comparison cannot distinguish *same entity, different facet* from *different entities entirely*.

The §contrast with rank order: rank order does compare remotables (it imposes a *first-seen-position* total order via `makeFullOrderComparatorKit`). Key order is *much stricter* — only identity counts.

### §The five-comparator predicate suite

The §five predicates (lines 251-264):

```js
export const keyLT = (left, right) => compareKeys(left, right) < 0;
export const keyLTE = (left, right) => compareKeys(left, right) <= 0;
export const keyEQ = (left, right) => compareKeys(left, right) === 0;
export const keyGTE = (left, right) => compareKeys(left, right) >= 0;
export const keyGT = (left, right) => compareKeys(left, right) > 0;
```

The §five predicates wrap `compareKeys` with the standard comparison operators:

| Predicate | Definition | Note for NaN (incommensurate) |
|---|---|---|
| `keyLT(x, y)` | `compareKeys < 0` | `NaN < 0` is `false` |
| `keyLTE(x, y)` | `compareKeys <= 0` | `NaN <= 0` is `false` |
| `keyEQ(x, y)` | `compareKeys === 0` | `NaN === 0` is `false` |
| `keyGTE(x, y)` | `compareKeys >= 0` | `NaN >= 0` is `false` |
| `keyGT(x, y)` | `compareKeys > 0` | `NaN > 0` is `false` |

The §discipline: *all five predicates return `false` for incommensurate pairs*. The §implication: `keyEQ(x, x)` is *not always true* — it's true only for non-NaN comparable pairs, and a comparison that returns NaN (e.g., a remotable that isn't === to itself, which can't happen, or copyRecords with different property sets) returns false from all five.

The §rationale: the predicate semantics is *all-five-false-when-incommensurate*. Callers wanting *equivalent or incommensurate* should use `!keyLT(x, y) && !keyGT(x, y)` (which is true for both equality and incommensurability).

The §pattern of *five-comparator-wrapper-suite* is reusable for any partial-order surface where the result needs to be exposed as boolean predicates.
