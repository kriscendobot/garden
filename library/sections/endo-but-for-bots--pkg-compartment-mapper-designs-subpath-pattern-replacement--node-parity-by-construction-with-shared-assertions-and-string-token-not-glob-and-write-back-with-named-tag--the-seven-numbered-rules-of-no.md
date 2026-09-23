---
title: §the-seven-numbered-Rules-of-Node.js-subpath-semantics (first-explicit-observation)
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

The Rules subsection enumerates **seven numbered rules** for Node.js subpath pattern semantics:

1. **One `*` per side.** Having zero `*` on one side and one on the other is an error.
2. **`*` matches any substring**, including substrings that contain `/`.
3. **Exact entries take precedence** over pattern entries.
4. **Pattern specificity.** Longest matching prefix wins.
5. **Null targets** can exclude subpaths.
6. **Conditional patterns.** Pattern values can be condition objects.
7. **No `**` (globstar).** Globstar entries are silently ignored.

**§the-seven-named-rules-as-named-specification-shape** (first-explicit-observation): a design that **enumerates the upstream spec it's matching**, not just the design's response to it. The spec IS the contract; the implementation MUST honor each numbered rule.

§the-implementation-must-honor-the-numbered-upstream-spec IS distinct from §the-implementation-defines-its-own-rules — this design takes the former discipline.
