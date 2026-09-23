---
title: §Borrowable patterns (tier-1)
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
