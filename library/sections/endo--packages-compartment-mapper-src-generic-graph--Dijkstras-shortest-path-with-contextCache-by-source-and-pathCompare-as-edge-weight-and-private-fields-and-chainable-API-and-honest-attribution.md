---
title: "@endo/compartment-mapper/generic-graph — §Dijkstra-shortest-path-with-contextCache-by-source + §pathCompare-as-edge-weight-via-cycle-209 + §GenericGraph-class-with-private-fields + §chainable-API + §honest-attribution-to-third-party + §amortize-O(V²)-traversal-cost"
source-slug: endo--packages-compartment-mapper-src-generic-graph
section-id: Dijkstras-shortest-path-with-contextCache-by-source-and-pathCompare-as-edge-weight-and-private-fields-and-chainable-API-and-honest-attribution
url: https://github.com/endojs/endo/blob/master/packages/compartment-mapper/src/generic-graph.js
authors: [Endo contributors; portions from datavis-tech/graph-data-structure by Curran Kelleher]
repo: endojs/endo
path: packages/compartment-mapper/src/generic-graph.js
total-lines: 326
status: shipping
ingest-cycle: 235
ingest-date: 2026-06-08
lane: chat
kind: index
section_count: 15
---

Sections:

- [@endo/compartment-mapper/generic-graph — Generic graph with Dijkstra's shortest-path](endo--packages-compartment-mapper-src-generic-graph--Dijkstras-shortest-path-with-contextCache-by-source-and-pathCompare-as-edge-weight-and-private-fields-and-chainable-API-and-honest-attribution--endo-compartment-mapper-generi.md)
- [§Honest-attribution to third-party source](endo--packages-compartment-mapper-src-generic-graph--Dijkstras-shortest-path-with-contextCache-by-source-and-pathCompare-as-edge-weight-and-private-fields-and-chainable-API-and-honest-attribution--honest-attribution-to-third-party-source.md)
- [§Dijkstra's-single-source-shortest-path-algorithm](endo--packages-compartment-mapper-src-generic-graph--Dijkstras-shortest-path-with-contextCache-by-source-and-pathCompare-as-edge-weight-and-private-fields-and-chainable-API-and-honest-attribution--dijkstra-s-single-source-short.md)
- [§Cache-the-traversal-context-by-source (the §load-bearing-optimization)](endo--packages-compartment-mapper-src-generic-graph--Dijkstras-shortest-path-with-contextCache-by-source-and-pathCompare-as-edge-weight-and-private-fields-and-chainable-API-and-honest-attribution--cache-the-traversal-context-by.md)
- [§pathCompare-as-edge-weight (cycle 209 sibling)](endo--packages-compartment-mapper-src-generic-graph--Dijkstras-shortest-path-with-contextCache-by-source-and-pathCompare-as-edge-weight-and-private-fields-and-chainable-API-and-honest-attribution--pathcompare-as-edge-weight-cyc.md)
- [§The-GenericGraph-class with §private-fields](endo--packages-compartment-mapper-src-generic-graph--Dijkstras-shortest-path-with-contextCache-by-source-and-pathCompare-as-edge-weight-and-private-fields-and-chainable-API-and-honest-attribution--the-genericgraph-class-with-pr.md)
- [§Chainable-API via `return this`](endo--packages-compartment-mapper-src-generic-graph--Dijkstras-shortest-path-with-contextCache-by-source-and-pathCompare-as-edge-weight-and-private-fields-and-chainable-API-and-honest-attribution--chainable-api-via-return-this.md)
- [§The-relax-step with §classical-algorithm-name](endo--packages-compartment-mapper-src-generic-graph--Dijkstras-shortest-path-with-contextCache-by-source-and-pathCompare-as-edge-weight-and-private-fields-and-chainable-API-and-honest-attribution--the-relax-step-with-classical.md)
- [§The-getPath-walks-the-predecessor-subgraph](endo--packages-compartment-mapper-src-generic-graph--Dijkstras-shortest-path-with-contextCache-by-source-and-pathCompare-as-edge-weight-and-private-fields-and-chainable-API-and-honest-attribution--the-getpath-walks-the-predeces.md)
- [§extractMin via §linear-search-priority-queue](endo--packages-compartment-mapper-src-generic-graph--Dijkstras-shortest-path-with-contextCache-by-source-and-pathCompare-as-edge-weight-and-private-fields-and-chainable-API-and-honest-attribution--extractmin-via-linear-search-p.md)
- [§The-Set-iteration-via-forEach](endo--packages-compartment-mapper-src-generic-graph--Dijkstras-shortest-path-with-contextCache-by-source-and-pathCompare-as-edge-weight-and-private-fields-and-chainable-API-and-honest-attribution--the-set-iteration-via-foreach.md)
- [§Library-scope: first compartment-mapper ingest](endo--packages-compartment-mapper-src-generic-graph--Dijkstras-shortest-path-with-contextCache-by-source-and-pathCompare-as-edge-weight-and-private-fields-and-chainable-API-and-honest-attribution--library-scope-first-compartmen.md)
- [Related material in the library](endo--packages-compartment-mapper-src-generic-graph--Dijkstras-shortest-path-with-contextCache-by-source-and-pathCompare-as-edge-weight-and-private-fields-and-chainable-API-and-honest-attribution--related-material-in-the-library.md)
- [§Four-different-underscore-or-hash-conventions for privacy](endo--packages-compartment-mapper-src-generic-graph--Dijkstras-shortest-path-with-contextCache-by-source-and-pathCompare-as-edge-weight-and-private-fields-and-chainable-API-and-honest-attribution--four-different-underscore-or-h.md)
- [§Three-cycles-on-third-party-attribution](endo--packages-compartment-mapper-src-generic-graph--Dijkstras-shortest-path-with-contextCache-by-source-and-pathCompare-as-edge-weight-and-private-fields-and-chainable-API-and-honest-attribution--three-cycles-on-third-party-attribution.md)
