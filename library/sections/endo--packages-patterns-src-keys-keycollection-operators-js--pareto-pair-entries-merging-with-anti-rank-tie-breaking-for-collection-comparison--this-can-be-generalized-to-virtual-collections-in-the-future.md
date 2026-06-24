---
section: pareto-pair-entries-merging-with-anti-rank-tie-breaking-for-collection-comparison
source: endo--packages-patterns-src-keys-keycollection-operators-js
topics: [patterns, marshal]
status: current
title: "*This can be generalized to virtual collections in the future*"
parent: endo--packages-patterns-src-keys-keycollection-operators-js--pareto-pair-entries-merging-with-anti-rank-tie-breaking-for-collection-comparison
---

The §JSDoc names a forward-looking generalization:

> *This can be generalized to virtual collections in the future by
> replacing `getEntries => Array` with
> `generateEntries => IterableIterator`.*

The current API takes `getEntries(collection) => Array<[Key, V]>` —
the whole collection must materialize into memory as an array. For
*virtual collections* (collections backed by a database or remote
service that doesn't materialize), the iterator could be lazy: take
`generateEntries(collection) => IterableIterator<[Key, V]>` instead.
The merge-join algebra is iterator-friendly; only the API surface
needs widening.

The §rank-sorted-entries-as-input precondition is what makes the
virtual-collection generalization easy — as long as the virtual
collection can produce its entries in rank order (which it must to
serve as a Key), the Pareto comparison composes.
