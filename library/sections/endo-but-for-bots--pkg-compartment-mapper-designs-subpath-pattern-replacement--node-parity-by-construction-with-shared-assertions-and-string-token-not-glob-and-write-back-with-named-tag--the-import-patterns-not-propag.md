---
title: §the-import-patterns-NOT-propagated discipline (first-explicit-observation)
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

> "Import patterns (starting with `#`) are **not** propagated — they are internal to the declaring package."

**§the-imports-IS-package-private + the-exports-IS-cross-package** as named asymmetry. The `#`-prefix in `imports` IS the named *private*-marker; the absence of any prefix in `exports` IS the named *public*-marker.

§the-`#`-prefix-IS-the-named-internal-marker IS sibling-pattern to JS class private-field-`#` syntax. The two `#` conventions converge on the same idea: `#`-prefix = package-internal.
