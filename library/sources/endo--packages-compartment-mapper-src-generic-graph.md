---
title: "@endo/compartment-mapper/generic-graph — Generic graph with Dijkstra's shortest-path; pathCompare-as-edge-weight; per-source traversal-context caching"
source-slug: endo--packages-compartment-mapper-src-generic-graph
url: https://github.com/endojs/endo/blob/master/packages/compartment-mapper/src/generic-graph.js
authors: [Endo contributors; portions from datavis-tech/graph-data-structure by Curran Kelleher]
repo: endojs/endo
path: packages/compartment-mapper/src/generic-graph.js
total-lines: 326
status: shipping
ingest-cycle: 235
ingest-date: 2026-06-08
lane: chat
---

# @endo/compartment-mapper/generic-graph

A 326-line file. Implements §`GenericGraph` class (nodes + directed edges) and §`makeShortestPath` factory (Dijkstra's algorithm with per-source traversal-context caching). §The-first-ingested-file from the `@endo/compartment-mapper` package.

## Key design moves

- **§Honest-attribution to third-party source** (datavis-tech/graph-data-structure, MIT, Curran Kelleher).
- **§Dijkstra's-single-source-shortest-path-algorithm** with §three-named-classical-steps (extractMin + relax + loop-until-empty).
- **§Cache-the-traversal-context-by-source** — amortize O(V²) traversal cost; first call O(V²), subsequent calls O(path length).
- **§Recognize-when-the-algorithm's-natural-product-is-larger-than-the-API's-natural-product + cache-the-larger-product**.
- **§pathCompare-as-edge-weight** via cycle 209 @endo/path-compare — the path itself is the cost.
- **§The-GenericGraph-class with class-private-fields** (`#nodes` + `#edges`); §true-language-level-privacy.
- **§Defensive-copy in `get nodes`** to prevent mutation of internal state.
- **§Chainable-API via `return this`** for the mutating methods.
- **§Classical-algorithm-step-names** (`relax`, `extractMin`) so the reader recognizes the algorithm structure.
- **§Three-named-assertions in getPath** (source ≠ target + no-path-found + length ≥ 2).
- **§Linear-search-priority-queue** — O(V) per extraction; trade-off named in doc-comment.
- **§Explicit-termination-signal-via-undefined** when extractMin cannot proceed.
- **§Tuple-type for non-empty array with minimum length** (`[T, T, ...T[]]`).

## Section files

- [§Dijkstra-shortest-path + §contextCache-by-source + §pathCompare-as-edge-weight + §private-fields + §chainable-API + §honest-attribution](../sections/endo--packages-compartment-mapper-src-generic-graph--Dijkstras-shortest-path-with-contextCache-by-source-and-pathCompare-as-edge-weight-and-private-fields-and-chainable-API-and-honest-attribution.md) — full source ingest.

## Ingest scope

Cycle 235 (chat-lane): full 326-line ingest. §The-first-ingested-file from the `@endo/compartment-mapper` package (the heavy-machinery substrate that cycle 221 @endo/bundle-source builds on). §Four-different-underscore-or-hash-conventions for privacy now in library (cycle 217 + 223 + 233 + 235).
