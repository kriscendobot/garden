---
title: §the-pure-string-operation-discipline (first-explicit-observation)
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

> "Pattern resolution in the compartment-mapper is a pure string operation with no filesystem access."

**§the-pure-function-discipline-named-explicitly** (first-explicit-observation in this context): the design names a load-bearing property of the matcher: **no I/O**. This is the discipline that lets the matcher run inside SES, inside archives, and inside any context where filesystem access is unavailable. The rejection of array-fallback-values IS *because* it would require I/O — the pure-string property is the named constraint that drives the rejection.

§the-named-purity-discipline-determines-the-eschewed-alternative: when the purity property IS the design's named constraint, anything that violates it becomes ipso facto eschewed.
