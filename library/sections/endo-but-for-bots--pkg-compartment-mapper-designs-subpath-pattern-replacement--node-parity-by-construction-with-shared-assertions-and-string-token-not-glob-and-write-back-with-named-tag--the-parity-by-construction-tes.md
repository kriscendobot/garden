---
title: §the-Parity-by-construction testing discipline (first-explicit-observation)
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

> "Each fixture is exercised by both Node.js and the Compartment Mapper. Assertions are shared via `_subpath-patterns-assertions.js`, so parity is verified by construction: if both test suites pass, the behaviors are equivalent."

**§the-parity-IS-verified-by-construction-not-by-comparison** (first-explicit-observation): rather than write tests that *compare* Node.js output to Compartment Mapper output, the design **shares the assertion file between the two test suites**. Each test suite passes iff its implementation matches the shared expected output. **If both pass, parity is structurally guaranteed**.

§the-shared-assertion-file-IS-the-parity-mechanism (`_subpath-patterns-assertions.js`). The single source of truth is the assertion file; the two implementations meet there. §the-leading-underscore-IS-the-private-helper-convention in JS test conventions.

§the-by-construction-IS-distinct-from-by-comparison: the latter says "compare A's output to B's output and assert equal"; the former says "both must satisfy the same assertion, and the assertion is the spec".
