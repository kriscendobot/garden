---
title: Single most structurally interesting move
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

**§the-Parity-by-construction testing discipline** with **§the-shared-assertion-file-IS-the-parity-mechanism** — rather than writing a comparison test ("does A == B?"), the design **shares the assertion file between the two test suites**. Each test suite passes iff its implementation matches the shared expected output. **If both pass, parity is structurally guaranteed by the shared file**, not by an explicit comparison step.

This is a profound testing-design move: it converts a *runtime correctness check* (does the implementation behave like the spec?) into a *structural invariant* (the spec IS the assertion file; both implementations meet there). The pattern generalizes far beyond subpath patterns: any time you have two implementations of the same spec, sharing the test fixtures + assertions makes parity a property of the file system, not the test runner.

§the-shared-assertion-file-as-named-cross-implementation-spec-anchor: the assertion file IS the spec; the implementations meet at the spec; parity emerges from co-location, not from comparison.
