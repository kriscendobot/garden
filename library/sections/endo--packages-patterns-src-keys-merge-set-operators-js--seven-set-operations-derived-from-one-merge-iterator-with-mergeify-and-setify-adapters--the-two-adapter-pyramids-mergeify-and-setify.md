---
section: seven-set-operations-derived-from-one-merge-iterator-with-mergeify-and-setify-adapters
source: endo--packages-patterns-src-keys-merge-set-operators-js
topics: [patterns, marshal]
status: current
title: The two §adapter pyramids — mergeify and setify
parent: endo--packages-patterns-src-keys-merge-set-operators-js--seven-set-operations-derived-from-one-merge-iterator-with-mergeify-and-setify-adapters
---

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
