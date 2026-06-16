---
title: §undefined sorts greater than anything else (named exception)
source-slug: endo--packages-path-compare-src-index
source-url: https://github.com/endojs/endo/blob/master/packages/path-compare/src/index.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/path-compare/src/index.js
total-lines: 84
ingest-cycle: 237
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-path-compare-src-index--shortlex-ordering-with-five-named-steps-and-doc-comment-IS-the-specification-and-undefined-greater-than-anything-and-sanity-check-with-c8-ignore
---

The function's first guard is for `undefined`:

```js
if (a === undefined || b === undefined) {
  return a === b ? 0 : a === undefined ? 1 : -1;
}
```

§Undefined-sorts-greater-than-anything-else (the comment above says: *Undefined compares greater than anything else.*). §When-the-input-can-be-undefined, §the-comparator-must-define-where-undefined-sorts. The choice here: undefined > everything (rather than undefined < everything or undefined-throws or undefined-returns-NaN). §Three-named-cases (both-undefined-→-equal + a-undefined-→-a-is-greater + b-undefined-→-b-is-greater). The compareFn type signature is `CompareFn<string[]|undefined>` so undefined is part of the type, not an out-of-band value.

§Named-exception-to-comparison: the function takes `string[]|undefined` (not just `string[]`), and the undefined branch is the §first-branch-not-an-afterthought. §When-undefined-is-in-the-type, §undefined-is-in-the-algorithm. The doc-comment makes this Step 1, not a special case mentioned at the end.
