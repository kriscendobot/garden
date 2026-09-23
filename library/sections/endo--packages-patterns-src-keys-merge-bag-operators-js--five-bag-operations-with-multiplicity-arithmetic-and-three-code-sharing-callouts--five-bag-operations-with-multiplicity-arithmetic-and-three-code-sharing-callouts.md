---
section: five-bag-operations-with-multiplicity-arithmetic-and-three-code-sharing-callouts
source: endo--packages-patterns-src-keys-merge-bag-operators-js
topics: [patterns, marshal]
status: current
title: Five bag operations with multiplicity arithmetic and three code-sharing callouts
parent: endo--packages-patterns-src-keys-merge-bag-operators-js--five-bag-operations-with-multiplicity-arithmetic-and-three-code-sharing-callouts
---

> *// Based on merge-set-operators.js, but altered for the bag
> representation.*
> *// TODO share more code with that file and
> keycollection-operators.js.*
>
> — `packages/patterns/src/keys/merge-bag-operators.js` lines 16-17

`merge-bag-operators.js` (291 lines, Kris Kowal-last-touched
2026-02-24 in commit `e56bf00f` — same author and commit as
cycles 108, 110, 115, 118, 123) is the *bag-algebra layer* sister
to cycle 123's `merge-set-operators.js`. Structurally near-
identical but with *bag-specific multiplicity arithmetic*. The
file makes the *abstraction-debt-marker* discipline visible with
*three* explicit code-sharing comments — one file-level, two
per-function.
