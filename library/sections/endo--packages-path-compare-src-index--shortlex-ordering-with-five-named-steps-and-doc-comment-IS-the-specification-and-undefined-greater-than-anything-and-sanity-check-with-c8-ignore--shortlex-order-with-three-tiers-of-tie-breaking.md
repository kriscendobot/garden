---
title: §Shortlex order with three tiers of tie-breaking
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

The README opens with the canonical citation: §Shortlex-order (https://en.wikipedia.org/wiki/Shortlex_order) §with-Wikipedia-link. The three tiers:

1. **§Length** — `if (a.length !== b.length) return a.length - b.length;` — §prefer-the-shortest-dependency-path. The README's mermaid graphs make this concrete: `['foo', 'bar', 'baz']` (3 elements) beats `['foo', 'a', 'b', 'baz']` (4 elements) even when both are valid paths.
2. **§Cumulative character count** — `const aStringLength = a.join('').length;` — §favor-the-shortest-cumulative-length. The README's third mermaid graph: when both paths have 3 elements, `['foo', 'bar', 'baz']` beats `['foo', 'alternative', 'baz']` because `bar` has fewer characters than `alternative`.
3. **§Lexicographic per-element** — `stringCompare(a[i], b[i])` for each `i` — §UTF-16-code-unit-order. The README's fourth mermaid graph: when both paths have the same length and cumulative length, `['foo', 'quux', 'baz']` beats `['foo', 'spam', 'baz']` because `q` < `s` in UTF-16.

§Three-tiers-of-tie-breaking + §each-tier-is-a-distinct-comparison-axis + §the-algorithm-must-choose-one (the README says explicitly: "the algorithm _must_ choose one, and so chooses the one with the fewest cumulative characters"). §The-design-axis-is-the-tie-breaker-ordering: a different ordering would yield a different shortest-path.
