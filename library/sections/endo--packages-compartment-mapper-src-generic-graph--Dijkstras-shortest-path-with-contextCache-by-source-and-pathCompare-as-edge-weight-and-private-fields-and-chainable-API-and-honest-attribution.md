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
---

# @endo/compartment-mapper/generic-graph — Generic graph with Dijkstra's shortest-path

A 326-line file in `@endo/compartment-mapper/src/`. Implements §`GenericGraph` class (nodes + directed edges) and §`makeShortestPath` factory (Dijkstra's algorithm with per-source traversal-context caching). §The-first-ingested-file from the `@endo/compartment-mapper` package (the substrate cycle 221 @endo/bundle-source builds on).

## §Honest-attribution to third-party source

```js
/**
 * Provides {@link GenericGraph} and {@link makeShortestPath}.
 *
 * Portions adapted from
 * [graph data structure](https://github.com/datavis-tech/graph-data-structure),
 * which is Copyright (c) 2016 Curran Kelleher and licensed under the MIT
 * License.
 *
 * @module
 */
```

§Borrowable-pattern: §when-adapting-code-from-a-named-third-party-library, §the-attribution-comment-at-the-top-of-the-file-names-the-source + §the-original-author + §the-license. §The-attribution-IS-the-license-compliance + §the-pedagogical-source-marker.

§Sibling to cycle 232 endoclaw-channel-bridges' §named-third-party-foundation (Vercel chat SDK) — both designs §builds-on-existing-third-party-work. §Cycle-232-recommends-a-third-party-SDK; §cycle-235-adapts-third-party-source-into-the-codebase.

§Three-cycles-on-third-party-attribution in the library:
- Cycle 84 rankOrder.js (mentions Drossopoulou-Noble-Miller-Murray axiom).
- Cycle 232 endoclaw-channel-bridges (Vercel chat SDK as foundation).
- Cycle 235 generic-graph (datavis-tech/graph-data-structure adapted source).

## §Dijkstra's-single-source-shortest-path-algorithm

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

## §Cache-the-traversal-context-by-source (the §load-bearing-optimization)

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

## §pathCompare-as-edge-weight (cycle 209 sibling)

```js
import { pathCompare } from '@endo/path-compare';

const isLowerCost = (pathA, pathB) =>
  pathCompare(pathA?.map(String), pathB?.map(String)) < 0;
```

§The-edge-weight-IS-the-path-itself — §pathCompare-from-@endo/path-compare (cycle 209) compares two paths lexicographically. §Borrowable-pattern: §use-the-path-itself-as-the-cost-not-a-separate-weight-property.

§This-is-unusual: most Dijkstra implementations have explicit edge weights. §The-`relax` step extends the source path with the target node to produce the candidate path; §isLowerCost compares full paths via path-compare. §Lexicographic-path-comparison gives §a-deterministic-tie-break order.

§Sibling to cycle 209 @endo/path-compare (which provides pathCompare). §Two-cycles-in-the-library-now-on-pathCompare-as-comparison-mechanism: cycle 209 defines it; cycle 235 uses it as edge weight.

§`pathA?.map(String)` — §coerce-elements-to-strings-via-map; the optional-chaining handles missing paths (undefined).

## §The-GenericGraph-class with §private-fields

```js
export class GenericGraph {
  /** @type {Set<T>} */
  #nodes;
  /** @type {Map<T, Set<T>>} */
  #edges;

  constructor() {
    this.#edges = new Map();
    this.#nodes = new Set();
  }

  get nodes() {
    return new Set(this.#nodes);
  }

  addNode(node) { /* ... return this; */ }
  removeNode(node) { /* ... return this; */ }
  adjacent(node) { return this.#edges.get(node); }
  addEdge(source, target) { /* ... return this; */ }
  removeEdge(source, target) { /* ... return this; */ }
  hasEdge(source, target) { /* ... */ }
}
```

§Two-internal-data-structures: §`#nodes` Set + §`#edges` Map<node, Set<adjacent-node>>. §The-`#`-prefix is §JavaScript's-class-private-field-syntax (not the SES `__` convention). §The-data-is-truly-private (not just hidden by convention).

§Borrowable-pattern: §when-a-class-has-internal-state-that-shouldn't-leak, §use-`#`-class-private-fields. §Different-from-cycle-223-module-source's-`__double-underscore__` (which is the SES Compartment internal contract; visible via reflection) and cycle 217 @endo/errors' `__HIDE_` prefix (which is a stack-trace censor protocol).

§Four-different-underscore-or-hash-conventions in the library now:
- Cycle 217: §`__HIDE_<name>` (visible; SES stack-trace protocol).
- Cycle 223: §`__name__` (visible; SES Compartment internal contract).
- Cycle 233: §`_name` (visible; Node internal API convention).
- Cycle 235: §`#name` (truly-private; JavaScript class field).

§The-pattern: §each-substrate-or-language-feature-has-its-own-privacy-convention. §Cycle-235-is-the-language-level-true-privacy; the others are §visible-conventions-with-named-semantics.

### §`get nodes` returns a shallow copy

```js
get nodes() {
  return new Set(this.#nodes);
}
```

§The-getter-returns-a-defensive-copy + §callers-cannot-mutate-the-internal-Set. §Borrowable-pattern: §when-a-getter-exposes-internal-state, §return-a-fresh-copy-to-prevent-mutation-of-the-internal-state. §The-cost-is-O(V); §the-correctness-benefit-is-that-the-caller-cannot-leak-or-mutate-the-internal-state.

§Sibling to cycle 231 @endo/marshal/encodeToCapData's §the-don't-harden-since-we're-not-done-mutating-it — both designs §the-comment-IS-the-protocol-but-cycle-235-just-encapsulates-the-protection-in-the-getter.

## §Chainable-API via `return this`

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

## §The-relax-step with §classical-algorithm-name

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

## §The-getPath-walks-the-predecessor-subgraph

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

## §extractMin via §linear-search-priority-queue

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

## §The-Set-iteration-via-forEach

§The-code-uses-`queue.forEach(node => ...)` rather than `for (const node of queue)`. §Borrowable-pattern: §forEach-when-the-callback-is-the-natural-shape; §for-of-when-the-iteration-needs-early-break. §Cycle 235 doesn't need early break (it scans all to find min).

## §Library-scope: first compartment-mapper ingest

The @endo/compartment-mapper package has been referenced as a §heavy-machinery-substrate in many cycles but never ingested directly:
- Cycle 200 worker-rust-xs (§XS-hosted compartment-mapper).
- Cycle 202 endor-run-expanded (uses compartment-mapper).
- Cycle 221 @endo/bundle-source (§thin-dispatch-layer over compartment-mapper).
- Cycle 230 endor-npm-registry-proxy (Phase 4 integration with compartment mapper).

§Cycle-235 is §the-first-direct-ingest from `@endo/compartment-mapper/src/`. §The-package-IS-the-foundational-machinery + §the-thin-dispatchers-have-been-ingested-first.

§Borrowable-pattern: §when-a-package-is-foundational-machinery, §ingest-its-thin-dispatchers-first + §work-down-to-the-heavy-files-over-time. §The-library-builds-up-the-shape-of-the-package-from-its-edges-inward.

## Related material in the library

- **cycle 209 @endo/path-compare**: §the-pathCompare-substrate this file uses as edge weight.
- **cycle 221 @endo/bundle-source**: §thin-dispatch-layer over compartment-mapper.
- **cycle 232 endoclaw-channel-bridges**: §named-third-party-foundation sibling.
- **cycle 217 @endo/errors + cycle 223 @endo/module-source + cycle 233 node-async-local-storage-patch + cycle 235**: §four-different-underscore-or-hash-conventions for privacy.
- **cycle 226 endoclaw-cluster**: §chainable-API vs control-pair API sibling discussion.
- **cycle 231 @endo/marshal/encodeToCapData**: §the-comment-IS-the-protocol vs §encapsulate-in-getter (cycle 235's `get nodes` returns a fresh copy).
- **cycle 84 rankOrder.js**: §third-party-attribution sibling.
- **cycle 200 worker-rust-xs + cycle 202 endor-run-expanded**: §compartment-mapper-substrate users.

## §Library-reaches-741-sections at cycle 235 (chat-lane @endo/compartment-mapper/generic-graph).

## §Sixty-ninth consecutive designs-chat alternation cycles 166-235.

## §Four-different-underscore-or-hash-conventions for privacy

| Cycle | Source | Convention | Privacy level |
|-------|--------|-----------|---------------|
| 217 | @endo/errors | `__HIDE_<name>` (double-prefix marker) | visible; SES stack-trace protocol |
| 223 | @endo/module-source | `__name__` (double-underscore-wrap) | visible; SES Compartment internal contract |
| 233 | @endo/init/node-async-local-storage-patch | `_name` (single-underscore-prefix) | visible; Node internal API convention |
| 235 | @endo/compartment-mapper/generic-graph | `#name` (class-private-field) | truly-private; JavaScript language feature |

§Four-different-privacy-conventions for §four-different-substrates. §Cycle-235-is-the-language-level-true-privacy.

## §Three-cycles-on-third-party-attribution

| Cycle | Source | Form |
|-------|--------|------|
| 84 | rankOrder.js | Drossopoulou-Noble-Miller-Murray axiom citation |
| 232 | endoclaw-channel-bridges | Vercel chat SDK as named foundation |
| 235 | compartment-mapper/generic-graph | datavis-tech/graph-data-structure MIT-licensed adaptation |

§Three-different-attribution-forms.

## §Thirty-fifth-member of §small-files-with-large-knowledge-density family.
