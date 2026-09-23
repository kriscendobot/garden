---
source_kind: repo-doc
source_repo: yarnpkg/berry
source_path: packages/docusaurus/static/configuration/manifest.json
source_commit: ab0afaf88dcbf6eb52731d0bc25bbe9fed655f8b
source_date: 2025-04-07
source_authors: [Gautier Ben Aïm, Maël Nison]
ingested: 2026-07-17
ingested_by: scholar
section_count: 3
status: current
---

Abstract: Yarn Berry's (v2+) authoritative `package.json` field catalog — the JSON Schema that generates the yarnpkg.com "Manifest (package.json)" reference page. It is the primary source for the Yarn column of the package.json consumer matrix, covering the fields Yarn reads that diverge from npm: `resolutions` (Yarn's override dialect, glob-path selectors with one level of specificity, root-only), `dependenciesMeta` (`built`/`optional`/`unplugged` per-dependency toggles) and the Yarn extension of "peer dependencies with default" (a dependency listed in both `dependencies` and `peerDependencies`), `peerDependenciesMeta.optional`, `publishConfig` (per-field publish-time replacements of `main`/`module`/`browser`/`bin`/`type`/`registry` plus `access`/`provenance`/`executableFiles`), `installConfig` (`hoistingLimits`, `selfReferences`), the `packageManager` Corepack field, `workspaces`, and the shared `type`/`os`/`cpu`/`libc`/`optionalDependencies`/`files`/`preferUnplugged` fields. Note: Yarn Berry's `packageExtensions` and the PnP strict-visibility model are configured in `.yarnrc.yml` / the PnP feature docs, not this manifest schema, and are deferred to a follow-on ingest. This backs the Yarn Berry synthesis rows previously flagged in the `package-json` project's property-consumer matrix and inconsistencies topics.

| Section | Topics | Status |
|---------|--------|--------|
| [resolutions](../sections/yarn-berry--manifest-schema--resolutions.md) | package-manifest, node-packaging | current |
| [dependency-metadata](../sections/yarn-berry--manifest-schema--dependency-metadata.md) | package-manifest, node-packaging | current |
| [publishing-and-install-config](../sections/yarn-berry--manifest-schema--publishing-and-install-config.md) | package-manifest, node-packaging | current |

Source: [packages/docusaurus/static/configuration/manifest.json](https://github.com/yarnpkg/berry/blob/ab0afaf88dcbf6eb52731d0bc25bbe9fed655f8b/packages/docusaurus/static/configuration/manifest.json) at commit `ab0afaf`.
