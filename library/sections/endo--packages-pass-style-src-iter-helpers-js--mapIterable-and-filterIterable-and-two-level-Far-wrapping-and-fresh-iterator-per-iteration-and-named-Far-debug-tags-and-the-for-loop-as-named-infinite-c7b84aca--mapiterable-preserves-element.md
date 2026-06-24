---
title: §mapIterable preserves element count + termination
source-slug: endo--packages-pass-style-src-iter-helpers-js
section-slug: mapIterable-and-filterIterable-and-two-level-Far-wrapping-and-fresh-iterator-per-iteration-and-named-Far-debug-tags-and-the-for-loop-as-named-infinite-loop-form
source-url: https://github.com/endojs/endo/blob/master/packages/pass-style/src/iter-helpers.js
source-repo: endojs/endo
source-path: packages/pass-style/src/iter-helpers.js
source-author: Endo project (collective)
total-lines: 60
ingest-cycle: 274
ingest-date: 2026-06-10
lane: chat
parent: endo--packages-pass-style-src-iter-helpers-js--mapIterable-and-filterIterable-and-two-level-Far-wrapping-and-fresh-iterator-per-iteration-and-named-Far-debug-tags-and-the-for-loop-as-named-infinite-loop-form
---

Lines 4-9 (the JSDoc):
> *The result iterator has as many elements as the `baseIterator` and have the same termination — the same completion value or failure reason. But the non-final values are the corresponding non-final values from `baseIterator` as transformed by `func`.*

§First-explicit-observation in library: **§element-count-and-termination-shape-preservation-as-named-iterator-contract — §the-result-iterator-has-the-same-number-of-elements + §the-same-termination-shape (completion-value or failure-reason) + §only-the-non-final-values-differ**.

§Two-named-termination-kinds (completion-value + failure-reason) — §sibling-pattern to many iterator protocols that have a single "done" state but where the "done"-value can carry payload (the iterator return-value); §the-design-distinguishes-these-explicitly.

§Lines 22-24 (the mapIterable's next):
```js
const { value: baseValue, done } = baseIterator.next();
const value = done ? baseValue : func(baseValue);
return harden({ value, done: !!done });
```

§The-`done ? baseValue : func(baseValue)`-discriminator — §when-done-pass-the-baseValue-through-unchanged + §when-not-done-apply-the-mapping-function; §the-termination-value-IS-NOT-transformed (it's the iterator's completion signal, not a regular element).

§First-explicit-observation in library: **§the-discriminator-`done ? baseValue : func(baseValue)`-IS-the-named-termination-aware-transformation — §the-termination-value-IS-preserved-not-transformed + §only-the-non-final-values-flow-through-`func`**.

§The-`!!done`-boolean-coercion-as-named-defensive-discipline — §the-base-iterator-may-return-a-truthy-non-boolean-`done`; §the-helper-coerces-to-strict-boolean; §sibling-pattern to many defensive-coercion patterns; §first-explicit-observation in library.
