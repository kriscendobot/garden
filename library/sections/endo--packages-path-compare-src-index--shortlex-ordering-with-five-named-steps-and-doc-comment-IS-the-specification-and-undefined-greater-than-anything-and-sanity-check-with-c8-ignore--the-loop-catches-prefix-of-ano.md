---
title: §The loop catches prefix-of-another-string as named edge case
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

After the cumulative-length tie-breaker, the function enters a per-element comparison loop. The comment above the loop explicitly addresses an edge case:

```js
// Otherwise, compare lexicographically.
// This loop guarantees that if any pair of strings at the same index differ,
// including the case where one is a prefix of the other, we will return a
// non-zero value.
for (let i = 0; i < a.length; i += 1) {
  const comparison = stringCompare(a[i], b[i]);
  if (comparison !== 0) {
    return comparison;
  }
}
```

§The-comment-names-the-edge-case-explicitly: §one-string-being-a-prefix-of-the-other. Without the cumulative-length tie-breaker, this would be a subtle bug (`'foo'` vs `'foobar'` have the same lexical prefix). But step 3 already ensured cumulative lengths are equal, so if one string is a prefix of the other, the strings at other indices must compensate — and the per-element `stringCompare` will catch it because at some index the strings differ.

§Defense-by-construction-via-step-ordering: the cumulative-length tie-breaker §makes-the-loop's-correctness-rely-on-step-3. §The-comment-after-the-loop reinforces this: "If all pairs of terms are the same respective lengths, we are guaranteed that they are exactly the same or one of them is lexically distinct and would have already been caught." §Two-named-comments-where-the-code-leans-on-an-earlier-step: §the-correctness-is-distributed-across-steps + §each-step-comment-names-its-dependency-on-prior-steps.
