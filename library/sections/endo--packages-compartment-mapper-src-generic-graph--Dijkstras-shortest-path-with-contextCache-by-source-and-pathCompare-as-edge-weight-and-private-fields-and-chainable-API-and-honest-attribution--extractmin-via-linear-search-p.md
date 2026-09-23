---
title: §extractMin via §linear-search-priority-queue
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
const extractMin = ({ paths, queue }) => {
  let minPath;
  let minNode;

  queue.forEach(node => {
    const path = paths.get(node);
    if (!path) {
      return;
    }
    if (!minPath || isLowerCost(path, minPath)) {
      minPath = path;
      minNode = node;
    }
  });

  if (minNode === undefined) {
    queue.clear();
    return undefined;
  }

  queue.delete(minNode);
  return minNode;
};
```

§Linear-scan-of-the-queue to find the minimum. §O(V)-per-extraction → §O(V²)-overall-Dijkstra. §Borrowable-pattern: §when-the-graph-is-small-or-the-algorithm-runs-rarely, §linear-search-is-simpler-than-a-heap + §the-trade-off-is-named.

§The-`if (minNode === undefined) { queue.clear(); return undefined; }` — §when-no-min-can-be-extracted (all remaining queue nodes have no path), §clear-the-queue + §return-undefined to signal completion. §Borrowable-pattern: §explicit-termination-signal-via-undefined when the algorithm cannot proceed.

§The-`queue.delete(minNode)` — §extract-means-both-find-and-remove. §Sibling to standard heap-extractMin semantics.
