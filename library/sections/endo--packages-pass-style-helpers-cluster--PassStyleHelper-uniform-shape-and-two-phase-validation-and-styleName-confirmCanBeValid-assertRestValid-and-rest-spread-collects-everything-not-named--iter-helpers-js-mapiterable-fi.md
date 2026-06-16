---
title: §iter-helpers.js — §mapIterable + §filterIterable (lazy iterator utilities)
source-slug: endo--packages-pass-style-helpers-cluster
section-id: PassStyleHelper-uniform-shape-and-two-phase-validation-and-styleName-confirmCanBeValid-assertRestValid-and-rest-spread-collects-everything-not-named
url: https://github.com/endojs/endo/tree/master/packages/pass-style/src
authors: [Endo contributors]
repo: endojs/endo
path: packages/pass-style/src/{byteArray.js, copyArray.js, copyRecord.js, tagged.js, iter-helpers.js, string.js, makeTagged.js}
status: shipping
ingest-cycle: 227
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-pass-style-helpers-cluster--PassStyleHelper-uniform-shape-and-two-phase-validation-and-styleName-confirmCanBeValid-assertRestValid-and-rest-spread-collects-everything-not-named
---

```js
export const mapIterable = (baseIterable, func) =>
  Far('mapped iterable', {
    [Symbol.iterator]: () => {
      const baseIterator = baseIterable[Symbol.iterator]();
      return Far('mapped iterator', {
        next: () => {
          const { value: baseValue, done } = baseIterator.next();
          const value = done ? baseValue : func(baseValue);
          return harden({ value, done: !!done });
        },
      });
    },
  });
```

§Lazy-iterator-utilities: §map and §filter that return Far-wrapped iterables + iterators. §The-Far-wrapping makes them §pass-style-valid (they're remotables).

§Borrowable-pattern: §lazy-iterator-utility-that-returns-Far-wrapped-objects to be §pass-style-passable. §Sibling to cycle 213 stream-node's §self-referential-asyncIterator (both designs §iterator-as-pass-style-object).

§done ? baseValue : func(baseValue) — §the-completion-value-is-passed-through-not-transformed. §Borrowable-pattern: §the-completion-value-of-an-iterator-is-not-a-mapped-value; §don't-transform-the-completion-value.

§!!done — §boolean-coerce-the-done-flag to ensure the result is always strictly boolean. §Borrowable-pattern: §the-IteratorResult-protocol-says-done-is-boolean + §coerce-explicitly-to-avoid-leaking-undefined-or-other-values.
