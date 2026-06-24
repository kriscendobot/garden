---
title: "@endo/path-compare/src/index.js — Shortlex ordering of string arrays"
source-slug: endo--packages-path-compare-src-index
url: https://github.com/endojs/endo/blob/master/packages/path-compare/src/index.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/path-compare/src/index.js
total-lines: 84
status: published (1.1.0)
ingest-cycle: 237
ingest-date: 2026-06-08
lane: chat
---

# @endo/path-compare/src/index.js

An 84-line module exporting two functions: `stringCompare` (a one-line UTF-16 code-unit comparator) and `pathCompare` (a 40-line implementation of shortlex order for string arrays, with explicit support for `undefined` as a §named-extreme-value-sorting-greater-than-anything).

The package is consumed by `@endo/compartment-mapper` when crawling `node_modules` to find the §shortest-path-to-any-transitive-dependency-from-the-entry-package. §Three-cycle-progression in this library: §referenced (cycle 209) → §used-as-edge-weight (cycle 235 by GenericGraph's Dijkstra) → §directly-ingested (cycle 237).

## Key design moves

- **§The doc-comment IS the algorithm specification** — §five-numbered-steps in JSDoc + line-by-line mirror in the body.
- **§Shortlex order with three tiers of tie-breaking** — length → cumulative-character-count → lexicographic.
- **§The tie-breaker ordering IS the design** — a different ordering yields a different shortest-path.
- **§Undefined sorts greater than anything else** — first branch, not an afterthought.
- **§Sanity check with `/* c8 ignore next 5 */`** — unreachable defense-in-depth against future edits.
- **§JSON.stringify aliased as q** at file top for terse error messages.
- **§The comment names the edge case explicitly** — one-string-being-a-prefix-of-the-other.
- **§Defense by construction via step ordering** — the loop's correctness leans on the prior cumulative-length step.
- **§Two CompareFn instances** — `stringCompare` (UTF-16 atomic) nested inside `pathCompare` (shortlex over arrays).
- **§CompareFn template type** — JSDoc `@callback` typedef parameterized by `T`.
- **§Type precision** — `CompareFn<string>` vs `CompareFn<string[]|undefined>`.

## Section files

- [§shortlex-ordering-with-five-named-steps + §doc-comment-IS-the-specification + §undefined-greater-than-anything + §sanity-check-with-c8-ignore](../sections/endo--packages-path-compare-src-index--shortlex-ordering-with-five-named-steps-and-doc-comment-IS-the-specification-and-undefined-greater-than-anything-and-sanity-check-with-c8-ignore.md) — full 84-line module ingest, with §sixteen-tests survey and §borrowable-patterns tier-1/2/3 breakdown.

## Ingest scope

Cycle 237 (chat-lane): full 84-line module ingest plus survey of the 67-line, sixteen-test suite. §Second-direct-ingest from `@endo/compartment-mapper`'s neighborhood (cycle 235 was `compartment-mapper/src/generic-graph.js`; cycle 237 is `path-compare/src/index.js`).
