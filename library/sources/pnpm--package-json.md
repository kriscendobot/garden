---
source_kind: repo-doc
source_repo: pnpm/pnpm.io
source_path: docs/package_json.md
source_commit: 047db9af593b88a141cf7810ea9c0c8cf2354292
source_date: 2026-05-25
source_authors: [Erick Zhao, Khải, Mister-Hope, Nikoloz Buligini]
ingested: 2026-07-17
ingested_by: scholar
section_count: 2
status: current
---

Abstract: pnpm's own `package.json` reference — the fields pnpm reads directly from the manifest, and the pivotal note that **since pnpm v11, pnpm no longer reads its settings from the `pnpm` field of `package.json`**; those settings (`overrides`, `packageExtensions`, `peerDependencyRules`, `patchedDependencies`, …) now live in `pnpm-workspace.yaml` (see the companion `pnpm--settings` source). What remains in `package.json` for pnpm: `engines` (advisory unless `engineStrict`), the newer `engines.runtime` / `devEngines.runtime` (auto-download and pin a JS runtime) and `devEngines.packageManager` (a version-range pin for pnpm itself, resolved into the lockfile — unlike the exact `packageManager` field), `dependenciesMeta.<pkg>.injected` (install a workspace package as a hard-linked copy in the virtual store so different consumers can satisfy its peer dependencies differently), `peerDependenciesMeta.<pkg>.optional`, and pnpm's extended `publishConfig` (field replacements plus `directory`, `linkDirectory`, `executableFiles`). This backs the pnpm cells of the property-consumer matrix and corrects the earlier synthesis that placed the override dialect under a `pnpm` manifest block.

| Section | Topics | Status |
|---------|--------|--------|
| [pnpm-field-moved-and-engines](../sections/pnpm--package-json--pnpm-field-moved-and-engines.md) | package-manifest, node-packaging | current |
| [dependencies-meta-and-publishconfig](../sections/pnpm--package-json--dependencies-meta-and-publishconfig.md) | package-manifest, node-packaging | current |

Source: [docs/package_json.md](https://github.com/pnpm/pnpm.io/blob/047db9af593b88a141cf7810ea9c0c8cf2354292/docs/package_json.md) at commit `047db9a`.
