---
title: §The-getPath-walks-the-predecessor-subgraph
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
const getPath = ({ predecessors }, source, target) => {
  const nodeList = [];
  assert(source !== target, `Source ${q(source)} cannot be the same as target ${q(target)}`);

  let node = target;
  while (predecessors.has(node)) {
    const currentNode = predecessors.get(node);
    nodeList.push(node);
    node = currentNode;
  }
  assert.equal(node, source, `No path found from ${q(String(source))} to ${q(String(target))}`);
  nodeList.push(node);
  assert(nodeList.length >= 2, `The path from ${source} to ${target} should have at least two nodes`);

  return /** @type {[T, T, ...T[]]} */ (nodeList.reverse());
};
```

§Three-named-assertions:
1. §Source-not-equal-to-target.
2. §No-path-found-via assert.equal(node, source).
3. §Path-has-at-least-two-nodes.

§Borrowable-pattern: §after-walking-the-predecessor-chain, §assert-the-walk-ended-at-source + §the-resulting-list-is-non-trivial. §Defense-in-depth-against-algorithm-bugs.

§The-`nodeList.reverse()` to get source-to-target order. §The-traversal-naturally-produces-target-to-source; §the-API-returns-source-to-target. §Borrowable-pattern: §when-the-algorithm-traverses-backwards, §reverse-at-the-end.

§The-`[T, T, ...T[]]` type — §at-least-two-elements (source + target plus zero-or-more intermediates). §Borrowable-pattern: §use-tuple-types-to-encode-non-empty-arrays-with-minimum-length.
