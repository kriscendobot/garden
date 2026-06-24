---
title: §The-Set-iteration-via-forEach
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
parent: endo--packages-compartment-mapper-src-generic-graph--Dijkstras-shortest-path-with-contextCache-by-source-and-pathCompare-as-edge-weight-and-private-fields-and-chainable-API-and-honest-attribution
---

§The-code-uses-`queue.forEach(node => ...)` rather than `for (const node of queue)`. §Borrowable-pattern: §forEach-when-the-callback-is-the-natural-shape; §for-of-when-the-iteration-needs-early-break. §Cycle 235 doesn't need early break (it scans all to find min).
