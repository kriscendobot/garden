---
title: packageExtensions and peerDependencyRules (pnpm-workspace.yaml)
source: docs/settings.md
source_repo: pnpm/pnpm.io
source_commit: 0cf4bd35393b8d3712debd5a301bcdf2163d5b69
source_date: 2026-06-24
source_authors: [Zoltan Kochan, Dasa Paddock, Igal Klebanov, Ilya Priven]
ingested: 2026-07-17
ingested_by: scholar
topics: [package-manifest, node-packaging]
status: current
---

Abstract: pnpm's two complementary tools for correcting the dependency ecosystem, both in `pnpm-workspace.yaml` since v11. `packageExtensions` extends existing package definitions with additional metadata — for example adding a missing `peerDependencies` entry to `react-redux` — and may extend `dependencies`, `optionalDependencies`, `peerDependencies`, and `peerDependenciesMeta`; keys are package names or name+semver ranges. pnpm and Yarn co-maintain a shared `@yarnpkg/extensions` database of these patches, and authors are encouraged to contribute upstream. `peerDependencyRules` relaxes pnpm's (stricter than npm's) peer-dependency handling: `ignoreMissing` (suppress missing-peer warnings for named packages or glob patterns), `allowedVersions` (accept an out-of-range peer version, optionally scoped to a specific parent via the `parent>peer` selector), and `allowAny` (accept any version for matching packages, muting all mismatch warnings). This backs the pnpm cells of the `packageExtensions` and peer-dependency-behavior rows in the property-consumer matrix.

## packageExtensions

`packageExtensions` extends existing package definitions with additional information. For example, if `react-redux` should list `react-dom` in its `peerDependencies` but does not, patch it:

```yaml
packageExtensions:
  react-redux:
    peerDependencies:
      react-dom: "*"
```

Keys are package names, optionally with a semver range to patch only some versions (`react-redux@1:`). The fields that may be extended: `dependencies`, `optionalDependencies`, `peerDependencies`, and `peerDependenciesMeta`. A larger example patches an `optionalDependencies` entry on `express@1` and adds `dependencies` + `peerDependencies` + `peerDependenciesMeta` to `fork-ts-checker-webpack-plugin`. pnpm and Yarn jointly maintain a database of `packageExtensions` to patch broken ecosystem packages; contributors are encouraged to send extensions upstream to the `@yarnpkg/extensions` database. (Contrast with `overrides`, which changes what an existing edge *resolves to*; `packageExtensions` adds or corrects the metadata that *creates* the edge.)

## peerDependencyRules

Relaxes pnpm's peer-dependency reporting (pnpm surfaces peer issues more loudly than npm's auto-install default):

- **`peerDependencyRules.ignoreMissing`**: pnpm will not warn about missing peers from this list. Accepts names and glob patterns (`"@babel/*"`, `"@eslint/*"`).
- **`peerDependencyRules.allowedVersions`**: suppress the unmet-peer warning for peers of a specified range — for example `react: "17"` tells pnpm any dependency wanting `react` in its peers may accept `react@17`. It can be scoped to specific parents: `"button@2>react": "17"` allows `react@17` only in `button@2`'s peers; `"card>react": "17"` only in any `card`'s.
- **`peerDependencyRules.allowAny`**: an array of package-name patterns; any matching peer resolves from any version regardless of the declared range, muting all version-mismatch warnings for those packages (`"@babel/*"`, `"eslint"`).

Source: [docs/settings.md](https://github.com/pnpm/pnpm.io/blob/0cf4bd35393b8d3712debd5a301bcdf2163d5b69/docs/settings.md) at commit `0cf4bd3`.
