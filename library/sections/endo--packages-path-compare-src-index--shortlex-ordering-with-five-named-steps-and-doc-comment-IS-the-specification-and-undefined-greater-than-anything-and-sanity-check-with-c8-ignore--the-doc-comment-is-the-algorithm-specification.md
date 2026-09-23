---
title: §The doc-comment IS the algorithm specification
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

The 12-line JSDoc above `pathCompare` lists §five-numbered-steps of the algorithm in prose, and the function body is then a literal §line-by-line implementation of those five steps. §The-doc-comment-IS-the-algorithm-specification: the prose and the code mirror each other, and you can read either to understand the algorithm. §When-the-doc-comment-and-the-body-mirror-each-other, §the-doc-comment-IS-the-specification + §the-body-IS-the-only-implementation. The five named steps:

1. _Check if either value is `undefined`._ Both undefined → 0; `a` undefined → 1; `b` undefined → -1.
2. _Check the lengths of the arrays._ If different, return the difference.
3. _Check the cumulative lengths of the arrays_ using the count of UTF-16 units in each string. If different, return the difference.
4. _Check the individual elements of the arrays_ via lexical comparison.
5. _If all elements are the same_ ("deep equality"), return `0`.

Each step is a §named-tie-breaker. §The-tie-breakers-are-the-algorithm. The order of tie-breakers is the design: §length-first-then-cumulative-character-count-then-lexicographic.
