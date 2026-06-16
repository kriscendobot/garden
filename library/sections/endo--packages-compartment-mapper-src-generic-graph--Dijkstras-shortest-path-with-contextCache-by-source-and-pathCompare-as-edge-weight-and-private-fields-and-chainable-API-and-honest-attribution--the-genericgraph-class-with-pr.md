---
title: §The-GenericGraph-class with §private-fields
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
