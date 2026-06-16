---
title: §Sanity-check with §c8-ignore-comment
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
