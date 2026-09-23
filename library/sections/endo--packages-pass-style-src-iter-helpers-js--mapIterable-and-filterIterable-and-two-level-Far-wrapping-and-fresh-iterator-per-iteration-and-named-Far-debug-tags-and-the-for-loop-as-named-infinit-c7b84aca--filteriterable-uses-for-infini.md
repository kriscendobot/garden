---
title: §filterIterable uses `for (;;)` infinite loop with skip-or-return
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

Lines 47-56 (the filterIterable's next):
```js
return Far('filtered iterator', {
  next: () => {
    for (;;) {
      const result = baseIterator.next();
      const { value, done } = result;
      if (done || pred(value)) {
        return result;
      }
    }
  },
});
```

§First-explicit-observation in library: **§the-`for (;;)`-as-named-infinite-loop-form — §the-pattern-IS-`for (;;)`-not-`while (true)` + §sibling-pattern to many systems-language conventions (C/C++)**.

§The-skip-or-return-shape — §inside-the-loop-call-the-base-next + §if-done-OR-pred-passes-return-the-result + §otherwise-loop-again-(skip-the-value); §the-loop-terminates-when-the-base-iterator-runs-out-or-when-a-value-passes-the-predicate.

§The-result-pass-through (line 53: `return result`) — §the-helper-returns-the-base-iterator's-result-object-DIRECTLY-not-a-reconstructed-one; §the-shape-IS-preserved-by-the-base-iterator + §the-helper-doesn't-rewrap; §sibling-pattern to many forwarding-iterator-conventions.

§First-explicit-observation in library: **§the-skip-or-return-loop-shape-in-filterIterable-uses-pass-through-not-rewrap-for-the-result-object**.
