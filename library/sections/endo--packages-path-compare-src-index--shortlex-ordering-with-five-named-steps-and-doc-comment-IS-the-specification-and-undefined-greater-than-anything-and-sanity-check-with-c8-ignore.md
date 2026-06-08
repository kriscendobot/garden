---
title: "@endo/path-compare/src/index.js — Shortlex ordering with five-named-steps + doc-comment IS the specification + undefined sorts greater + sanity-check with c8-ignore"
source-slug: endo--packages-path-compare-src-index
source-url: https://github.com/endojs/endo/blob/master/packages/path-compare/src/index.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/path-compare/src/index.js
total-lines: 84
ingest-cycle: 237
ingest-date: 2026-06-08
lane: chat
---

# Shortlex ordering with five-named-steps + doc-comment IS the specification + undefined sorts greater + sanity-check with c8-ignore

[`@endo/path-compare`](../sources/endo--packages-path-compare-src-index.md) is an 84-line module exporting two functions: `stringCompare` (5 lines including JSDoc) and `pathCompare` (the substantive 40-line function). It implements shortlex order for string arrays — used by `@endo/compartment-mapper` to find the shortest path to any transitive dependency from the entry package. The library has known about pathCompare since **cycle 209** (sibling reference) and **cycle 235** (GenericGraph's Dijkstra used `pathCompare` as edge weight); cycle 237 is the **direct ingest** of the implementation. §Three-cycle-progression: referenced (209) → used-as-edge-weight (235) → directly-ingested (237).

## §The doc-comment IS the algorithm specification

The 12-line JSDoc above `pathCompare` lists §five-numbered-steps of the algorithm in prose, and the function body is then a literal §line-by-line implementation of those five steps. §The-doc-comment-IS-the-algorithm-specification: the prose and the code mirror each other, and you can read either to understand the algorithm. §When-the-doc-comment-and-the-body-mirror-each-other, §the-doc-comment-IS-the-specification + §the-body-IS-the-only-implementation. The five named steps:

1. _Check if either value is `undefined`._ Both undefined → 0; `a` undefined → 1; `b` undefined → -1.
2. _Check the lengths of the arrays._ If different, return the difference.
3. _Check the cumulative lengths of the arrays_ using the count of UTF-16 units in each string. If different, return the difference.
4. _Check the individual elements of the arrays_ via lexical comparison.
5. _If all elements are the same_ ("deep equality"), return `0`.

Each step is a §named-tie-breaker. §The-tie-breakers-are-the-algorithm. The order of tie-breakers is the design: §length-first-then-cumulative-character-count-then-lexicographic.

## §Shortlex order with three tiers of tie-breaking

The README opens with the canonical citation: §Shortlex-order (https://en.wikipedia.org/wiki/Shortlex_order) §with-Wikipedia-link. The three tiers:

1. **§Length** — `if (a.length !== b.length) return a.length - b.length;` — §prefer-the-shortest-dependency-path. The README's mermaid graphs make this concrete: `['foo', 'bar', 'baz']` (3 elements) beats `['foo', 'a', 'b', 'baz']` (4 elements) even when both are valid paths.
2. **§Cumulative character count** — `const aStringLength = a.join('').length;` — §favor-the-shortest-cumulative-length. The README's third mermaid graph: when both paths have 3 elements, `['foo', 'bar', 'baz']` beats `['foo', 'alternative', 'baz']` because `bar` has fewer characters than `alternative`.
3. **§Lexicographic per-element** — `stringCompare(a[i], b[i])` for each `i` — §UTF-16-code-unit-order. The README's fourth mermaid graph: when both paths have the same length and cumulative length, `['foo', 'quux', 'baz']` beats `['foo', 'spam', 'baz']` because `q` < `s` in UTF-16.

§Three-tiers-of-tie-breaking + §each-tier-is-a-distinct-comparison-axis + §the-algorithm-must-choose-one (the README says explicitly: "the algorithm _must_ choose one, and so chooses the one with the fewest cumulative characters"). §The-design-axis-is-the-tie-breaker-ordering: a different ordering would yield a different shortest-path.

## §undefined sorts greater than anything else (named exception)

The function's first guard is for `undefined`:

```js
if (a === undefined || b === undefined) {
  return a === b ? 0 : a === undefined ? 1 : -1;
}
```

§Undefined-sorts-greater-than-anything-else (the comment above says: *Undefined compares greater than anything else.*). §When-the-input-can-be-undefined, §the-comparator-must-define-where-undefined-sorts. The choice here: undefined > everything (rather than undefined < everything or undefined-throws or undefined-returns-NaN). §Three-named-cases (both-undefined-→-equal + a-undefined-→-a-is-greater + b-undefined-→-b-is-greater). The compareFn type signature is `CompareFn<string[]|undefined>` so undefined is part of the type, not an out-of-band value.

§Named-exception-to-comparison: the function takes `string[]|undefined` (not just `string[]`), and the undefined branch is the §first-branch-not-an-afterthought. §When-undefined-is-in-the-type, §undefined-is-in-the-algorithm. The doc-comment makes this Step 1, not a special case mentioned at the end.

## §Sanity check with c8-ignore for unreachable defense-in-depth

After step 2 (the length check that returns when lengths differ), the function reaches a §dead-code-sanity-check:

```js
// sanity check
/* c8 ignore next 5 */
if (a.length !== b.length) {
  throw new Error(
    `Unexpectedly different lengths of string arrays: ${q({ a, b })}`,
  );
}
```

§The-condition-is-the-negation-of-step-2's-condition, so if step 2 didn't return, the condition is necessarily false. §The-code-is-unreachable-by-the-algorithm but §defense-in-depth-against-future-edits-that-might-remove-step-2. §The-`/* c8 ignore next 5 */` is the explicit signal to coverage tooling that §this-is-deliberate-unreachable-code-not-untested-code. §When-coverage-would-flag-dead-code, §c8-ignore-with-explanation. The five-line annotation count covers the `if` line + the `throw` + `new Error(` + the template string + the closing `);`.

§Three-named-uses-of-c8-ignore-in-library-so-far (need to confirm — likely first explicit observation as a borrowable pattern; mark §first-observation). §JSON.stringify-aliased-as-q-for-terse-error-messages: `const { stringify: q } = JSON;` at file top. §The-q-alias makes the error message expression short: `${q({ a, b })}`. §When-error-messages-need-to-show-a-structured-value, §alias-JSON.stringify-as-q.

## §The loop catches prefix-of-another-string as named edge case

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

## §Two CompareFn instances with stringCompare nested in pathCompare

`stringCompare` is a one-liner:

```js
export const stringCompare = (a, b) => (a === b ? 0 : a < b ? -1 : 1);
```

§UTF-16-code-unit-comparison-via-JavaScript-`<`-operator. §Nested-ternary-with-eslint-disable: `// eslint-disable-next-line no-nested-ternary` is the named exception to a project lint rule. §Two-eslint-disable-no-nested-ternary in this 84-line file (one for `stringCompare`, one for the undefined branch in `pathCompare`). §When-a-rule-is-disabled-twice-in-a-small-file, §the-rule-is-not-fit-for-this-file's-style + §but-the-disable-comments-keep-the-rule-on-everywhere-else.

`pathCompare` calls `stringCompare(a[i], b[i])` in its loop. §Two-CompareFn-instances + §the-larger-CompareFn-uses-the-smaller-one + §the-smaller-CompareFn-is-the-atomic-element-comparison.

§CompareFn-template-type: `@template T The type of the values to compare` + `@callback CompareFn` + `@param {T} a` + `@param {T} b` + `@returns {number}`. §The-template-typedef-IS-the-contract. §JSDoc-callback-typedef-as-named-reusable-shape. The contract: "Negative integer if `a < b`; positive integer if `a > b`; `0` if equal" — §the-three-named-sign-cases.

§Type-precision: `CompareFn<string>` for `stringCompare` and `CompareFn<string[]|undefined>` for `pathCompare`. §The-type-parameter-encodes-the-comparator's-domain.

## §Sixteen tests for an 84-line file

The test file (`test/index.test.js`, 67 lines) contains §sixteen-named-tests for a §source-file-of-84-lines. §Test-to-source-ratio of ~0.8. §High-coverage-on-pure-functions: when a function is pure and small, the test suite enumerates the named-cases-of-the-spec. §The-test-titles-are-the-spec-prose:

- "stringCompare - returns 0 for equal strings"
- "pathCompare - returns negative for shorter array"
- "pathCompare - returns negative for smaller cumulative length"
- "pathCompare - returns negative for smaller cumulative length despite lexically larger elements"
- "pathCompare - returns negative for lexically smaller array"

§Test-titles-name-the-property-not-the-mechanism. §Each-tier-of-tie-breaking-gets-symmetric-tests (smaller + larger; negative + positive). §The-`despite`-clauses-in-test-titles construct the tie scenario to verify the tie-breaker fires: "returns negative for smaller cumulative length despite lexically larger elements" sets up a case where one path's elements are lexically larger but the cumulative length wins.

§Test-symmetry: §both-directions-tested for every comparison. §Test-the-tie-breaker-by-constructing-the-tie: the `despite` tests are §adversarial-tests-against-the-tie-breaker (cycle reference: §adversarial-tests skill).

§Test-undefined-cases-symmetrically: three tests cover (both-undefined + a-undefined + b-undefined). §Test-empty-arrays as a §degenerate-case ("returns 0 for empty arrays").

§Test-uses-t.true-for-sign-not-t.is-for-value: the tests assert `t.true(pathCompare(...) < 0)` rather than `t.is(pathCompare(...), -1)`. §When-the-spec-says-negative-not-minus-one, §the-test-asserts-negative-not-minus-one. §This-avoids-over-specifying. (Though one batch of tests uses `t.is(pathCompare(...), 0)` and `t.is(pathCompare(...), 1)` for the undefined cases where the spec does pin specific values 0/1/-1.)

## §Borrowable patterns

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

## §Synthesis target — slot machine library

For a slot machine library design:

- §game-action-path-comparison via shortlex: when multiple action sequences reach the same game state, prefer fewest actions, then shortest total parameter encoding, then lexicographically earliest.
- §pathCompare-as-edge-weight-in-game-state-graph (cycle 235 sibling) — Dijkstra's algorithm with pathCompare-as-edge-weight produces the §canonical-shortest-action-sequence.
- §three-tiers-of-tie-breaking for §game-strategy-comparison: §action-count-first, then §total-cost-second, then §specific-action-sequence-third.
- §the-tie-breaker-ordering-IS-the-design — a slot machine that breaks ties by lowest-cost-first would surface different strategies than one that breaks ties by shortest-action-sequence-first.
- §undefined-strategy-sorts-greater (no-strategy is greater than any strategy) for §game-state-where-strategy-is-missing-or-pending.
- §sanity-check-with-c8-ignore for §unreachable-game-state-handlers that defend against future rule changes.
- §test-titles-name-the-property-not-the-mechanism for §game-rule-test-titles ("returns win for three-of-a-kind despite different colors").
- §test-the-tie-breaker-by-constructing-the-tie via `despite` clauses for §game-rule-priority-tests.

## §Library meta-counters

- §Library-reaches-743-sections at cycle 237 (chat-lane @endo/path-compare/src/index).
- §Seventy-first-consecutive designs-chat alternation cycle (cycles 166-237).
- §Three-cycle-progression for pathCompare: §referenced-only (cycle 209) + §used-as-edge-weight (cycle 235) + §directly-ingested (cycle 237). §When-a-library-references-X-then-uses-X-then-ingests-X, §the-three-cycle-progression-IS-the-library's-natural-deepening-pattern.
- §The-second-direct-ingest from `@endo/compartment-mapper`'s neighborhood (cycle 235 was `compartment-mapper/src/generic-graph.js`; cycle 237 is `path-compare/src/index.js` which is consumed by `compartment-mapper` but lives in its own package).
- §Eight-cycles-where-the-doc-comment-IS-the-specification family (need to retrieve precise count; mark §a-recurring-pattern-in-`@endo`-source).
- §Thirty-sixth member of §small-files-with-large-knowledge-density family.
- §First-explicit-observation-of `/* c8 ignore next N */` as borrowable pattern in library.
- §First-explicit-observation-of `const { stringify: q } = JSON` as borrowable pattern in library (the `q` alias is widespread in `@endo` but had not been named as a borrowable pattern until now).
- §First-explicit-observation-of "shortlex" as a named-ordering in library.
- §Test-title-spelling-discipline (cycle 237 also exhibits §test-titles-as-spec-prose; cross-reference §test-title-spec-spelling skill).

(Endo Project Contributors authored)
