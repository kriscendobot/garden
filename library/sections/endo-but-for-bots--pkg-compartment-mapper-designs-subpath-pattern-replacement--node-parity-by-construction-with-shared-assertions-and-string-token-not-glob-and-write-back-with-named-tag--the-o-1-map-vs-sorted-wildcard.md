---
title: §the-O(1)-Map-vs-sorted-wildcard-array distinction (first-explicit-observation)
section-slug: endo-but-for-bots--pkg-compartment-mapper-designs-subpath-pattern-replacement--node-parity-by-construction-with-shared-assertions-and-string-token-not-glob-and-write-back-with-named-tag
source-slug: endo-but-for-bots--pkg-compartment-mapper-designs-subpath-pattern-replacement
url: https://github.com/endojs/endo-but-for-bots/blob/master/packages/compartment-mapper/designs/subpath-pattern-replacement.md
authors: [Endo project (collective)]
status: (no explicit metadata table)
ingest-cycle: 287
ingest-date: 2026-06-10
lane: designs
scope: full
total-lines: 271
parent: endo-but-for-bots--pkg-compartment-mapper-designs-subpath-pattern-replacement--node-parity-by-construction-with-shared-assertions-and-string-token-not-glob-and-write-back-with-named-tag
---

> "Exact entries (no `*`) are stored in a `Map` for O(1) lookup. Wildcard entries are decomposed into prefix/suffix pairs and sorted by prefix length descending."

**§the-named-two-data-structures-for-the-two-entry-kinds**: exact-vs-wildcard ARE structurally different concerns; the design uses a `Map` for one and a sorted array for the other. **§the-data-structure-IS-the-decision** — not "use both arrays" or "use both Maps", but pick the structure for each kind's access pattern.

§the-prefix-length-descending-sort-IS-the-named-specificity-ordering: this implements Rule #4 (pattern specificity = longest matching prefix wins) by sorting wildcard entries once at construction time.
