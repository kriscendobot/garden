---
section: seven-set-operations-derived-from-one-merge-iterator-with-mergeify-and-setify-adapters
source: endo--packages-patterns-src-keys-merge-set-operators-js
topics: [patterns, marshal]
status: current
---

# Seven set operations derived from one merge iterator with mergeify and setify adapters

> *// TODO share more code with keycollection-operators.js.*
>
> — `packages/patterns/src/keys/merge-set-operators.js` line 17

`merge-set-operators.js` (327 lines, Kris Kowal-last-touched
2026-02-24 in commit `e56bf00f`) is the *set-algebra layer* that
sits on top of cycle 120's `keycollection-operators.js`
infrastructure. The §opening TODO comment names the connection
directly: this file *shadows* parts of cycle 120's machinery, and
the author has marked the duplication for future consolidation.

The file's structure is *one merge iterator + seven generic
iterOp folds + two adapter pyramids*. Together they produce 13
exported set operations.

## The §windowResort variant of cycle 120's
generateFullSortedEntries

The §`windowResort(elements, rankCompare, fullCompare)` private
function is the *single-element* (vs `[key, value]`-pair) sister
to cycle 120's `generateFullSortedEntries`. The two functions have
the same shape:

- Assert input is already rank-sorted (`assertRankSorted`)
- Walk the elements; for each, look ahead for same-rank ties
- If the *same-rank run* is length-1 (no ties), emit directly
- Otherwise, sort the run by `fullCompare` and emit via an inner
  iterator
- Enforce uniqueness via `assertNoDuplicates(resorted, fullCompare)`

Two small differences from cycle 120:

1. **Element vs entry**: cycle 120 walks `[key, value]` entries
   (for CopyBag's `[key, count]` and CopyMap's `[key, value]`);
   this file walks bare elements (for CopySet, whose payload is a
   single-element copyArray).

2. **The §raw-JS-iterator escape hatch**:

   ```js
   // This is the raw JS array iterator whose `.next()` method
   // does not harden the IteratorResult, in violation of our
   // conventions. Fixing this is expensive and I'm confident the
   // unfrozen value does not escape this file, so I'm leaving this
   // as is.
   optInnerIterator = resorted[Symbol.iterator]();
   ```

   The §unfrozen-value-does-not-escape-this-file invariant is the
   *cost-of-correctness-vs-confidence* discipline. The author is
   explicit: this is a known deviation from the hardened-iterator
   convention, justified by the closed-scope guarantee. Cycle 120's
   sister file doesn't carry this exact note but uses the
   harden-decorated `makeIterator(...)` helper instead — the
   difference is *correctness-by-construction* (cycle 120) vs
   *correctness-by-closed-scope-confidence* (this cycle).

## The §merge function — the same merge-join algebra, different
output shape

The §`merge(xelements, yelements)` function is the sister to
cycle 120's `generateCollectionPairEntries`. Same merge-join
algebra; different output tuple:

- Cycle 120: `[Key, valueA | absentValue, valueB | absentValue]`
- This cycle: `[T, xCount: bigint, yCount: bigint]` (bigint counts!)

The §bigint-count generalization is the structural anticipation of
CopyBag: *For sets, these counts are always 0 or 1, but this
representation generalizes nicely for bags*. The CopySet
implementation hardwires count to `0n` or `1n`; the same algebra
applied to CopyBags would carry the actual multiplicity. (The
upstream bag sister is `merge-bag-operators.js`.)

The §history-dependent comparator scoping is repeated verbatim from
cycle 120:

```js
// This fullOrder contains history dependent state. It is specific
// to this one `merge` call and does not survive it.
const fullCompare = makeFullOrderComparatorKit().antiComparator;
```

The same *call-local fullOrder* discipline. Same anti-rank +
anti-full-order lift.

The §four-let buffer pattern is repeated:

```js
let x; let xDone;
let y; let yDone;

const xi = xs[Symbol.iterator]();
const nextX = () => {
  !xDone || Fail`Internal: nextX should not be called once done`;
  ({ done: xDone, value: x } = xi.next());
};
nextX();
```

Pre-advance once before the loop; subsequent `nextX()` advances and
records into the buffers. The §`!xDone || Fail` invariant is
unreachable by design.

The §merge loop emits triples per the comparison:

- `xDone && yDone` → done, terminating value `[null, 0n, 0n]` (the
  `// @ts-expect-error Because the terminating value does not
  matter` comment makes the *value-doesn't-matter-when-done*
  contract explicit)
- `xDone` only y left → `[y, 0n, 1n]`, advance y
- `yDone` only x left → `[x, 1n, 0n]`, advance x
- comp === 0 (equivalent) → `[x, 1n, 1n]`, advance both
- comp < 0 → `[x, 1n, 0n]`, advance x
- comp > 0 → `[y, 0n, 1n]`, advance y; the §`comp > 0 ||
  Fail`Internal: Unexpected comp ${q(comp)}`` invariant *exhaust
  the trichotomy* (NaN would fall here; this is the unreachable
  branch).

## The seven §iterOp folds

The file defines seven generic *fold-over-merge-iterator* helpers,
each accepting an `Iterable<[T, bigint, bigint]>` and producing the
operation's result. The seven, with their per-element predicates:

| iterOp | Predicate per element | Output |
|--------|------------------------|--------|
| `iterIsSuperset` | `if (xc === 0n) return false` | boolean (early exit) |
| `iterIsDisjoint` | `if (xc >= 1n && yc >= 1n) return false` | boolean (early exit) |
| `iterCompare` | combine `loneY = xc===0n`, `loneX = yc===0n`; early `NaN` if both | `KeyComparison` (-1 / 0 / 1 / NaN) |
| `iterUnion` | always push `m` | `T[]` (all merged elements) |
| `iterDisjointUnion` | assert no common; push `m` | `T[]` (throws on overlap) |
| `iterIntersection` | push iff `xc >= 1n && yc >= 1n` | `T[]` (common only) |
| `iterDisjointSubtract` | assert x present; push iff `yc === 0n` | `T[]` (left-only after assertion) |

The §iterCompare implementation is the *same Pareto two-flag
pattern* cycle 120's `makeCompareCollection` uses, restricted to
set membership: *something in y not in x* (`loneY`) + *something in
x not in y* (`loneX`) + the §early-exit `if (loneX && loneY) return
NaN` short-circuit. Pareto comparison over set membership.

## The two §adapter pyramids — mergeify and setify

The file closes with two adapter pyramids:

```js
const mergeify = iterOp => (xelements, yelements) =>
  iterOp(merge(xelements, yelements));

export const elementsIsSuperset = mergeify(iterIsSuperset);
export const elementsIsDisjoint = mergeify(iterIsDisjoint);
export const elementsCompare = mergeify(iterCompare);
export const elementsUnion = mergeify(iterUnion);
export const elementsDisjointUnion = mergeify(iterDisjointUnion);
export const elementsIntersection = mergeify(iterIntersection);
export const elementsDisjointSubtract = mergeify(iterDisjointSubtract);

const rawSetify = elementsOp => (xset, yset) =>
  elementsOp(xset.payload, yset.payload);

const setify = elementsOp => (xset, yset) =>
  makeSetOfElements(elementsOp(xset.payload, yset.payload));

export const setIsSuperset = rawSetify(elementsIsSuperset);
export const setIsDisjoint = rawSetify(elementsIsDisjoint);
export const setUnion = setify(elementsUnion);
export const setDisjointUnion = setify(elementsDisjointUnion);
export const setIntersection = setify(elementsIntersection);
export const setDisjointSubtract = setify(elementsDisjointSubtract);
```

The §three-layer factory chain is:

1. **iterOp** — operates on the merge iterator's triple stream;
   pure (no knowledge of CopySet shape).
2. **elementsOp** — `mergeify` adapter; takes raw `T[]` element
   arrays; calls `merge(...)` to build the triple stream.
3. **setOp** — `rawSetify` or `setify` adapter; takes CopySet
   tagged values, unwraps `.payload`, optionally re-wraps via
   `makeSetOfElements(...)`.

The §rawSetify-vs-setify split is structurally important:

- **rawSetify** is for *predicates* (`isSuperset`, `isDisjoint`)
  whose output is `boolean` — no tagged-value reconstruction
  needed.
- **setify** is for *constructors* (`union`, `disjointUnion`,
  `intersection`, `disjointSubtract`) whose output is `T[]` and
  must be re-tagged as a `copySet` via `makeSetOfElements(...)` to
  preserve the *canonical copySet internal form* invariant cycle
  110's `copySet.js` enforces.

Note that `setCompare` is *not* exported via the public surface
here — cycle 104's `compareKeys.js` provides it via the dispatch
table using `makeCompareCollection(getElements, false, ...)` from
cycle 120. The §asymmetry is structurally interesting: `compareKeys`
uses cycle 120's *Pareto-pair-entries* machinery for the dispatch
table; this file's `iterCompare` does the same algebra
*inline-with-the-set-merge-iterator*. The §TODO comment at line 17
flags this duplication for future consolidation.

## *Things to fold over a merge iterator are everywhere*

The §design pattern visible across both keycollection-operators.js
(cycle 120) and merge-set-operators.js (this cycle) is:

1. *Generate a triple stream over the merged collections*
   (`generateCollectionPairEntries` for `[key, valueA, valueB]`;
   `merge` for `[T, xCount, yCount]`).
2. *Run a generic fold over the stream* (the seven iterOps here;
   the leftIsBigger/rightIsBigger fold in cycle 120's
   `makeCompareCollection`).
3. *Adapt the fold's output to the consumer surface* (`mergeify`
   for elementsOp; `setify` for setOp; `setCompare` in
   `compareKeys.js`).

The §abstraction-debt-marker §TODO at line 17 acknowledges that the
*generate-triple-stream* step appears in two files with similar
shape; future consolidation could push the shared work into a
single helper that both bag-merge-operators, set-merge-operators,
and keycollection-operators draw from.

## Pairing with the four prior @endo/patterns/keys/* ingests

Cycle 123 extends the Keys substrate to **six cycle-ingested
files**:

- cycle 102 — `checkKey.js` (kind validation)
- cycle 104 — `compareKeys.js` (dispatch table)
- cycle 110 — `copySet.js` (CopySet shape)
- cycle 115 — `copyBag.js` (CopyBag shape)
- cycle 120 — `keycollection-operators.js` (Pareto-partial-order
  machinery for ordered comparison)
- **cycle 123 (this cycle)** — `merge-set-operators.js`
  (algebraic set operations: union / intersection /
  disjoint-subtract / superset-test / disjoint-test / compare /
  disjoint-union)

The six together cover the Keys substrate's *complete operational
surface*: kind-validation (102), partial-order dispatch (104),
shape (110+115), partial-order pair-merging machinery (120), and
set-algebra (this cycle).

## Related sections

- cycle 120
  [[endo--packages-patterns-src-keys-keycollection-operators-js--pareto-pair-entries-merging-with-anti-rank-tie-breaking-for-collection-comparison]]
  — the *Pareto-partial-order pair-entries machinery* that this
  file's §opening TODO marks as the consolidation target.
- cycle 110
  [[endo--packages-patterns-src-keys-copyset-js--copyset-as-key-with-5-layer-validation-and-key-significance-over-value]]
  — the CopySet shape this file's `setify(makeSetOfElements)`
  adapter re-tags into.
- cycle 104
  [[endo--packages-patterns-src-keys-compareKeys-js--keycomparison-with-pareto-partial-order-and-nan-incommensurability]]
  — the dispatch table that calls cycle 120's
  `makeCompareCollection` to produce setCompare *rather than*
  using this file's `iterCompare` directly.
- cycle 115
  [[endo--packages-patterns-src-keys-copybag-js--copybag-as-key-with-5-layer-validation-and-key-significance-over-value]]
  — the bag sister whose own merge-bag-operators.js mirrors this
  file's structure with non-binary multiplicities.
