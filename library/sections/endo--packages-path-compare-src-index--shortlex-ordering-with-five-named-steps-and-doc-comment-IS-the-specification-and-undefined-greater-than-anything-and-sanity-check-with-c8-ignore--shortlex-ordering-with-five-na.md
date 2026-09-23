---
title: Shortlex ordering with five-named-steps + doc-comment IS the specification + undefined sorts greater + sanity-check with c8-ignore
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

[`@endo/path-compare`](../sources/endo--packages-path-compare-src-index.md) is an 84-line module exporting two functions: `stringCompare` (5 lines including JSDoc) and `pathCompare` (the substantive 40-line function). It implements shortlex order for string arrays — used by `@endo/compartment-mapper` to find the shortest path to any transitive dependency from the entry package. The library has known about pathCompare since **cycle 209** (sibling reference) and **cycle 235** (GenericGraph's Dijkstra used `pathCompare` as edge weight); cycle 237 is the **direct ingest** of the implementation. §Three-cycle-progression: referenced (209) → used-as-edge-weight (235) → directly-ingested (237).
