---
section: five-bag-operations-with-multiplicity-arithmetic-and-three-code-sharing-callouts
source: endo--packages-patterns-src-keys-merge-bag-operators-js
topics: [patterns, marshal]
status: current
title: Keys substrate now spans seven cycle-ingested files
parent: endo--packages-patterns-src-keys-merge-bag-operators-js--five-bag-operations-with-multiplicity-arithmetic-and-three-code-sharing-callouts
---

Cycle 125 extends the Keys substrate to **seven files**:

- cycle 102 — `checkKey.js` (kind validation)
- cycle 104 — `compareKeys.js` (partial-order dispatch table)
- cycle 110 — `copySet.js` (CopySet shape)
- cycle 115 — `copyBag.js` (CopyBag shape)
- cycle 120 — `keycollection-operators.js` (Pareto-partial-order
  pair-merging machinery)
- cycle 123 — `merge-set-operators.js` (set-algebra layer)
- **cycle 125 (this cycle)** — `merge-bag-operators.js`
  (bag-algebra layer with multiplicity arithmetic)

The seven cover the substrate's complete *operational surface in
both the set and bag dimensions*: kind-validation, partial-order
dispatch, shape (set + bag), partial-order pair-merging
machinery, set-algebra, bag-algebra.
