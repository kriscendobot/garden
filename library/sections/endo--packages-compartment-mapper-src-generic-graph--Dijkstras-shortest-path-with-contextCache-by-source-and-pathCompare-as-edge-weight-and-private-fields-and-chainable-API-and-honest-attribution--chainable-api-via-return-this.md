---
title: §Chainable-API via `return this`
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
addNode(node) {
  if (!this.#nodes.has(node)) {
    this.#nodes.add(node);
  }
  if (!this.#edges.has(node)) {
    this.#edges.set(node, new Set());
  }
  return this;
}
```

§The-mutating-methods-return-this — §chainable-API. §Borrowable-pattern: §when-a-class-has-many-mutators, §return-this-from-each + §callers-can-chain-`graph.addNode(a).addEdge(a, b).addEdge(b, c)`. §The-chainable-style-IS-the-domain-specific-language for building graphs.

§Sibling to cycle 226 endoclaw-cluster's §two-facet-control-pair with §revoke / §help / §setX — but cycle 226 returns void; cycle 235 returns this. §Different-API-styles for different use cases.
