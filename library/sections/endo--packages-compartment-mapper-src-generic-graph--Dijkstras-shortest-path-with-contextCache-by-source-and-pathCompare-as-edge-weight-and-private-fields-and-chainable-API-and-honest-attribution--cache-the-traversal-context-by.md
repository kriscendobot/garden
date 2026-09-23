---
title: §Cache-the-traversal-context-by-source (the §load-bearing-optimization)
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
export const makeShortestPath = graph => {
  /** @type {Map<T, TraversalContext<T>>} */
  const contextCache = new Map();

  const shortestPath = (source, target) => {
    let context = contextCache.get(source);
    if (!context) {
      context = dijkstra(graph, source);
      contextCache.set(source, context);
    }
    return getPath(context, source, target);
  };
  return shortestPath;
};
```

> Dijkstra's algorithm is a *single-source* shortest path algorithm: one run produces shortest paths to every reachable node. The returned function caches the traversal context by source, so the first call for a given source pays O(V²) and every subsequent call with the same source is O(path length).

§Borrowable-pattern: §when-an-algorithm-is-single-source-but-the-API-is-pairwise, §cache-by-source + §amortize-the-O(V²)-traversal-cost. §First-call-for-a-source-pays-V²; §subsequent-calls-for-the-same-source-pay-only-path-length.

§The-cache-key-is-the-source, not the (source,target) pair. §Reuse-the-traversal-tree-from-a-source-for-multiple-targets. §Borrowable-pattern: §recognize-when-the-algorithm's-natural-product-(the-tree-from-one-source-to-all-targets)-is-larger-than-the-API's-natural-product-(one-source-to-one-target) + §cache-the-larger-product.

§Sibling to cycle 221 @endo/bundle-source's §SHA-512-content-addressed-source-map-cache — both designs §cache-an-expensive-computation; cycle 221 caches by content-hash; cycle 235 caches by source-node.
