---
title: "endo-but-for-bots/packages/compartment-mapper/designs/subpath-pattern-replacement.md — Node.js subpath pattern parity via shared assertions + the `*`-IS-a-string-token-not-a-glob distinction + write-back with named `__createdBy` tag + parity-by-construction testing discipline"
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
kind: index
section_count: 22
---

Sections:

- [`compartment-mapper/designs/subpath-pattern-replacement.md` (full design)](endo-but-for-bots--pkg-compartment-mapper-designs-subpath-pattern-replacement--node-parity-by-construction-with-shared-assertions-and-string-token-not-glob-and-write-back-with-named-tag--compartment-mapper-designs-sub.md)
- [The shape](endo-but-for-bots--pkg-compartment-mapper-designs-subpath-pattern-replacement--node-parity-by-construction-with-shared-assertions-and-string-token-not-glob-and-write-back-with-named-tag--the-shape.md)
- [§the-`Objective`-section-as-named-design-doc-section-name (first-explicit-observation)](endo-but-for-bots--pkg-compartment-mapper-designs-subpath-pattern-replacement--node-parity-by-construction-with-shared-assertions-and-string-token-not-glob-and-write-back-with-named-tag--the-objective-section-as-named.md)
- [§the-`*`-IS-a-string-replacement-token-not-a-glob (first-explicit-observation)](endo-but-for-bots--pkg-compartment-mapper-designs-subpath-pattern-replacement--node-parity-by-construction-with-shared-assertions-and-string-token-not-glob-and-write-back-with-named-tag--the-is-a-string-replacement-to.md)
- [§the-seven-numbered-Rules-of-Node.js-subpath-semantics (first-explicit-observation)](endo-but-for-bots--pkg-compartment-mapper-designs-subpath-pattern-replacement--node-parity-by-construction-with-shared-assertions-and-string-token-not-glob-and-write-back-with-named-tag--the-seven-numbered-rules-of-no.md)
- [§the-Implementation-section-organized-by-source-file (first-explicit-observation)](endo-but-for-bots--pkg-compartment-mapper-designs-subpath-pattern-replacement--node-parity-by-construction-with-shared-assertions-and-string-token-not-glob-and-write-back-with-named-tag--the-implementation-section-org.md)
- [§the-O(1)-Map-vs-sorted-wildcard-array distinction (first-explicit-observation)](endo-but-for-bots--pkg-compartment-mapper-designs-subpath-pattern-replacement--node-parity-by-construction-with-shared-assertions-and-string-token-not-glob-and-write-back-with-named-tag--the-o-1-map-vs-sorted-wildcard.md)
- [§the-null-target-IS-named-as-explicit-exclusion-shape (first-explicit-observation)](endo-but-for-bots--pkg-compartment-mapper-designs-subpath-pattern-replacement--node-parity-by-construction-with-shared-assertions-and-string-token-not-glob-and-write-back-with-named-tag--the-null-target-is-named-as-ex.md)
- [§the-3-priority-resolution-order in moduleMapHook (first-explicit-observation)](endo-but-for-bots--pkg-compartment-mapper-designs-subpath-pattern-replacement--node-parity-by-construction-with-shared-assertions-and-string-token-not-glob-and-write-back-with-named-tag--the-3-priority-resolution-orde.md)
- [§the-write-back-pattern-with-named-`__createdBy` tag (first-explicit-observation)](endo-but-for-bots--pkg-compartment-mapper-designs-subpath-pattern-replacement--node-parity-by-construction-with-shared-assertions-and-string-token-not-glob-and-write-back-with-named-tag--the-write-back-pattern-with-na.md)
- [§the-`patterns: never` type-level enforcement (first-explicit-observation)](endo-but-for-bots--pkg-compartment-mapper-designs-subpath-pattern-replacement--node-parity-by-construction-with-shared-assertions-and-string-token-not-glob-and-write-back-with-named-tag--the-patterns-never-type-level.md)
- [§the-Eschewed-Alternatives-section-with-named-rejected-shapes (first-explicit-observation)](endo-but-for-bots--pkg-compartment-mapper-designs-subpath-pattern-replacement--node-parity-by-construction-with-shared-assertions-and-string-token-not-glob-and-write-back-with-named-tag--the-eschewed-alternatives-sect.md)
- [§the-pure-string-operation-discipline (first-explicit-observation)](endo-but-for-bots--pkg-compartment-mapper-designs-subpath-pattern-replacement--node-parity-by-construction-with-shared-assertions-and-string-token-not-glob-and-write-back-with-named-tag--the-pure-string-operation-disc.md)
- [§the-Parity-by-construction testing discipline (first-explicit-observation)](endo-but-for-bots--pkg-compartment-mapper-designs-subpath-pattern-replacement--node-parity-by-construction-with-shared-assertions-and-string-token-not-glob-and-write-back-with-named-tag--the-parity-by-construction-tes.md)
- [§the-three-named-test-files for the three-test-mode pattern (first-explicit-observation)](endo-but-for-bots--pkg-compartment-mapper-designs-subpath-pattern-replacement--node-parity-by-construction-with-shared-assertions-and-string-token-not-glob-and-write-back-with-named-tag--the-three-named-test-files-for.md)
- [§the-named-fixture-package-shape (first-explicit-observation)](endo-but-for-bots--pkg-compartment-mapper-designs-subpath-pattern-replacement--node-parity-by-construction-with-shared-assertions-and-string-token-not-glob-and-write-back-with-named-tag--the-named-fixture-package-shap.md)
- [§the-ten-row-Cases-Covered-table (first-explicit-observation)](endo-but-for-bots--pkg-compartment-mapper-designs-subpath-pattern-replacement--node-parity-by-construction-with-shared-assertions-and-string-token-not-glob-and-write-back-with-named-tag--the-ten-row-cases-covered-tabl.md)
- [§the-import-patterns-NOT-propagated discipline (first-explicit-observation)](endo-but-for-bots--pkg-compartment-mapper-designs-subpath-pattern-replacement--node-parity-by-construction-with-shared-assertions-and-string-token-not-glob-and-write-back-with-named-tag--the-import-patterns-not-propag.md)
- [Patterns from prior cycles, reaffirmed](endo-but-for-bots--pkg-compartment-mapper-designs-subpath-pattern-replacement--node-parity-by-construction-with-shared-assertions-and-string-token-not-glob-and-write-back-with-named-tag--patterns-from-prior-cycles-reaffirmed.md)
- [Borrowing tiers](endo-but-for-bots--pkg-compartment-mapper-designs-subpath-pattern-replacement--node-parity-by-construction-with-shared-assertions-and-string-token-not-glob-and-write-back-with-named-tag--borrowing-tiers.md)
- [Synthesis target](endo-but-for-bots--pkg-compartment-mapper-designs-subpath-pattern-replacement--node-parity-by-construction-with-shared-assertions-and-string-token-not-glob-and-write-back-with-named-tag--synthesis-target.md)
- [Single most structurally interesting move](endo-but-for-bots--pkg-compartment-mapper-designs-subpath-pattern-replacement--node-parity-by-construction-with-shared-assertions-and-string-token-not-glob-and-write-back-with-named-tag--single-most-structurally-interesting-move.md)
