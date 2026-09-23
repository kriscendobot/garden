---
title: §Three-tier comparison with §tie-breaking-with-named-reasons
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
