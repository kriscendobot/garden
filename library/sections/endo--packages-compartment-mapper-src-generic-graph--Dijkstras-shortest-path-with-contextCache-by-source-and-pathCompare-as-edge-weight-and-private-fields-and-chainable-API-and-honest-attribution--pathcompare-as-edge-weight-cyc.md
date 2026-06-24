---
title: §pathCompare-as-edge-weight (cycle 209 sibling)
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

```js
import { pathCompare } from '@endo/path-compare';

const isLowerCost = (pathA, pathB) =>
  pathCompare(pathA?.map(String), pathB?.map(String)) < 0;
```

§The-edge-weight-IS-the-path-itself — §pathCompare-from-@endo/path-compare (cycle 209) compares two paths lexicographically. §Borrowable-pattern: §use-the-path-itself-as-the-cost-not-a-separate-weight-property.

§This-is-unusual: most Dijkstra implementations have explicit edge weights. §The-`relax` step extends the source path with the target node to produce the candidate path; §isLowerCost compares full paths via path-compare. §Lexicographic-path-comparison gives §a-deterministic-tie-break order.

§Sibling to cycle 209 @endo/path-compare (which provides pathCompare). §Two-cycles-in-the-library-now-on-pathCompare-as-comparison-mechanism: cycle 209 defines it; cycle 235 uses it as edge weight.

§`pathA?.map(String)` — §coerce-elements-to-strings-via-map; the optional-chaining handles missing paths (undefined).
