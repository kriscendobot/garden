---
title: §The-relax-step with §classical-algorithm-name
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
const relax = ({ paths, predecessors }, source, target) => {
  const pathSource = paths.get(source);
  assert(pathSource, `Missing path to source ${q(source)}`);

  const pathTarget = paths.get(target);
  const newPath = [...pathSource, target];

  if (!pathTarget || isLowerCost(newPath, pathTarget)) {
    paths.set(target, newPath);
    predecessors.set(target, source);
  }
};
```

§Named-classical-graph-algorithm-step `relax`. §Borrowable-pattern: §use-classical-algorithm-step-names so the reader who knows Dijkstra recognizes the algorithm structure.

§The-`newPath = [...pathSource, target]` — §the-new-candidate-path-is-the-source-path-extended-by-one-step. §pathCompare-decides-if-newPath-is-better. §Borrowable-pattern: §when-the-cost-is-the-path-not-a-number, §extending-the-path-is-the-cost-update.
