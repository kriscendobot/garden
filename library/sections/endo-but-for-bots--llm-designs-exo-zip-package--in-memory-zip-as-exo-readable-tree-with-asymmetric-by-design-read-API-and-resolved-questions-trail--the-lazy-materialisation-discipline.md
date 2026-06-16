---
section: in-memory-zip-as-exo-readable-tree-with-asymmetric-by-design-read-API-and-resolved-questions-trail
source: endo-but-for-bots--llm-designs-exo-zip-package
topics: [exo, daemon, marshal]
status: current
title: The §lazy-materialisation discipline
parent: endo-but-for-bots--llm-designs-exo-zip-package--in-memory-zip-as-exo-readable-tree-with-asymmetric-by-design-read-API-and-resolved-questions-trail
---

§Design Decision 3:

> *A 10 000-entry archive should not allocate 10 000 exos at
> `makeExoZip` time. The grouping pass produces child
> factories; `lookup` invokes them.*

The §grouping-pass-produces-child-factories pattern: at
construction time, walk the zip's `Map<string, ZFile>` once;
group entries by first path segment; *each group becomes a
factory function*, not an exo. Sub-exos materialise *on
demand* when `lookup` is called.

The §amortize-allocation-over-lookups discipline:

- **Construction cost**: O(entries) string operations to
  group.
- **Materialization cost**: O(1) per `lookup` call.
- **Total cost** for a daemon's checkin walk that calls each
  `lookup` exactly once: O(entries).
- **Total cost** for a partial walk (e.g. shallow inspection
  of a large archive): O(touched entries) — *vastly* less
  than O(all entries).

The §lazy-evaluation-as-correctness-not-optimization
observation: §lookup `'a/b/c'` *could* materialize 3 exos for
intermediates *or* memoize them. The design doesn't say
which; the *cost of repeated `lookup` calls* is *one extra
exo creation* — acceptable since the daemon's checkin walk
only calls each `lookup` once.
