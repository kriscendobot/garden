---
title: §the-write-back-pattern-with-named-`__createdBy` tag (first-explicit-observation)
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

> "When a pattern matches, the resolved path is written back into `moduleDescriptors` as a concrete entry (with `__createdBy: 'link-pattern'`). This write-back serves three purposes: caching subsequent imports of the same specifier, enabling policy enforcement (which checks `modules[specifier]`), and capturing the expansion for archival."

**§the-named-double-underscore-tag-as-provenance-marker** (first-explicit-observation): the `__createdBy: 'link-pattern'` field names *which subsystem* created the concrete entry. The double-underscore prefix IS the convention for internal-use marker fields.

**§the-three-named-purposes-of-the-write-back** (first-explicit-observation):

1. **Caching subsequent imports** of the same specifier.
2. **Enabling policy enforcement** (which checks `modules[specifier]`).
3. **Capturing the expansion for archival**.

§the-three-named-purposes-of-one-mechanism shape: a single design move (write-back) explicitly serves three named concerns. §the-design-names-the-purposes-not-just-the-mechanism.

§the-write-back-IS-the-name-for-this-pattern: the value is computed once on demand, then memoized as if it had been computed eagerly. Sibling-pattern to memoization but with explicit cross-system propagation.
