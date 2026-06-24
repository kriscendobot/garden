---
title: §Synthesis target — slot machine library
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

For a slot machine library design:

- §game-action-path-comparison via shortlex: when multiple action sequences reach the same game state, prefer fewest actions, then shortest total parameter encoding, then lexicographically earliest.
- §pathCompare-as-edge-weight-in-game-state-graph (cycle 235 sibling) — Dijkstra's algorithm with pathCompare-as-edge-weight produces the §canonical-shortest-action-sequence.
- §three-tiers-of-tie-breaking for §game-strategy-comparison: §action-count-first, then §total-cost-second, then §specific-action-sequence-third.
- §the-tie-breaker-ordering-IS-the-design — a slot machine that breaks ties by lowest-cost-first would surface different strategies than one that breaks ties by shortest-action-sequence-first.
- §undefined-strategy-sorts-greater (no-strategy is greater than any strategy) for §game-state-where-strategy-is-missing-or-pending.
- §sanity-check-with-c8-ignore for §unreachable-game-state-handlers that defend against future rule changes.
- §test-titles-name-the-property-not-the-mechanism for §game-rule-test-titles ("returns win for three-of-a-kind despite different colors").
- §test-the-tie-breaker-by-constructing-the-tie via `despite` clauses for §game-rule-priority-tests.
