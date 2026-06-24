---
title: §Two-level Far wrapping — iterable AND iterator are both Far
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

Lines 17-28 (mapIterable) and 44-58 (filterIterable) share a §two-level-Far-wrapping shape:

```js
Far('mapped iterable', {
  [Symbol.iterator]: () => {
    const baseIterator = baseIterable[Symbol.iterator]();
    return Far('mapped iterator', {
      next: () => { ... },
    });
  },
});
```

§First-explicit-observation in library: **§two-level-Far-wrapping-for-iterable-and-iterator — §the-outer-`Far('mapped iterable', ...)`-wraps-the-iterable-object + §the-inner-`Far('mapped iterator', ...)`-wraps-the-iterator-object + §both-levels-IS-Far-because-both-IS-passable**.

§Sibling-pattern to many capability-systems' wrap-everything discipline; §the-helper-doesn't-leak-bare-iteration-state + §every-returned-object-IS-a-passable-Far-reference.

§The-fresh-iterator-per-iteration-discipline — §`Symbol.iterator`-on-the-iterable-IS-a-FACTORY-not-a-getter; §every-call-to-`Symbol.iterator`-creates-a-NEW-iterator; §the-mapIterable-IS-an-iterable-NOT-an-iterator; §sibling-pattern to JavaScript's iterator protocol convention.

§First-explicit-observation in library: **§fresh-iterator-per-iteration-as-named-Far-wrapping-discipline — §when-a-helper-returns-a-derived-iterable, §the-`Symbol.iterator`-factory-creates-a-fresh-iterator-per-iteration + §each-iterator-IS-its-own-Far-reference**.
