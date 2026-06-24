---
section: weak-value-map-via-WeakRef-and-FinalizationRegistry-with-gc-as-side-channel-warning-and-end-of-turn-stability
source: endo--packages-captp-src-finalize-js
topics: [captp, hardened-javascript, capability-security]
status: current
title: The §load-bearing-definition — §weak-on-values-not-on-keys
parent: endo--packages-captp-src-finalize-js--weak-value-map-via-WeakRef-and-FinalizationRegistry-with-gc-as-side-channel-warning-and-end-of-turn-stability
---

> *Elsewhere this is known as a "Weak Value Map". Whereas a
> std JS WeakMap is weak on its keys, this map is weak on its
> values. It does not retain these values strongly. If a
> given value disappears, then the entries for it disappear
> from every weak-value-map that holds it as a value.*

The §weak-on-values-not-on-keys distinction. Standard JS
WeakMap allows GC of *keys*; this map allows GC of *values*.
The §dual-of-WeakMap framing.

The §keys-stay-but-entries-disappear semantic: when a value is
collected, the entry vanishes from *every* weak-value-map
holding it. The §multi-map-coordinated-removal property
emerges from `FinalizationRegistry`'s broadcast nature: one GC
event fires the finalization callback in every map that
registered the value.

The §typedef-as-Pick-with-additions: the JSDoc *types* the
returned object as `Pick<Map<K,V>, 'get'|'has'|'delete'> & {
set, clearWithoutFinalizing, getSize }`. The §narrowed-Map-
interface discipline names only the methods the consumer
actually needs.
