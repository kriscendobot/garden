---
title: §Three mermaid diagrams in README with §three worked examples
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

The README has §three-mermaid-graphs each demonstrating §one-tier-of-the-comparison driving the choice:

1. **§Trivial case** — simple linear dependency `entry → foo → bar → baz`. Path is `['foo', 'bar', 'baz']`.
2. **§Length-tier example** — two paths to `baz`: `['foo', 'bar', 'baz']` (length 3) vs `['foo', 'a', 'b', 'baz']` (length 4). Shorter wins.
3. **§Cumulative-length-tier example** — two paths to `baz`: `['foo', 'bar', 'baz']` vs `['foo', 'alternative', 'baz']` (both length 3). Shorter-cumulative wins.
4. **§Lexicographic-tier example** — two paths to `baz`: `['foo', 'spam', 'baz']` vs `['foo', 'quux', 'baz']` (both length 3, both same cumulative). Lex-smallest wins (`quux` < `spam` at the first code unit of the second element).

§Four-mermaid-diagrams not three — I miscounted; the README has four numbered examples. §Each-example-demonstrates-the-next-tier-of-the-algorithm.

§Borrowable-pattern: §multiple-mermaid-diagrams-with-worked-examples-each-demonstrating-one-tier for §algorithms-with-tie-breaking-rules. §The-reader-can-follow-the-algorithm-by-walking-the-examples-in-order.
