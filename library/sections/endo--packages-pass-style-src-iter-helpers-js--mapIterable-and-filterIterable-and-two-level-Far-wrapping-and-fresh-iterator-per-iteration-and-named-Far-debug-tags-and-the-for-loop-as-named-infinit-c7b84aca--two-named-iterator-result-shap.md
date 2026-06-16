---
title: §Two named iterator-result-shapes
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

The two utilities demonstrate §two-named-iterator-result-shapes:

| Helper          | Input shape   | Output shape  | Element-count change | Element-value change |
|-----------------|---------------|---------------|----------------------|----------------------|
| `mapIterable`   | `Iterable<T>` | `Iterable<U>` | unchanged            | transformed via func |
| `filterIterable`| `Iterable<T>` | `Iterable<T>` | shrunk (filtered)    | unchanged            |

§First-explicit-observation in library: **§two-named-iterator-result-shapes (same-element-count-transformed-values + subset-with-unchanged-values) — §the-cluster-pedagogy-of-two-utilities-with-different-shape-changes**.

§Sibling-pattern to functional-programming's map+filter duality; §the-cluster-presents-the-canonical-pair.

§Each-helper-IS-typed-via-template-parameters — §`mapIterable` uses `<T,U>` (input + output types differ); §`filterIterable` uses `<T>` (input = output); §the-template-parameter-count-correlates-with-the-shape-change.

§First-explicit-observation in library: **§the-template-parameter-count-correlates-with-the-shape-change (mapIterable has two; filterIterable has one) — §the-type-system-encodes-the-shape-change-discipline**.
