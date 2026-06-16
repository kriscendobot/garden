---
title: §Dijkstra's-single-source-shortest-path-algorithm
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

§The-algorithmic-heart:

```js
const dijkstra = (graph, source) => {
  const context = {
    paths: new Map(),
    predecessors: new Map(),
    queue: nodes,
  };

  for (const node of nodes) {
    queue.add(node);
  }
  assert(queue.has(source), `Source ${q(source)} is not in the graph`);
  paths.set(source, []);

  while (queue.size !== 0) {
    const node = extractMin(context);
    if (node === undefined) {
      return context;
    }
    const adjacent = graph.adjacent(node);
    if (adjacent) {
      for (const edge of adjacent) {
        relax(context, node, edge);
      }
    }
  }
  return context;
};
```

§Three-named-classical-Dijkstra-steps: §extractMin (find unvisited node with shortest path so far) + §relax (update path to each neighbor if the new path through `node` is shorter) + §loop-until-queue-is-empty.

§The-`if (node === undefined) return context;` exits early when no more reachable nodes — §the-remaining-queue-is-unreachable + §don't-bother-traversing-it. §Borrowable-pattern: §early-exit-from-Dijkstra-when-extractMin-returns-undefined.

§Linear-search-priority-queue: §extractMin-is-O(V) + §the-loop-is-O(V) × O(V) = O(V²). §Trade-off-named-in-doc-comment.
