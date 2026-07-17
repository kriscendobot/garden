---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-07-17T14:43:56Z
---
# result: scholar-package-json-package-managers

Follow-on to scholar-package-json-schema-and-tooling. Ingested how Yarn Berry, pnpm, Bun, and Corepack consume `package.json` as library sources at pinned commits, and library-backed the package-manager rows that were previously flagged **(synthesis)** in the `package-json` project report.

## Library sources ingested (6 sources, 10 sections)

- **yarn-berry--manifest-schema** (yarnpkg/berry `packages/docusaurus/static/configuration/manifest.json` @ `ab0afaf`) — 3 sections: `resolutions` (override dialect), dependency-metadata (`dependenciesMeta` built/optional/unplugged, `peerDependenciesMeta.optional`, peer-dependencies-with-default), publishing-and-install-config (`publishConfig`, `installConfig`, `packageManager`, os/cpu/libc).
- **pnpm--package-json** (pnpm/pnpm.io `docs/package_json.md` @ `047db9a`) — 2 sections: pnpm-field-moved-and-engines (the v11 move of the `pnpm` block to `pnpm-workspace.yaml`; engines/engines.runtime/devEngines), dependencies-meta-and-publishconfig (`dependenciesMeta.injected`, `peerDependenciesMeta.optional`, pnpm publishConfig).
- **pnpm--settings** (pnpm/pnpm.io `docs/settings.md` @ `0cf4bd3`) — 2 sections: overrides (in pnpm-workspace.yaml), package-extensions-and-peer-rules (`packageExtensions`, `peerDependencyRules`).
- **bun--overrides** (oven-sh/bun `docs/pm/overrides.mdx` @ `16a7269`) — 1 section: reads npm `overrides` + Yarn `resolutions`, top-level only.
- **bun--lifecycle** (oven-sh/bun `docs/pm/lifecycle.mdx` @ `16a7269`) — 1 section: `trustedDependencies` / default-secure lifecycle policy (replaces, not extends; npm sources only).
- **corepack--readme** (nodejs/corepack `README.md` @ `05bc5f3`) — 1 section: the `packageManager` field and `devEngines.packageManager`, consumed by Corepack.

## Indexing

- Topic `package-manifest`: 10 section rows added (via insert-sections-table-row.sh).
- Concept `dependency-overrides`: 5 section rows + a "Common confusions" block on the pnpm-v11 move and Bun's top-level-only limitation.
- Two new concept pages: `package-manager-pinning` (packageManager + Corepack) and `lifecycle-script-trust` (trustedDependencies / default-secure installs); both added to `concepts/README.md`.
- `sources/README.md`: 6 rows added under "Package-manifest runtime sources".
- `keywords.md`: 17 keywords added (resolutions, trustedDependencies, packageManager, Corepack, peerDependencyRules, dependenciesMeta.injected, peer-dependencies-with-default, ...).

## Project report updated (projects/package-json/)

- README: coverage status + Curated-sources note updated; the `scholar-package-json-package-managers` deferred bullet marked **done**, with remaining layout work named.
- property-consumer-matrix.md: un-flagged the Yarn/pnpm/Bun/`packageManager` synthesis rows and rewrote the per-consumer prose (Yarn, pnpm, Bun) with library citations. Corrected pnpm's override-block location (pnpm-workspace.yaml since v11, not the `pnpm` manifest key).
- inconsistencies.md: §6 (peer differences), §7 (override dialects — retitled "library-backed"), §8 (Bun), §4 and §9 tails updated with citations and the pnpm-v11 correction.

## Key correction surfaced

The prior synthesis placed pnpm's override dialect under a `pnpm` block in `package.json`. Since **pnpm v11**, pnpm no longer reads settings from that field — `overrides`/`packageExtensions`/`peerDependencyRules`/`patchedDependencies` live in `pnpm-workspace.yaml`. Corrected in the matrix, inconsistencies, and the dependency-overrides concept.

## Deferred (follow-on posted)

Posted **scholar-package-json-pm-layout**: the layout internals still synthesis — Yarn PnP strict-visibility + `.yarnrc.yml` packageExtensions + install-modes + `workspace:*` grammar; pnpm symlinked `node_modules/.pnpm` store + `pnpm-workspace.yaml` `packages:` workspaces + `patchedDependencies` + how-peers-are-resolved; Bun workspaces + isolated-installs; Yarn Classic v1 specifics. (The Bun `bun` export condition was already library-backed by a peer's `bun--docs-runtime-module-resolution-mdx` ingest.)

## Integrity gate

- `library-link-check.sh --source-slug` passed for all 6 sources.
- `regenerate-topics-counts.sh --check`: current after `--land` (package-manifest count reconciled).
- `regenerate-sections-index.sh`: sections index already current (all 10 new sections present in `sections/README.md`).

Budget note: 6 small sources (slightly above the 3–5 guide) but ~10 sections, well within the 25-section budget; each Bun/Corepack source is a single short doc.

Self-improvement: The predecessor's `scholar-package-json-schema-and-tooling` posted follow-ons named per consumer *family* (bundlers, package-managers, typescript, runtimes) but did NOT decompose the package-managers job into a manifest-fields cycle vs a layout-internals cycle — so one job carried both the (small, doc-backed) override/peer/publish fields and the (large, multi-doc) PnP/pnpm-store/workspaces layout. Splitting on that seam mid-cycle (manifest fields now, layout via the posted `-pm-layout` follow-on) fit one budget cleanly; future multi-tool ingests should pre-split manifest-field coverage from install-layout coverage, since they draw on different source docs and have very different budgets.
