---
section: seven-set-operations-derived-from-one-merge-iterator-with-mergeify-and-setify-adapters
source: endo--packages-patterns-src-keys-merge-set-operators-js
topics: [patterns, marshal]
status: current
title: Seven set operations derived from one merge iterator with mergeify and setify adapters
parent: endo--packages-patterns-src-keys-merge-set-operators-js--seven-set-operations-derived-from-one-merge-iterator-with-mergeify-and-setify-adapters
---

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
