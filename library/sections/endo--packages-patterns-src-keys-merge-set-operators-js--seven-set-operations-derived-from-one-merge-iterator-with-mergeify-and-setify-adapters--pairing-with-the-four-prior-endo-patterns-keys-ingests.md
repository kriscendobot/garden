---
section: seven-set-operations-derived-from-one-merge-iterator-with-mergeify-and-setify-adapters
source: endo--packages-patterns-src-keys-merge-set-operators-js
topics: [patterns, marshal]
status: current
title: Pairing with the four prior @endo/patterns/keys/* ingests
parent: endo--packages-patterns-src-keys-merge-set-operators-js--seven-set-operations-derived-from-one-merge-iterator-with-mergeify-and-setify-adapters
---

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
