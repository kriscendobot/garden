---
title: §the-named-fixture-package-shape (first-explicit-observation)
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

The primary fixture (`fixtures-package-imports-exports`) contains **five named packages** each representing a tested behavior:

- **`patterns-lib`** — basic exports with patterns + exact + null + specificity + #-imports.
- **`cond-patterns-lib`** — conditional pattern with `blue-moon` and `default` branches.
- **`multi-star-lib`** — multi-`*` pattern (silently ignored).
- **`multi-star-lib`** + **`globstar-lib`** — silently-ignored shapes.
- **`app`** — entry package consuming all the above.

**§the-named-package-IS-the-named-test-case** (first-explicit-observation): each package's *name* documents the behavior it tests. This is **§the-fixture-package-IS-self-documenting**.

§the-`cond-`-prefix-on-package-name IS the named conditional-pattern variant; §the-`multi-star-` and §the-`globstar-` prefixes name silently-rejected shapes. The prefix-naming-convention encodes the test taxonomy.
