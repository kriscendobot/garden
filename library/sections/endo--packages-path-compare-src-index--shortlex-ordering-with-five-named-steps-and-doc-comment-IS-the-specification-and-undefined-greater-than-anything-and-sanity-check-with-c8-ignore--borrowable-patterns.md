---
title: §Borrowable patterns
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

**Tier-1 (highest borrowing value):**

- §The-doc-comment-IS-the-algorithm-specification with §five-numbered-steps mirrored in the body.
- §Shortlex-order-with-three-tiers-of-tie-breaking (length → cumulative-character-count → lexicographic).
- §The-tie-breaker-ordering-IS-the-design — a different ordering yields a different shortest-path.
- §Undefined-sorts-greater-than-anything-else as the §first-branch-not-an-afterthought.
- §Sanity-check-with-`/* c8 ignore next 5 */` for unreachable defense-in-depth + §the-condition-is-the-negation-of-the-prior-step's-condition.
- §JSON.stringify-aliased-as-q-at-file-top for terse error messages.
- §The-comment-names-the-edge-case-explicitly (one-string-being-a-prefix-of-the-other).
- §Defense-by-construction-via-step-ordering — the loop's correctness leans on the prior cumulative-length step.

**Tier-2 (mechanism patterns):**

- §Two-CompareFn-instances + §the-larger-CompareFn-uses-the-smaller-one.
- §CompareFn-template-type as JSDoc `@callback` typedef parameterized by `T`.
- §Type-precision via `CompareFn<string>` vs `CompareFn<string[]|undefined>`.
- §Nested-ternary-with-eslint-disable as named exception.
- §UTF-16-code-unit-comparison-via-JavaScript-`<`-operator + §the-README-warns-this-may-be-surprising.

**Tier-3 (test patterns):**

- §Sixteen-tests-for-an-84-line-file (test-to-source ratio ~0.8).
- §Test-titles-name-the-property-not-the-mechanism.
- §Each-tier-of-tie-breaking-gets-symmetric-tests + §test-the-tie-breaker-by-constructing-the-tie via `despite` clauses.
- §Test-undefined-cases-symmetrically (three cases).
- §Test-empty-arrays as degenerate case.
- §Test-uses-t.true-for-sign-not-t.is-for-value (when spec says "negative" not "-1").
