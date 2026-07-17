---
title: resolutions (Yarn's dependency override dialect)
source: packages/docusaurus/static/configuration/manifest.json
source_repo: yarnpkg/berry
source_commit: ab0afaf88dcbf6eb52731d0bc25bbe9fed655f8b
source_date: 2025-04-07
source_authors: [Gautier Ben Aïm, Maël Nison]
ingested: 2026-07-17
ingested_by: scholar
topics: [package-manifest, node-packaging]
status: current
---

Abstract: Yarn's `resolutions` field is its dialect of the transitive-dependency override — the counterpart to npm's `overrides` and pnpm's `overrides`. It instructs Yarn to use a specific resolution (a specific package version) instead of whatever the resolver would normally pick: useful to force every package onto a single version of a dependency, or to backport a fix. The resolution key accepts **one level of specificity**, and unlike npm's nested-object selectors, Yarn uses a flat glob-path key syntax. It can be set **only at the root of the project** (a warning is emitted if used in any non-root workspace). This is the reference for the Yarn cell of the override-dialects row in the property-consumer matrix.

## The `resolutions` field

`resolutions` overrides the resolutions of specific dependencies. The key syntax accepts one level of specificity, so all of the following forms are correct (from the schema's own examples):

- `"relay-compiler": "3.0.0"` — force every `relay-compiler` in the tree to `3.0.0`.
- `"webpack/memory-fs": "0.4.1"` — force the `memory-fs` dependency **of `webpack`** to `0.4.1` (a package-scoped selector: `<parent>/<dep>`).
- `"@babel/core/json5": "2.1.0"` — scoped-package parent, forcing its `json5` dependency.
- `"@babel/core/@babel/generator": "7.3.4"` — scoped parent and scoped dependency.
- `"@babel/core@npm:7.0.0/@babel/generator": "7.3.4"` — pin the parent to a *specific version* (`@npm:7.0.0`) before selecting its `@babel/generator` dependency.

When a path is relative (as it can be with the `file:` and `portal:` protocols), it is resolved relative to the path of the project. The `resolutions` field **can only be set at the root of the project**, and generates a warning if used in any other workspace.

## How it differs from npm `overrides` / pnpm `overrides`

Same job (force a transitive version), three dialects:

- **Yarn `resolutions`**: flat glob-path keys (`parent/dep`, `parent@version/dep`), one level of specificity per key. Bun also reads `resolutions` for Yarn-migration compatibility.
- **npm `overrides`**: nested-object selectors, version-scoped parent keys (`"bar@2.0.0"`), and `$name` references to a direct dependency's spec.
- **pnpm `overrides`**: since pnpm v11 lives in `pnpm-workspace.yaml` (not the `pnpm` manifest block), with `parent>dep` selectors, `catalog:` references, and `-` removal.

Porting a project between managers requires translating the dialect; a mistranslation silently fails to pin the intended version.

Source: [packages/docusaurus/static/configuration/manifest.json](https://github.com/yarnpkg/berry/blob/ab0afaf88dcbf6eb52731d0bc25bbe9fed655f8b/packages/docusaurus/static/configuration/manifest.json) at commit `ab0afaf`.
