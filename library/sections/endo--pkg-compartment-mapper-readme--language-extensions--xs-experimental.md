---
title: XS (experimental)
source: packages/compartment-mapper/README.md
source_repo: endojs/endo
source_commit: ee87476e0efcf8f6e412eec93eba5f3853ead6f3
source_date: 2024-12-15
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [bundles, compartments, tooling]
status: current
parent: endo--pkg-compartment-mapper-readme--language-extensions
---

The Compartment Mapper can use native XS `Compartment` and `ModuleSource` under
certain conditions:

1. The application must be an XS script that was compiled with the `xs`
  package condition.
  This causes `ses`, `@endo/module-source`, and `@endo/import-bundle` to
  provide slightly different implementations that can fall through to native
  behavior.
2. The application must opt-in with the `__native__: true` option on any
  of the compartment mapper methods that import modules like `importLocation`
  and `importArchive`.

Source: [packages/compartment-mapper/README.md](https://github.com/endojs/endo/blob/ee87476e0efcf8f6e412eec93eba5f3853ead6f3/packages/compartment-mapper/README.md) at commit `ee87476e`.
