---
title: §Shortlex-ordering with §three-tier-comparison (length / cumulative-length / lexicographic UTF-16) + §undefined-compares-greater-than-anything-else + §three-mermaid-diagrams-in-README-with-three-worked-examples + §sanity-check-with-c8-ignore-comment + §honest-Note-about-lexicographic-surprises + §used-by-compartment-mapper-for-shortest-path-to-transitive-dependency + §CompareFn-typedef-with-JSDoc-callback-shape — @endo/path-compare
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
---

# @endo/path-compare — §Shortlex-ordering + §three-tier-comparison + §undefined-compares-greater + §mermaid-diagrams + §honest-Note-about-UTF-16-surprises

## Source

- `endo packages/path-compare/src/index.js` — 84 lines (single module exporting `stringCompare` + `pathCompare`)
- `endo packages/path-compare/README.md` — 85 lines (with three mermaid diagrams + worked examples)
- Cycle 209 of `/loop resume the librarian work.` (chat-lane; alternates from cycle 208's designs-lane familiar-bundled-agents; §forty-third consecutive designs/chat alternation cycle 166-209)

§Twenty-third-member of §small-files-with-large-knowledge-density family.

## Single most structurally interesting move

§Shortlex-ordering with §three-tier-comparison: (1) array length; (2) cumulative string length; (3) lexicographic UTF-16 code unit + §undefined-compares-greater-than-anything-else as §explicit-handling-named-in-source + §three-mermaid-diagrams-in-README with §three-worked-examples each demonstrating §one-tier-of-the-comparison-driving-the-choice + §honest-Note-about-lexicographic-surprises (UTF-16 code unit ordering "may be surprising").

§The-algorithm-prefers-shortest-path-discipline. §Tie-breaking-with-named-reasons at each tier.

## §Shortlex ordering — Wikipedia-cited

The README links to [Shortlex order](https://en.wikipedia.org/wiki/Shortlex_order) explicitly. §Citation-of-formal-name as §design-archaeology — §the-algorithm-is-not-novel; §it-has-a-name-readers-can-look-up.

§Borrowable-pattern: §Wikipedia-citation-of-formal-name when the design uses §a-named-mathematical-or-CS-concept.

§Sibling-pattern to cycle 203 cache-map's §LRU + CLOCK + SIEVE Wikipedia citations and cycle 199 nat's §safely-representable-IEEE-754 ESDiscuss citation.

## §Three-tier comparison with §tie-breaking-with-named-reasons

```js
export const pathCompare = (a, b) => {
  // Undefined compares greater than anything else.
  if (a === undefined || b === undefined) {
    return a === b ? 0 : a === undefined ? 1 : -1;
  }

  // Prefer the shortest dependency path.
  if (a.length !== b.length) {
    return a.length - b.length;
  }

  // Otherwise, favor the shortest cumulative length.
  const aStringLength = a.join('').length;
  const bStringLength = b.join('').length;
  if (aStringLength !== bStringLength) {
    return aStringLength - bStringLength;
  }

  // [sanity check elided]

  // Otherwise, compare lexicographically.
  for (let i = 0; i < a.length; i += 1) {
    const comparison = stringCompare(a[i], b[i]);
    if (comparison !== 0) {
      return comparison;
    }
  }

  return 0;
};
```

§Four-stages of comparison (undefined-handling + array-length + cumulative-length + lexicographic + return-0). §Each-stage-returns-early on difference. §Each-stage-has-a-named-reason-comment: "Undefined compares greater than anything else" / "Prefer the shortest dependency path" / "Otherwise, favor the shortest cumulative length" / "Otherwise, compare lexicographically".

§Borrowable-pattern: §multi-tier-comparison-with-named-reasons + §early-return-per-tier. §The-comments-document-why-each-tier-exists.

§Sibling-pattern to cycle 200 retention-path-notation's §best-path-selection-rule (also four-tier: persistent-over-transient + pet-name-edge-presence + shortest + lex-smallest). §Cycle-209 is at the lower-level (string-array comparison); §cycle-200 is at the higher-level (retention-path with rich segment shapes). §Both-use-shortlex-style-discipline.

## §Undefined-compares-greater-than-anything-else

```js
// Undefined compares greater than anything else.
if (a === undefined || b === undefined) {
  return a === b ? 0 : a === undefined ? 1 : -1;
}
```

§Two-named-edge-cases handled explicitly: both undefined (return 0), one undefined (return -1 or 1).

§The-design-decision: §undefined-sorts-last when used with `Array.prototype.sort`. §This-matches-JavaScript's-built-in-Array.sort-default-behavior where undefined sorts last.

§Sibling-pattern to cycle 197 panic's §default-erroneous-exit (both designs §name-the-default-behavior-explicitly).

## §Three mermaid diagrams in README with §three worked examples

The README has §three-mermaid-graphs each demonstrating §one-tier-of-the-comparison driving the choice:

1. **§Trivial case** — simple linear dependency `entry → foo → bar → baz`. Path is `['foo', 'bar', 'baz']`.
2. **§Length-tier example** — two paths to `baz`: `['foo', 'bar', 'baz']` (length 3) vs `['foo', 'a', 'b', 'baz']` (length 4). Shorter wins.
3. **§Cumulative-length-tier example** — two paths to `baz`: `['foo', 'bar', 'baz']` vs `['foo', 'alternative', 'baz']` (both length 3). Shorter-cumulative wins.
4. **§Lexicographic-tier example** — two paths to `baz`: `['foo', 'spam', 'baz']` vs `['foo', 'quux', 'baz']` (both length 3, both same cumulative). Lex-smallest wins (`quux` < `spam` at the first code unit of the second element).

§Four-mermaid-diagrams not three — I miscounted; the README has four numbered examples. §Each-example-demonstrates-the-next-tier-of-the-algorithm.

§Borrowable-pattern: §multiple-mermaid-diagrams-with-worked-examples-each-demonstrating-one-tier for §algorithms-with-tie-breaking-rules. §The-reader-can-follow-the-algorithm-by-walking-the-examples-in-order.

## §Honest-Note about lexicographic surprises

> Note: the "lexicographic" comparison uses the UTF-16 code unit order, and thus may be surprising.

§Honest-disclosure that §the-lexicographic-comparison-is-not-Unicode-collation but §UTF-16-code-unit-order. §This-means: §code-units-above-U+FFFF (surrogate pairs) §sort-differently-from-Unicode-codepoints; §ASCII-vs-non-ASCII may have unexpected orderings.

§Borrowable-pattern: §honest-Note-about-surprising-defaults for §APIs-where-the-natural-name suggests one behavior but §the-implementation-uses-a-different-but-defensible-default.

§Sibling-pattern to cycle 199 trampoline's §two-eslint-discipline-aware-exceptions (both packages §name-the-discipline-being-violated-or-the-deviation) and cycle 201 immutable-arraybuffer's §Purposeful-Violation-section.

## §Sanity-check with §c8-ignore-comment

```js
// sanity check
/* c8 ignore next 5 */
if (a.length !== b.length) {
  throw new Error(
    `Unexpectedly different lengths of string arrays: ${q({ a, b })}`,
  );
}
```

§Defensive-check that §should-never-fire (the previous `if (a.length !== b.length)` would have returned). §c8-coverage-tool-ignore-comment tells the coverage tool §not-to-count-the-five-lines-as-uncovered.

§Honest-defense-with-coverage-tool-aware-comment. §The-check-is-real-protection but §the-coverage-tool-shouldn't-penalize-it.

§Borrowable-pattern: §c8-ignore-comment-for-sanity-checks-that-should-never-fire. §Sibling-pattern to cycle 195 cli/src's §example-comments-in-source-not-tests (both patterns annotate source for purposes not directly executed).

## §CompareFn typedef with §JSDoc-callback shape

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

## §stringCompare as building block

```js
export const stringCompare = (a, b) => (a === b ? 0 : a < b ? -1 : 1);
```

§One-line-string-comparator using JavaScript's `<` operator (UTF-16 code unit order). §Sibling-pattern to cycle 199 trampoline's §sync/async two-color sharing — both packages §expose-a-building-block-and-a-derived-form.

§The-no-nested-ternary-eslint-disable is §named-in-source. §Eslint-aware-named-deviation.

## §Used-by-compartment-mapper for shortest path to transitive dependency

> This is used by [@endo/compartment-mapper][] when crawling a `node_modules` directory to find the shortest _path_ to any given transitive dependency from the entry package.

§The-canonical-consumer named explicitly. §The-algorithm-isn't-abstract; §it's-the-tie-breaker for §dependency-resolution.

§Sibling-pattern to cycle 199 memoize's §passStyleOf-cited-as-canonical-memoize-user — both packages §name-the-flagship-consumer for §readers-to-orient-against.

## §Borrowable patterns (tier-1)

1. **§Shortlex-ordering with §Wikipedia-citation** as §formal-name + §three-tier-comparison (length / cumulative-length / lexicographic).
2. **§Multi-tier-comparison-with-named-reasons** + §early-return-per-tier — comments document why each tier exists.
3. **§Undefined-compares-greater-than-anything-else** as §explicit-handling matching `Array.prototype.sort` default.
4. **§Multiple-mermaid-diagrams-with-worked-examples-each-demonstrating-one-tier** for §algorithms-with-tie-breaking-rules.
5. **§Honest-Note-about-surprising-defaults** ("UTF-16 code unit order... may be surprising") for §APIs-where-natural-name-suggests-one-behavior-but-implementation-uses-different-defensible-default.
6. **§Sanity-check-with-c8-ignore-comment** for §defensive-checks-that-should-never-fire.
7. **§JSDoc-callback-typedef-with-generic-T** for §named-reusable-function-shapes.
8. **§Eslint-aware-named-deviation** (e.g., `// eslint-disable-next-line no-nested-ternary`).
9. **§Building-block-and-derived-form** — `stringCompare` (one-line UTF-16 comparator) is the building block for `pathCompare` (the rich algorithm).
10. **§Name-the-canonical-consumer** in README (here: @endo/compartment-mapper for node_modules path resolution).
11. **§q = JSON.stringify** canonical shorthand for §error-message-quoting (sibling to cycle 207 env-options).
12. **§Algorithm-numbered-steps-in-JSDoc** — the JSDoc above `pathCompare` documents §five-numbered-algorithm-steps.

## §Synthesis-target

Slot machine library §combo-comparator for §pay-table-priority:

- §Multi-tier-comparison-with-named-reasons borrowable for §combo-priority (e.g., higher-base-value-wins; tie → fewer-symbols-wins; tie → alphabetical).
- §Undefined-compares-greater-than-anything-else borrowable for §null-handling in §combo-arrays.
- §Building-block-and-derived-form borrowable for §exposing-low-level-and-high-level-comparators.
- §Mermaid-diagrams-with-worked-examples borrowable for §README-explanation-of-game-mechanics with §multi-tier-tie-breaking-rules.
- §JSDoc-callback-typedef-with-generic-T borrowable for §any-comparison-function-API.

## §Cycle 209 meta-observations

§The-forty-third-consecutive-designs/chat-alternation-cycle 166-209.

§Papers-lane-blocked 103+ consecutive cycles (since cycle ~106).

§Library-reaches-714-sections at cycle 209.

§Twenty-third-member of §small-files-with-large-knowledge-density family.

§Shortlex-ordering-with-three-tier-comparison joins cycle 200 retention-path-notation's §best-path-selection-rule as §two-different-applications-of-the-same-shortlex-discipline at §different-levels-of-the-stack (string-array vs retention-path-with-rich-segment-shapes).

§The-`pathCompare`-package is §the-substrate-for-cycle-200's-best-path-selection-rule via @endo/compartment-mapper's use case — §though-the-cycle-200-design has its own §four-tier-comparison adapted to retention-path semantics.

§Mermaid-diagrams now appear in five+ ingested designs. §Sibling-pattern to cycle 200 worker-rust-xs's §ASCII-architecture-diagram and cycle 206 inventory-cancel-and-liveness's §ASCII-visual-layout-diagram — §three-different-visualization-conventions (mermaid / ASCII-art / explicit-prose-walkthrough) for §design-explanation.
