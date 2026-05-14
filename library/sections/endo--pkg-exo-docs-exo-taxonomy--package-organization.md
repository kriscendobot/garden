---
title: Package Organization
source: packages/exo/docs/exo-taxonomy.md
source_repo: endojs/endo
source_commit: 01ba3f7d57c9
source_date: 2023-01-27
source_authors: [Mark S. Miller]
ingested: 2026-05-14
ingested_by: scholar
topics: [exo]
status: current
---

> Abstract: Where the Exo-making functions live: the @endo/exo package exports the heap-variant make/define functions; the durable variants live in the upstream consumer (typically @agoric/vat-data or similar). Endo's exo package is the heap-variant baseline; durable extensions are downstream additions.

## Package Organization

This `@endo/exo` package itself exports only the heap variants:

- `makeExo`
- `defineExoClass`
- `defineExoClassKit`

The virtual and durable variants are contributed by higher layer packages that build upon it, such as `@agoric/vat-data`.

Source: [packages/exo/docs/exo-taxonomy.md](https://github.com/endojs/endo/blob/01ba3f7d57c9/packages/exo/docs/exo-taxonomy.md) at commit `01ba3f7d`.
