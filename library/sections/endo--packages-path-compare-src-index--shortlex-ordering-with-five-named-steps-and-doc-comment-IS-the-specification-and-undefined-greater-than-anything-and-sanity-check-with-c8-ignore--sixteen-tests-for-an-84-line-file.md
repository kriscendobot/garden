---
title: §Sixteen tests for an 84-line file
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
