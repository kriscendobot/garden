---
title: §CompareFn typedef with §JSDoc-callback shape
source: endo packages/path-compare/{src/index.js,README.md}
source-slug: endo--packages-path-compare
ingest-cycle: 209
ingest-date: 2026-06-06
lane: chat
authors: [Endo contributors]
related:
  - endo--packages-compartment-mapper (the canonical consumer — uses pathCompare when crawling node_modules to find shortest path to transitive dependency)
  - endo--packages-env-options (cycle 207: §pre-SES sibling — both packages have compact source + rich README structure)
  - endo--packages-trampoline-memoize-nat-trio (cycle 199: §minimal-dependency-discipline sibling — @endo/path-compare is similarly minimal)
keywords:
  - Shortlex ordering (Wikipedia-cited)
  - three-tier comparison (length / cumulative-length / lexicographic UTF-16)
  - undefined-compares-greater-than-anything-else
  - mermaid-diagrams in README (three worked examples)
  - sanity-check-with-c8-ignore-comment (`/* c8 ignore next 5 */`)
  - honest-Note-about-lexicographic-surprises (UTF-16 code unit order)
  - used-by-compartment-mapper-for-shortest-path-to-transitive-dependency
  - CompareFn-typedef with JSDoc-callback shape
  - q = JSON.stringify canonical shorthand
  - prefer-shortest-path-discipline
  - stringCompare as building block (UTF-16 code units)
  - three-mermaid-diagrams-with-three-worked-examples
  - tie-breaking-with-named-reasons
  - algorithm-numbered-steps-in-JSDoc
  - cycle 209 chat-lane
  - twenty-third-member of small-files-with-large-knowledge-density family
  - forty-third consecutive designs/chat alternation cycle 166-209
parent: endo--packages-path-compare--shortlex-ordering-with-three-tier-comparison-and-mermaid-diagrams-in-README-and-undefined-compares-greater-and-honest-note-about-UTF-16-lexicographic-surprises
---

```js
/**
 * Comparison function for two values of the same type `T`.
 *
 * Can be used with `Array.prototype.sort` and other similar contexts
 *
 * @template T The type of the values to compare
 * @callback CompareFn
 * @param {T} a First value
 * @param {T} b Second value
 * @returns {number} Negative integer if `a < b`; positive integer if `a > b`;
 * `0` if equal
 */

/** @type {CompareFn<string>} */
export const stringCompare = (a, b) => (a === b ? 0 : a < b ? -1 : 1);

/** @type {CompareFn<string[]|undefined>} */
export const pathCompare = (a, b) => { ... };
```

§Generic-typedef-CompareFn<T> reused for §both-exports with §different-T (`string` for stringCompare; `string[]|undefined` for pathCompare). §JSDoc-callback-syntax (`@callback`) creates §a-named-reusable-function-type.

§Borrowable-pattern: §JSDoc-callback-typedef-with-generic-T for §comparison-functions or §any-named-function-shape that gets §reused-across-the-module.
