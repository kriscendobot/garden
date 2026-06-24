---
source: packages/patterns/README.md
source_repo: endojs/endo
source_commit: 14a0b631832ff516b4cafa3946a4a3c0ccbcf052
source_date: 2026-01-04
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
section_count: 10
status: current
notes: Source has many H3 sub-sections under most H2s. Kept consolidated at H2 boundaries because each H2 is itself a coherent topic (matchers, matching, collections, guards, key comparison) rather than a thin wrapper around substantively-different H3s; the H3 enumerations remain visible inside the H2-bounded section bodies.
---

> Abstract: The @endo/patterns package README. Defines the M namespace (declarative pattern constructors), the matching API (matches, mustMatch), the Copy Collections data types (CopySet, CopyBag, CopyMap), Interface Guards used by Exo, key-comparison primitives (keyEQ, compareKeys), the Key/Pattern/Passable inclusion hierarchy, and integration points. Patterns occupies the shape-and-validation layer between pass-style (transport types) and exo (using shapes as guards).

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/endo--pkg-patterns-readme--overview.md) | patterns | current |
| [quick-start](../sections/endo--pkg-patterns-readme--quick-start.md) | patterns | current |
| [m-namespace](../sections/endo--pkg-patterns-readme--m-namespace.md) | patterns | current |
| [pattern-matching](../sections/endo--pkg-patterns-readme--pattern-matching.md) | patterns | current |
| [copy-collections](../sections/endo--pkg-patterns-readme--copy-collections.md) | patterns, pass-style | current |
| [interface-guards](../sections/endo--pkg-patterns-readme--interface-guards.md) | patterns, exo | current |
| [key-comparison](../sections/endo--pkg-patterns-readme--key-comparison.md) | patterns | current |
| [key-pattern-passable-hierarchy](../sections/endo--pkg-patterns-readme--key-pattern-passable-hierarchy.md) | patterns, pass-style | current |
| [integration-with-endo](../sections/endo--pkg-patterns-readme--integration-with-endo.md) | patterns | current |
| [deep-dives](../sections/endo--pkg-patterns-readme--deep-dives.md) | patterns | current |

## Provenance

- File last modified 2026-01-04 by Kris Kowal.
- Captured at endo file-specific commit `14a0b631`.

Source: [packages/patterns/README.md](https://github.com/endojs/endo/blob/14a0b631832ff516b4cafa3946a4a3c0ccbcf052/packages/patterns/README.md).
