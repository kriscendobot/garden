---
source: doc/design/package-taxonomy.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
section_count: 5
status: current
---

> Abstract: The organization and naming conventions for CASK's packages. It catalogs seven package categories (user-facing block structures, `*tree` block backbones, dependency-free `go/*` utilities, `*buffer` in-memory tables, `*store` block backends, network/transport, telemetry/testing), contrasts the two backbones (sparse associative `hashtree` vs dense sequential `arraytree`) and how the typed-array packages share `arraytree`, states the naming and Go-package-declaration rules (`cask`-prefixed declarations under `cask/`, bare names under `cask/go/`), names the two cross-cutting design patterns (the `(root, args) → root` reducer and the parallel-array column layout), and sketches two anticipated structures (a Rabin-chunked sorted array and a circular doubly-linked list). Pairs with the README-derived `cask--readme--package-taxonomy` section, which gives the same taxonomy at a higher level.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [package-categories](../sections/cask--package-taxonomy--package-categories.md) | data-structures, content-addressed-storage | current |
| [hashtree-vs-arraytree](../sections/cask--package-taxonomy--hashtree-vs-arraytree.md) | data-structures, content-addressed-storage | current |
| [naming-conventions](../sections/cask--package-taxonomy--naming-conventions.md) | data-structures, repository-governance | current |
| [design-patterns](../sections/cask--package-taxonomy--design-patterns.md) | data-structures, content-addressed-storage | current |
| [future-structures](../sections/cask--package-taxonomy--future-structures.md) | data-structures | current |

## Provenance

- Repository default branch `main`; file last modified 2026-02-14 by Kris Kowal.
- Soft-flag overlap with `cask--readme--package-taxonomy` (the README's higher-level statement of the same taxonomy) and with `doc/design/parallel-arrays.md` (the in-depth treatment of the reducer and parallel-array patterns this doc summarizes). Both are current at different abstraction levels, not contradictions.

Source: [doc/design/package-taxonomy.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/package-taxonomy.md) at commit `cdb975d8`.
